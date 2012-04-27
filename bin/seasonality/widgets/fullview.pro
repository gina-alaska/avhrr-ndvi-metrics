;=========================;
; EVENT HANDLER: FULLVIEW ;
;=========================;
PRO FullView_Event, ev
COMMON DRSLUTINFO, LineFile, NDVIctFile, saved_REDct, saved_GREENct, saved_BLUEct  ;ugly!


   Widget_Control, ev.id, Get_UValue=UValue
   Widget_Control, ev.top, Get_UValue=mLocal
   Widget_Control, mLocal.wParent, Get_UValue=mParent



; ========= Motion Send Position Event =========
   FullView_Motion, ev

; ========= Left Mouse Button Pressed =========
   IF (ev.press eq 1) THEN FullView_Left_Button_Press, mLocal, ev


; ========= Left Mouse Button Released =========
   IF (ev.release eq 1) THEN FullView_Left_Button_Release, mLocal


; ========= Left Mouse Button Click and Drag =========
   IF (ev.type EQ 2 and mLocal.MouseClick[0] EQ 1) THEN $
       FullView_Left_ClickAndDrag, mLocal, ev


; ========= Right Mouse Button Pressed =========
   IF (ev.press EQ 4) THEN FullView_Right_Button_Press, mLocal, ev


; ========= Scroll Bars Moved =========
   IF (ev.type EQ 3) THEN FullView_Scroll_Bars_Moved, mLocal


   Widget_Control, ev.top, Set_UValue=mLocal

END
;=======================;
; EVENT HANDLER: MOTION ;
;=======================;
PRO FullView_Motion, ev
   Widget_Control, ev.top, Get_UValue=mLocal
   Widget_Control, mLocal.wParent, Get_UValue=mParent

; ========= FAKE EVENT TO SEND TO POSITION MONITOR =========
   IF(NOT Widget_Info(mParent.wPosition, /Valid_ID)) THEN $
      mParent.wPosition=cw_projpos(mParent)
      Widget_Control, mParent.wBase, Set_UValue=mParent
      Widget_Control, mParent.wOpenFile, Get_UValue=mInfo
       x = (0 > ev.x) < (mInfo.ns-1)
       y = (0 > (mInfo.nl-ev.y-1)) < (mInfo.nl - 1)

      FakeEvent={WIMAGE $
                , id: ev.id $
                , top: ev.top $
                , handler: mParent.wPosition $
                , x: x $
                , y: y $
                }

      if(Widget_Info(mParent.wPosition, /Valid_ID)) THEN $
         Widget_Control, mParent.wPosition, Send_Event=FakeEvent

; ========= FAKE EVENT TO SEND TO COVER TYPE MONITOR =========
      value=long(mLocal.Image[x,y])
      CASE (mLocal.mClassInfo.attExist) OF
         0: cover='<NO DATA>'
         1: BEGIN
               covervalue=long(mLocal.mClassInfo.lccImage[x,y])
               cover=mLocal.mClassInfo.attTable[covervalue]
            END
         ELSE:
      ENDCASE
      FakeEvent={WCOVERMOTION $
                , id: ev.id $
                , top: ev.top $
                , handler: mParent.wCoverType $
                , x: x $
                , y: y $
                , value:value $
                , cover:cover $
                }

      if(Widget_Info(mParent.wCoverType, /Valid_ID)) THEN $
         Widget_Control, mParent.wCoverType, Send_Event=FakeEvent

   Widget_Control, ev.top, Set_UValue=mLocal
END; FullView_Motion

;==================================;
; EVENT HANDLER: LEFT_BUTTON_PRESS ;
;==================================;
PRO FullView_Left_Button_Press, mLocal, ev
      Widget_Control, mLocal.wFullView, Get_Value=wfd
      Widget_Control, mLocal.wParent, Get_UValue=mParent		;MJS-7/6/99
      Widget_Control, mParent.wOpenFile, Get_UValue=mInfo		;MJS-7/6/99
      wSet, wfd
      mLocal.MouseClick[0]=1

      mbox=mLocal.mFullBox       ; MJS-For some reason you can't send
      GetBox, ev.x, ev.y, mBox         ;     in mbox.mFullBox
      mLocal.mFullBox=mbox

      Draw_Box, mLocal.mFullBox, mLocal.mFullBoxOld, /Dev
      mLocal.mFullBoxOld = mLocal.mFullBox

      IF(NOT Widget_Info(mLocal.wZoomView, /Valid_ID)) THEN BEGIN
         mLocal.wZoomView=ZoomView(mLocal.wBase,  $
                                   XSize=2*mLocal.mFullBox.XBoxSize, $
                                   YSize=2*mLocal.mFullBox.YBoxSize)
         Widget_Control, mLocal.wZoomView, Map=0
      END

      Widget_Control, mLocal.wZoomView, TLB_GET_SIZE=TLBSize, Get_UValue=mZoomView

      Widget_Control, mZoomView.wZoomSlider, Get_Value=Zoom
      ZoomImage=GetZoomImage(ev.x, ev.y, mLocal.Image, mLocal.mFullBox, Zoom)
      Widget_Control, mZoomView.wZoomView, Get_Value=wzd
      wSet, wzd
      CASE (mLocal.CustomColor) OF
         0: tvscl, ZoomImage
         1: tv, scaleft(ZoomImage, FROM_MIN=mInfo.minVal, FROM_MAX=mInfo.minVal, TO_MIN=0, TO_MAX=200);MJS-7/6/99
         ELSE:
      ENDCASE


END; FullView_Left_Button_Press, mLocal

;===========================================;
; EVENT HANDLER: LEFT_BUTTON_CLICK_AND_DRAG ;
;===========================================;
PRO FullView_Left_ClickAndDrag, mLocal, ev
      Widget_Control, mLocal.wFullView, Get_Value=wfd
      Widget_Control, mLocal.wParent, Get_UValue=mParent		;MJS-7/6/99
      Widget_Control, mParent.wOpenFile, Get_UValue=mInfo		;MJS-7/6/99

      wSet, wfd
      mbox=mLocal.mFullBox       ; MJS-For some reason you can't send
      GetBox, ev.x, ev.y, mBox         ;     in mbox.mFullBox
      mLocal.mFullBox=mbox
      Draw_Box, mLocal.mFullBox, mLocal.mFullBoxOld, /Dev
      mLocal.mFullBoxOld = mLocal.mFullBox

      Widget_Control, mLocal.wZoomView, TLB_GET_SIZE=TLBSize, Get_UValue=mZoomView
      Widget_Control, mZoomView.wZoomSlider, Get_Value=Zoom
      ZoomImage=GetZoomImage(ev.x, ev.y, mLocal.Image, mLocal.mFullBox, Zoom)
      Widget_Control, mZoomView.wZoomView, Get_Value=wzd
      wSet, wzd
      CASE (mLocal.CustomColor) OF
         0: tvscl, ZoomImage
         1: tv, scaleft(ZoomImage, FROM_MIN=mInfo.minVal, FROM_MAX=mInfo.minVal, TO_MIN=0, TO_MAX=200);MJS-7/6/99
         ELSE:
      ENDCASE

END; FullView_Left_Button_Release, mLocal

;====================================;
; EVENT HANDLER: LEFT_BUTTON_RELEASE ;
;====================================;
PRO FullView_Left_Button_Release, mLocal
   mLocal.MouseClick[0]=0
END; FullView_Left_Button_Release, mLocal

;=================================================;
; EVENT HANDLER: RIGHT_BUTTON_PRESS : POP-UP MENU ;
;=================================================;
PRO FullView_Right_Button_Press, mLocal, ev
COMMON DRSLUTINFO, LineFile, NDVIctFile, saved_REDct, saved_GREENct, saved_BLUEct

   Widget_Control, mLocal.wParent, GET_UVALUE=mParent

   IF (NOT Widget_Info(mLocal.wPUM, /Valid_ID)) THEN BEGIN

      FMenuItems=['Zoom', 'Reduce','Position','Linework','Palette',$
                  'Cover Type', 'Viz Tool']

      tmp=CW_CheckPUM(Names=FMenuItems, XOffset=1, YOffset=1)
      tmpgeo=widget_Info(tmp, /geo)

      mLocal.wPUM=CW_CheckPUM(mLocal.wBase, Names=FMenuItems, $
               XOffset=1, YOffset=1, $
               xsize=tmpgeo.xsize, ysize=tmpgeo.ysize)

      Widget_Control, mLocal.wPUM, Map=1, Get_UValue=PUM
      PUM.Map=1
      Widget_Control, mLocal.wPUM, Set_UValue=PUM
   END ELSE BEGIN
      Widget_Control, mLocal.wPUM, Get_UValue=PUM
      PUM.Map=abs(PUM.Map - 1)
      Widget_Control, mLocal.wPUM, Map=PUM.Map, Set_UValue=PUM
   END

   Widget_Control, mLocal.wPUM, Get_UValue=PUM
   Widget_Control, PUM.wPUM, Get_Value=Value

;
; ZOOM WINDOW
;
   CASE (Value[0]) OF
   0: BEGIN
         IF(NOT Widget_Info(mLocal.wZoomView, /Valid_ID)) THEN $
            mLocal.wZoomView=ZoomView(mLocal.wBase,  $
                                      XSize=2*mLocal.mFullBox.XBoxSize, $
                                      YSize=2*mLocal.mFullBox.YBoxSize)
         Widget_Control, mLocal.wZoomView, Map=0
      END
   1: BEGIN
         IF(NOT Widget_Info(mLocal.wZoomView, /Valid_ID)) THEN $
            mLocal.wZoomView=ZoomView(mLocal.wBase,  $
                                      XSize=2*mLocal.mFullBox.XBoxSize, $
                                      YSize=2*mLocal.mFullBox.YBoxSize)
         Widget_Control, mLocal.wZoomView, Map=1
      END
   ELSE:
   ENDCASE

;
; REDUCE WINDOW
;
   CASE (Value[1]) OF
   0: BEGIN
         IF(NOT Widget_Info(mLocal.wReduceView, /Valid_ID)) THEN $
            mLocal.wReduceView=ReduceView(mLocal.wBase,  $
                            XSize=mLocal.mFullBox.XWinSize, $
                            YSize=mLocal.mFullBox.YWinSize, $
                            Image=mLocal.Image)
         Widget_Control, mLocal.wReduceView, Map=0
      END
   1: BEGIN
         IF(NOT Widget_Info(mLocal.wReduceView, /Valid_ID)) THEN $
            mLocal.wReduceView=ReduceView(mLocal.wBase,  $
                            XSize=mLocal.mFullBox.XWinSize, $
                            YSize=mLocal.mFullBox.YWinSize, $
                            Image=mLocal.Image)
         Widget_Control, mLocal.wReduceView, Map=1
      END
   ELSE:
   ENDCASE

;
; POSITION
;
   Widget_Control, mLocal.wParent, Get_UValue=mParent
   CASE (Value[2]) OF
   0: BEGIN
         IF(NOT Widget_Info(mParent.wPosition, /Valid_ID)) THEN $
            mLocal.wPosition =  cw_projpos(mParent)
            Widget_Control, mParent.wPosition, Map=0
      END
   1: BEGIN
         IF(NOT Widget_Info(mParent.wPosition, /Valid_ID)) THEN $
            mLocal.wPosition =  cw_projpos(mParent)
            Widget_Control, mParent.wPosition, Map=1
      END
   ELSE:
   ENDCASE; POSITION
   Widget_Control, mLocal.wParent, Set_UValue=mParent


;
; LINEWORK
;
   CASE (Value[3] + 2*mLocal.LinesShowing) OF
   1: BEGIN

        if (mLocal.LineFileDefined eq 0) then BEGIN
           Linefile = Dialog_PickFile(Title='Select Line File', $
                         Path='.', Filter='lines.txt',/MUST_EXIST)
           if (LineFile eq '') then return
           mLocal.LineFileDefined = 1
           mLocal.LineFile=LineFile
        endif

        Widget_Control, mLocal.wFullView, Get_Value=wfd
        wSet, wfd

        Widget_Control, mLocal.wReduceView, Get_UValue=mReduceView
        Widget_Control, mReduceView.wReduceView, Get_Value=wrd
        wSet, wrd
        DrawLineWork, mLocal, [wfd, wrd], [1, mReduceView.ZoomOut]


        mLocal.LinesShowing=1L

   END
   2:  BEGIN
        Widget_Control, mLocal.wFullView, Get_Value=wfd
        Widget_Control, mLocal.wParent, Get_UValue=mParent		;MJS-7/6/99
        Widget_Control, mParent.wOpenFile, Get_UValue=mInfo		;MJS-7/6/99

        wSet, wfd
        widget_control,/HourGlass
        tv, scaleft(mLocal.Image, FROM_MIN=mInfo.minVal, FROM_MAX=mInfo.minVal, TO_MIN=0, TO_MAX=200)

        Draw_Box, mLocal.mFullBox, mLocal.mFullBoxOld, /Dev, /ERASE
        mLocal.mFullBoxOld = mLocal.mFullBox

        Widget_Control, mLocal.wReduceView, Get_UValue=mReduceView
        Widget_Control, mReduceView.wReduceView, Get_Value=wrd

        wSet,wrd
        tv, scaleft(mReduceView.ReduceImage, FROM_MIN=mInfo.minVal, FROM_MAX=mInfo.minVal, TO_MIN=0, TO_MAX=200)
        Draw_Box, mReduceView.mReduceBox, mReduceView.mReduceBoxOld, /Dev, /ERASE
        mReduceView.mReduceBoxOld = mReduceView.mReduceBox
        Widget_Control, mLocal.wReduceView, Set_UValue=mReduceView

        mLocal.LinesShowing=0L
   END
   ELSE:
   ENDCASE

;
; COLOR PALETTE
;
   CASE (Value[4] + 2*mLocal.customColor) OF
   1: BEGIN
         if (mLocal.ColorFileDefined EQ 0) then BEGIN
            NDVIctFile = Dialog_PickFile(Title='Select Color Palette', $
                         Path='.', Filter='*.pal',/MUST_EXIST)
            if (NDVIctFile eq '') then return
            mLocal.ColorFileDefined = 1
            mLocal.NDVIctFile=NDVIctFile
         endif

         Widget_Control, mLocal.wReduceView, Get_UValue=mReduceView
         Widget_Control, mReduceView.wReduceSlider, Get_Value=CurrentBand

         IF(CurrentBand GE 0) THEN BEGIN
            lutvar=readct(NDVIctFile)
         END ELSE BEGIN
            IF(mLocal.mClassInfo.palExist) THEN $
               lutvar=readct(mLocal.mClassInfo.palFile, numColors=160)
         END


         Widget_Control, mReduceView.wReduceView, Get_Value=wrd
         wSet,wrd
         mlocal.customColor = 1L
   END

   2: BEGIN
         tvlct, saved_REDct, saved_GREENct, saved_BLUEct

         Widget_Control, mLocal.wReduceView, Get_UValue=mReduceView
         Widget_Control, mReduceView.wReduceView, Get_Value=wrd
         wSet,wrd
         mlocal.customColor = 0L
   END
   ELSE:
   ENDCASE; COLOR PALETTE


;
; Cover Type
;
   Widget_Control, mLocal.wParent, Get_UValue=mParent
   CASE (Value[5]) OF
   0: BEGIN
         IF(NOT Widget_Info(mParent.wCoverType, /Valid_ID)) THEN $
            mParent.wCoverType =  CW_CoverType(mLocal.wParent)
            Widget_Control, mParent.wCoverType, Map=0
      END
   1: BEGIN
         IF(NOT Widget_Info(mParent.wCoverType, /Valid_ID)) THEN $
            mParent.wCoverType =  CW_CoverType(mLocal.wParent)
            Widget_Control, mParent.wCoverType, Map=1
      END
   ELSE:
   ENDCASE; POSITION
   Widget_Control, mLocal.wParent, Set_UValue=mParent


;
; Viz Tool - MJS 5/28/99 - Dan's Viz Tool isn't connected, but below
;                          is some sample code to start it up.
;

   CASE (Value[6]) OF
      0:
      1: BEGIN
         print, 'Viz Tool Not Connected'
;            Widget_Control, mLocal.wParent, Get_UValue=mParent
;            widget_control, mParent.wOpenFile, GET_UVALUE=minfo
;            ddr = minfo.ddr
;            vuCube, mInfo.file, $
;               [mInfo.ns, mInfo.nl, mInfo.nb, mInfo.dt],$
;               [ddr.ul[1], ddr.ul[0], ddr.projdist[0]]
         END
      ELSE:
   END

END; FullView_Right_Button_Press

;=======================;
; EVENT HANDLER: RESIZE ;
;=======================;
PRO FullView_Resize_Event, ev

   Widget_Control, ev.top, Get_UValue=mLocal

   Widget_Control, mLocal.wBase, TLB_Get_Size=TLBSize
   Widget_Control, mLocal.wFullView, Scr_XSize=TLBSize[0]
   Widget_Control, mLocal.wFullView, Scr_YSize=TLBSize[1]

   geoFullView=Widget_Info(mLocal.wFullView, /Geometry)

;   Widget_Control, mLocal.wBase, SCR_XSize=geoFullView.SCR_XSize
 ;  Widget_Control, mLocal.wBase, SCR_YSize=geoFullView.SCR_YSize
   Widget_Control, mLocal.wBase, SCR_XSize=SCR_XSize
   Widget_Control, mLocal.wBase, SCR_YSize=SCR_YSize

;
; Resize Box in Reduce View
;
   IF(NOT Widget_Info(mLocal.wReduceView, /Valid_ID)) THEN BEGIN
            mLocal.wReduceView=ReduceView(mLocal.wBase,  $
                            XSize=mLocal.mFullBox.XWinSize, $
                            YSize=mLocal.mFullBox.YWinSize, $
                            Image=mLocal.Image)
         Widget_Control, mLocal.wReduceView, Map=0
   END

   Widget_Control, mLocal.wReduceView, Get_UValue=ReduceView
   ReduceView.mReduceBox.XBoxSize=geoFullView.XSize/ReduceView.ZoomOut
   ReduceView.mReduceBox.YBoxSize=geoFullView.YSize/ReduceView.ZoomOut
   Widget_Control, mLocal.wReduceView, Set_UValue=ReduceView

   Widget_Control, ev.top, Set_UValue=mLocal

END

;==================================;
; EVENT HANDLER: SCROLL_BARS_MOVED ;
;==================================;
PRO FullView_Scroll_Bars_Moved, mLocal

   IF(NOT Widget_Info(mLocal.wReduceView, /Valid_ID)) THEN BEGIN
      mLocal.wReduceView=ReduceView(mLocal.wBase,  $
                            XSize=mLocal.mFullBox.XWinSize, $
                            YSize=mLocal.mFullBox.YWinSize, $
                            Image=mLocal.Image)
      Widget_Control, mLocal.wReduceView, Map=0
   END

   Widget_Control, mLocal.wReduceView, Get_UValue=ReduceView

   Widget_Control, mLocal.wFullView, Get_Draw_View=FullCorner
   XReduceCenter=(FullCorner[0]+mLocal.mFullBox.XWinSize/2)/ReduceView.ZoomOut
   YReduceCenter=(FullCorner[1]+mLocal.mFullBox.YWinSize/2)/ReduceView.ZoomOut

;
; UPDATE REDUCED BOX
;
   Widget_Control, mLocal.wReduceView, Get_UValue=ReduceView
   Widget_Control, ReduceView.wReduceView, Get_Value=wrd
   wSet, wrd
   mbox=ReduceView.mReduceBox             ; MJS-For some reason you can't send
   GetBox, XReduceCenter, YReduceCenter, mBox         ;     in mbox.mReduceBox
   ReduceView.mReduceBox=mbox
   Draw_Box, ReduceView.mReduceBox, ReduceView.mReduceBoxOld, /Dev
   ReduceView.mReduceBoxOld = ReduceView.mReduceBox
   Widget_Control, mLocal.wReduceView, Set_UValue=ReduceView


END; FullView_Scroll_Bars_Moved


;===================;
; WIDGET DEFINITION ;
;===================;
FUNCTION FullView, wParent, XSize=XSize, YSize=YSize
COMMON DRSLUTINFO, LineFile, NDVIctFile, saved_REDct, saved_GREENct, saved_BLUEct
!ORDER=1

; ========= Save original LUT's ========= DRS 4-99
;   saved_REDct = bytarr(256)
;   saved_GREENct = bytarr(256)
;   saved_BLUEct = bytarr(256)
;   tvlct, saved_REDct, saved_GREENct, saved_BLUEct, /GET

   saved_REDct = bindgen(256)
   saved_GREENct = bindgen(256)
   saved_BLUEct = bindgen(256)
   tvlct, saved_REDct, saved_GREENct, saved_BLUEct


; ========= Check for input file =========
   Widget_Control, wParent, Get_UValue=mParent
   WHILE (NOT Widget_Info(mParent.wOpenFile, /Valid_ID)) DO BEGIN
      mParent.wOpenFile=Open_File()
   END
   Widget_Control, mParent.wOpenFile, Get_UValue=mInfo
   Widget_Control, wParent, Set_UValue=mParent


; ========= Check for classification information =========
   fileroot=str_sep(mInfo.file, '.')
   mClassInfo=GetClassInfo(fileRoot[0], mInfo)


; ========= Get some initial data =========
   XSize=mInfo.ns
   YSize=mInfo.nl
   File=mInfo.File
   SCR_XSIZE=500 < XSize
   SCR_YSIZE=500 < YSize
   IF (mClassInfo.lccExist) THEN $
      Image=mClassInfo.lccImage $
   ELSE BEGIN
      Image=BandRead(mInfo.File, 0, mInfo.ns, mInfo.nl,  dt=mInfo.dt)
   END

; ========= Set up widget interface =========
   wBase=Widget_Base(Title='Full Resolution View', $
         Group_Leader=wParent, /Tlb_Size_Events, $
         Event_Pro='FullView_Resize_Event')

   wFullView=Widget_Draw(wBase, XSize=XSize, YSize=YSize, $
         Scroll=1, Scr_XSize=Scr_XSize, Scr_YSize=Scr_YSize, $
         /Motion_Events, /Button_Events, $
         Event_Pro='FullView_Event')
   Widget_Control, wFullView, Get_Value=CurWin, /Draw_Viewport_Events

   geoFullView=Widget_Info(wFullView, /Geometry)

   lccMap=0
   IF(mClassInfo.lccExist AND mClassInfo.attExist) THEN BEGIN
      wLCCBase= Widget_Base(wBase, XSize=geoFullView.SCR_XSize, $
                XOffset=0, YOffset=geoFullView.SCR_YSize, /COlumn)
      wLCCLabel=CW_Field(wLCCBase, Title=' ', /NoEdit)
      geoLCCLabel=Widget_Info(wLCCBase, /geo)
      Widget_Control, wLCCLabel, Map=lccMap
      Widget_Control, wBase, YSize=geoFullView.SCR_YSize+geoLCCLabel.YSize*lccMap
   END ELSE BEGIN
      wLCCBase=-1L
      wLCCLabel=-1L
   END


   Widget_Control, wBase, /Realize

   wSet, CurWin

   tv, scaleft(Image, FROM_MIN=mInfo.maxVal, FROM_MAX=mInfo.minVal, TO_MIN=0, TO_MAX=200)

;
; Initialize Selection Box
;
   mFullBox={mBox}
   mFullBox.XWinSize=(Scr_XSize < mInfo.ns)
   mFullBox.YWinSize=(Scr_YSize < mInfo.nl)
   mFullBox.XBoxSize=128
   mFullBox.YBoxSize=128
   mFullBox.ImgOffset=[0,0]
   mFullBox.ImgSize=[mInfo.ns,mInfo.nl]
   mFullBoxOld=mFullBox


   state={ wParent:wParent $
         , wBase:wBase $
         , wFullView:wFullView $
         , wLCCBase:wLCCBase $
         , wLCCLabel:wLCCLabel $
         , wPUM:-1L $
         , wZoomView: -1L $
         , wReduceView: -1L $
         , MouseClick:lonarr(3) $
         , mFullBox:mFullBox $
         , mFullBoxOld:mFullBoxOld $
         , Image:Image $
         , mClassInfo:mClassInfo $
         , lccMap:lccMap $
         , LineFile: '' $
         , LineFileDefined: 0L $
         , LinesShowing: 0L $
         , NDVIctFile:'' $
         , ColorFileDefined: 0L $
         , customColor: 0L $
         }

   Widget_Control, wBase, Set_UValue=State


   XManager, 'FullView', wBase, Event_Handler='FullView_Resize_Event', $
             /No_Block
   XManager, 'FullView', wFullView, Event_Handler='FullView_Event', $
             /No_Block

Return, wBase
END
