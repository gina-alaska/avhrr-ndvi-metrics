PRO FSZView_event, ev
COMMON DRSLUTINFO, LineFile, saved_REDct, saved_GREENct, saved_BLUEct  ;ugly!

Widget_Control, ev.id, Get_UValue=UValue
Widget_Control, ev.top, Get_UValue=mLocal

IF(NOT Widget_Info(mLocal.mParent.wPosition, /Valid_ID)) THEN $
   mLocal.mParent.wPosition=cw_projpos(mLocal.mParent)
Widget_Control, mLocal.mParent.wBase, Set_UValue=mLocal.mParent



CASE (UValue) OF

;=== WFULLDRAW ===

   'wFullDraw': BEGIN

       IF(mlocal.MouseClick1 lt 0) THEN mlocal.MouseClick1 = 0
       Widget_Control, mLocal.wFullDraw, Get_Value=wfd
       wSet, wfd

       x = (0 > ev.x) < (mLocal.mImage.ns-1)
       y = (0 > (mLocal.mImage.nl-ev.y-1)) < (mLocal.mImage.nl - 1)


       Widget_Control, mLocal.awField[0], Set_Value= x
       Widget_Control, mLocal.awField[1], Set_Value= y
       Widget_Control, mLocal.awField[2], $
          Set_Value=float(mLocal.mImage.Image(x,y))

       if(mLocal.mLCC.exist159) THEN $
          Widget_Control, mLocal.wLCLabel, $
             Set_Value=mLocal.mLCC.lcctable[1,fix(mLocal.mLCC.Image(x,y))]
  
       Widget_Control, mLocal.wZoomSlide, Get_Value= ZoomX

       mFulBox = mLocal.mFulBox
       fullzoom = round_to(mLocal.ZoomWinSz/ZoomX, 2) < $
                   (mLocal.mFulBox.XWinSize < mLocal.mFulBox.YWinSize)
       halfzoom = fullzoom/2
       Get_Box, ev.x, ev.y, mFulBox, halfzoom
       mLocal.mFulBox = mFulBox

       IF(mLocal.mFulBox.XCenter EQ -1) THEN mLocal.mFulBoxOld = mLocal.mFulBox

; Move the box to the current location
       IF(ev.press eq 1 ) THEN BEGIN
         mlocal.MouseClick1 = 1
         Draw_Box, mLocal.mFulBox, mLocal.mFulBoxOld, /Dev
         mLocal.mFulBoxOld = mLocal.mFulBox

; Get zoomed image size and coordinates
         mLocal.ZoomImgSz = mLocal.ZoomWinSz < (mLocal.mImage.ns > mLocal.mImage.nl)*ZoomX

         ZXUL = (0 > (x - halfzoom)) < (mLocal.mImage.ns - fullzoom)
         ZYUL = (0 > (y - halfzoom)) < (mLocal.mImage.nl - fullzoom)

; Zoom image
         Zimg = congrid(mLocal.mImage.Image(ZXUL:ZXUL+fullzoom-1, ZYUL:ZYUL+fullzoom-1), $
               mLocal.ZoomImgSz, mLocal.ZoomImgSz)

         zxoff= (0> (mLocal.ZoomWinSz-mLocal.ZoomImgSz))/2
         zyoff= (0> (mLocal.ZoomWinSz-mLocal.ZoomImgSz))/2

; Draw zoomed image
         Widget_Control, mLocal.wZoomDraw, Get_Value=wzd
         wSet,wzd
         if (mLocal.ZoomImgSz lt mLocal.ZoomWinSz) THEN $
            tv, bytarr(mLocal.ZoomWinSz, mLocal.ZoomWinSz) ; Blank out window
         if (mLocal.customColor eq 1) then tv,zimg, zxoff, zyoff else tvscl,zimg, zxoff, zyoff
      end;press event

; If button is down and I'm moving, move the box
      IF(ev.type eq 2 and mlocal.MouseClick1 eq 1)THEN begin
         Draw_Box, mLocal.mFulBox, mLocal.mFulBoxOld, /Dev
         mLocal.mFulBoxOld = mLocal.mFulBox
         mLocal.ZoomImgSz = mLocal.ZoomWinSz < (mLocal.mImage.ns > mLocal.mImage.nl)*ZoomX

         ZXUL = (0 > (x - halfzoom)) < (mLocal.mImage.ns - fullzoom)
         ZYUL = (0 > (y - halfzoom)) < (mLocal.mImage.nl - fullzoom)
         Zimg = congrid(mLocal.mImage.Image(ZXUL:ZXUL+fullzoom-1, ZYUL:ZYUL+fullzoom-1), $
               mLocal.ZoomImgSz, mLocal.ZoomImgSz)

         zxoff= (0> (mLocal.ZoomWinSz-mLocal.ZoomImgSz))/2
         zyoff= (0> (mLocal.ZoomWinSz-mLocal.ZoomImgSz))/2

         Widget_Control, mLocal.wZoomDraw, Get_Value=wzd
         wSet,wzd
         if (mLocal.customColor eq 1) then tv,zimg, zxoff, zyoff else tvscl,zimg, zxoff, zyoff
      end;press plus motion event

; IF SCROLL BARS ARE MOVED, MOVE BOX IN REDUCED VIEW
      IF(ev.type EQ 3) THEN BEGIN 

; Get Center of reduced box and calculate box
          redoff = mLocal.mRedBox.ImgOffset
          reddim = mLocal.mRedbox.ImgSize
          FullWinSz = mLocal.mFulBox.XWinSize
          red2ful = float(mLocal.mImage.ns > mLocal.mImage.nl)/(max(reddim))
          halfred = FullWinSz / red2ful /2.
          Widget_Control, mLocal.wFullDraw, Get_Draw_View=viewloc
          xvloc=(viewloc[0]/red2ful)+redoff[0]
          yvloc=(viewloc[1]/red2ful)+redoff[1]

          mRedBox = mLocal.mRedBox
          Get_Box, round(xvloc+halfred), $
                   round(yvloc+halfred), mRedBox, halfred
          mLocal.mRedBox = mRedBox
          IF(mLocal.mRedBox.XCenter EQ -1) THEN mLocal.mRedBoxOld = mLocal.mRedBox

          Widget_Control, mLocal.wReduceDraw, Get_Value=wrd
          wSet, wrd

          Draw_Box, mLocal.mRedBox, mLocal.mRedBoxOld, /Dev
          mLocal.mRedBoxOld = mLocal.mRedBox
      ENDIF

      Widget_Control, mLocal.wFullDraw, /Draw_Motion_Events, /Draw_Viewport_Events

; Point Selected
      IF (ev.release EQ 1) THEN BEGIN
          mlocal.MouseClick1 = 0

          nawField = n_elements(mLocal.awField)/2
          Widget_Control, mLocal.awField[nawField], Set_Value= x
          Widget_Control, mLocal.awField[nawField+1], Set_Value= y
          Widget_Control, mLocal.awField[nawField+2], $
              Set_Value=float(mLocal.mImage.Image(x,y))
          Widget_Control, mLocal.wFullDraw, /Draw_Motion_Events

      ENDIF

;
; FAKE EVENT TO SEND TO POSITION MONITOR
;
      FakeEvent={WIMAGE $
                , id: ev.id $
                , top: ev.top $
                , handler: mLocal.mParent.wPosition $
                , x: x $
                , y: y $
                } 

      if(Widget_Info(mLocal.mParent.wPosition, /Valid_ID)) THEN $
         Widget_Control, mLocal.mParent.wPosition, Send_Event=FakeEvent

    END;wFullDraw

;=== WREDUCEDRAW ===

   'wReduceDraw': BEGIN
      IF(mlocal.MouseClick2 lt 0) THEN mlocal.MouseClick2 = 0

      redoff = mLocal.mRedBox.ImgOffset
      reddim = mLocal.mRedbox.ImgSize
      FullWinSz = mLocal.mFulBox.XWinSize
      red2ful = float(mLocal.mImage.ns > mLocal.mImage.nl)/(max(reddim))
      halfred = FullWinSz / red2ful /2.

      Widget_Control, mLocal.wReduceDraw, Get_Value=wrd
      wSet, wrd

; Get position in reduced image
      xred = ev.x 
      xred = long((xred - (redoff[0] < xred)) < reddim[0])
      yred = mLocal.mRedBox.YWinSize-ev.y-1  
      yred = long((yred - (redoff[1] < yred)) < reddim[1])

; Scale that position to the full res image
      x0 = round(xred*red2ful) < (mLocal.mImage.ns - 1)
      y0 = round(yred*red2ful) < (mLocal.mImage.nl - 1)

; Locate the lower left corner or our full res image in device coords
      xF = (x0 - FullWinSz/2) > 0
      yF = (mLocal.mImage.nl-y0-1 - FullWinSz/2) > 0
      Widget_Control, mLocal.awField[0], Set_Value= x0
      Widget_Control, mLocal.awField[1], Set_Value= y0
      Widget_Control, mLocal.awField[2], Set_Value= float(mLocal.mImage.Image(x0,y0))
if(mLocal.mLCC.exist159) THEN $
       Widget_Control, mLocal.wLCLabel, Set_Value=mLocal.mLCC.lcctable[1,fix(mLocal.mLCC.Image(x0,y0))]

; Get Center of reduced box and calculate box
      mRedBox = mLocal.mRedBox
      Get_Box, ev.x, ev.y, mRedBox, halfred
      mLocal.mRedBox = mRedBox

      IF(mLocal.mRedBox.XCenter EQ -1) THEN mLocal.mRedBoxOld = mLocal.mRedBox


; Move the box to the current location
      IF(ev.press eq 1 ) THEN BEGIN
         mlocal.MouseClick2 = 1
         Draw_Box, mLocal.mRedBox, mLocal.mRedBoxOld, /Dev
         mLocal.mRedBoxOld = mLocal.mRedBox
      end;press event


; If button is down and I'm moving, move the box
      IF(ev.type eq 2 and mlocal.MouseClick2 eq 1)THEN begin
         Draw_Box, mLocal.mRedBox, mLocal.mRedBoxOld, /Dev
         mLocal.mRedBoxOld = mLocal.mRedBox
if (mlocal.scroll) THEN $
         Widget_Control, mLocal.wFullDraw, Set_Draw_View=[xF,yF]
      end;press plus motion event

; If button1 is clicked set fields and show full res
      IF(ev.release eq 1) THEN BEGIN
         mlocal.MouseClick2 = 0

         nawField = n_elements(mLocal.awField)/2 
;         Widget_Control, mLocal.awField[nawField], Set_Value= x0
;         Widget_Control, mLocal.awField[nawField+1], Set_Value= y0
;         Widget_Control, mLocal.awField[nawField+2], Set_Value=(mLocal.mImage.Image(x0,y0))
         Widget_Control, mLocal.wFullDraw, /Draw_Motion_Events
if (mlocal.scroll) THEN $
         Widget_Control, mLocal.wFullDraw, Set_Draw_View=[xF,yF]




      ENDIF; release event


;
; FAKE EVENT TO SEND TO POSITION MONITOR
;
   FakeEvent={WIMAGE $
             , id: ev.id $
             , top: ev.top $
             , handler: mLocal.mParent.wPosition $
             , x: x0 $
             , y: y0 $
             } 
if(Widget_Info(mLocal.mParent.wPosition, /Valid_ID)) THEN $
   Widget_Control, mLocal.mParent.wPosition, Send_Event=FakeEvent
    END;wReduceDraw


;=== NDVI Color Table Apply Check-Box ======== DRS 4-99

   'ctLoadEvent': BEGIN
      if (ev.select eq 1) then begin

; Load in the NDVI color table & Load

         if (NDVIctFile= Dialog_PickFile(Path='.', $
			Filter='*.pal',/MUST_EXIST)) then begin
            widget_control,/HourGlass
            openr, ctlun, NDVIctFile, /GET_LUN
            lutvar = intarr(4,256)
            readf, ctlun, lutvar
            tvlct, lutvar[1,*],lutvar[2,*],lutvar[3,*]
            mlocal.customColor = 1
            FREE_LUN,ctlun
         endif else widget_control, event.id, Set_Button=0
      endif else BEGIN
         tvlct, saved_REDct, saved_GREENct, saved_BLUEct
         mlocal.customColor = 0
      endelse
   END

;=== Line Overlay Apply Check-Box ========== DRS 4-99

    'ckLineOvrEvent': BEGIN

	if (mLocal.LineFileDefined eq 0) then BEGIN
           Linefile = Dialog_PickFile(Path='.', Filter='lines.txt',/MUST_EXIST)
           if (LineFile eq '') then return
           mLocal.LineFileDefined = 1
        endif

        Widget_Control, mLocal.wFullDraw, Get_Value=wfd
        wSet, wfd

        widget_control, mlocal.mParent.wOpenFile, GET_UVALUE=minfo
        ddr = minfo.ddr

        widget_control,/HourGlass
        openr, linelun, LineFile, /GET_LUN
        numRecs = 0L;
        readf, linelun, numRecs

        for i = 1,numRecs do begin
           numPts = 0L;
           readf, linelun, numPts
           dataVec = dblarr(2,numPts);
           readf, linelun, dataVec
           dataVec[0,*] = dataVec[0,*] - ddr.ul[1]
           dataVec[0,*] = dataVec[0,*] / ddr.projdist[0]
           dataVec[1,*] = ddr.ul[0] - dataVec[1,*]
           dataVec[1,*] = dataVec[1,*] / ddr.projdist[0]
           dataVec[1,*] = mLocal.mImage.nl - dataVec[1,*]
           plots,dataVec,/device
        endfor
        FREE_LUN,linelun
    END

;=== VIZ TOOL BUTTON Pressed =========== DRS 4-99

    'optButtonEvent': BEGIN
	widget_control, mlocal.mParent.wOpenFile, GET_UVALUE=minfo
	ddr = minfo.ddr
	vuCube, mLocal.mImage.file, $
	   [mLocal.mImage.ns, mLocal.mImage.nl, mLocal.mImage.nb, $
		mLocal.mImage.dt],$
		[ddr.ul[1], ddr.ul[0], ddr.projdist[0]]
    END

;=== WREDUCESLIDE ===

    'wReduceSlide': BEGIN
       Widget_Control,mLocal.wReduceSlide, Get_Value=band
       Widget_Control, mLocal.wFullDraw, Get_Value=wfd
       Widget_Control, mLocal.wReduceDraw, Get_Value=wrd
       mLocal.mImage.cb = band
       mImage = mLocal.mImage


IF (Band LT 0) THEN BEGIN
   mLocal.mImage.Image=mLocal.mLCC.Image
END ELSE BEGIN
       mLocal.mImage.Image=BandRead(mImage.file, band, mImage.ns, mImage.nl, DTYPE=mImage.dt) 
END

       IF(mLocal.mFulBox.XCenter EQ -1) THEN mLocal.mFulBoxOld = mLocal.mFulBox

       reddim = mLocal.mRedbox.ImgSize
IF (Band LT 0) THEN BEGIN
       imgred=ReduceRead(mLocal.mLCC.lccfile, reddim(0), reddim(1), 0,$
                         mLocal.mLCC.ns, mLocal.mLCC.nl, DTYPE=mLocal.mLCC.dt)
END ELSE BEGIN
       imgred=ReduceRead(mImage.file, reddim(0), reddim(1), band,$
                         mImage.ns, mImage.nl, DTYPE=mImage.dt)
END

; Show box in reduced window
       wSet, wrd
       Draw_Box, mLocal.mRedBox, mLocal.mRedBoxOld, /erase, /Dev
       if (mLocal.customColor eq 1) then $
		tv, imgred, mLocal.mRedBox.ImgOffset(0), mLocal.mRedBox.ImgOffset(1) $
	else $
		tvscl, imgred, mLocal.mRedBox.ImgOffset(0), mLocal.mRedBox.ImgOffset(1)
       Draw_Box, mLocal.mRedBox, mLocal.mRedBoxOld, /new, /Dev
; Show box in full-res window
       wSet, wfd
       Draw_Box, mLocal.mFulBox, mLocal.mFulBoxOld, /erase, /Dev
       if (mLocal.customColor eq 1) then tv, mLocal.mImage.Image $
	else tvscl, mLocal.mImage.Image
       Draw_Box, mLocal.mFulBox, mLocal.mFulBoxOld, /new, /Dev

       Widget_Control, mLocal.wReduceSlide, Set_Value=band

       Widget_Control, mLocal.wZoomSlide, Get_Value= ZoomX

       mFulBox = mLocal.mFulBox
       fullzoom = round_to(mLocal.ZoomWinSz/ZoomX, 2) < $
                   (mLocal.mFulBox.XWinSize < mLocal.mFulBox.YWinSize)
       halfzoom = fullzoom/2
       Widget_Control, mLocal.awField[3], Get_Value= x
       Widget_Control, mLocal.awField[4], Get_Value= y


; Get zoomed image size and coordinates
         mLocal.ZoomImgSz = mLocal.ZoomWinSz < (mLocal.mImage.ns > mLocal.mImage.nl)*ZoomX

         ZXUL = (0 > (x - halfzoom)) < (mLocal.mImage.ns - fullzoom)
         ZYUL = (0 > (y - halfzoom)) < (mLocal.mImage.nl - fullzoom)

; Zoom image
         Zimg = congrid(mLocal.mImage.Image(ZXUL:ZXUL+fullzoom-1, ZYUL:ZYUL+fullzoom-1), $
               mLocal.ZoomImgSz, mLocal.ZoomImgSz)

         zxoff= (0> (mLocal.ZoomWinSz-mLocal.ZoomImgSz))/2
         zyoff= (0> (mLocal.ZoomWinSz-mLocal.ZoomImgSz))/2

; Draw zoomed image
         Widget_Control, mLocal.wZoomDraw, Get_Value=wzd
         wSet,wzd
         if (mLocal.ZoomImgSz lt mLocal.ZoomWinSz) THEN $
            tv, bytarr(mLocal.ZoomWinSz, mLocal.ZoomWinSz) ; Blank out window
         if (mLocal.customColor eq 1) then tv,zimg, zxoff, zyoff $
	 else tvscl, zimg, zxoff, zyoff
;===

    END;wReduceSlide 


;=== WZOOMDRAW ===

    'wZoomDraw': BEGIN


       IF(mlocal.MouseClick1 ge 0) THEN BEGIN
          nawField = n_elements(mLocal.awField)/2 
          Widget_Control, mLocal.awField[nawField], Get_Value=ZXCenter
          Widget_Control, mLocal.awField[nawField+1], Get_Value=ZYCenter
          Widget_Control, mLocal.wZoomSlide, Get_Value=ZoomX

          ZX = ev.x 
          ZY = mLocal.ZoomWinSz-ev.y-1 
          XHalf = mLocal.ZoomWinSz/2./ZoomX
          YHalf = mLocal.ZoomWinSz/2./ZoomX

          ZXCenter = floor((XHalf > ZXCenter) < (mLocal.mImage.ns - XHalf))
          ZYCenter = floor((YHalf > ZYCenter) < (mLocal.mImage.nl - YHalf))

          x = ZXCenter + floor((ZX-mLocal.ZoomImgSz/2.)/ZoomX)
          y = ZYCenter + floor((ZY-mLocal.ZoomImgSz/2.)/ZoomX)

          x = (0 > x) < (mLocal.mImage.ns -1)
          y = (0 > y) < (mLocal.mImage.nl -1)

          Widget_Control, mLocal.awField[0], Set_Value= x
          Widget_Control, mLocal.awField[1], Set_Value= y
          Widget_Control, mLocal.awField[2], Set_Value= float(mLocal.mImage.Image(x,y))


          if(mLocal.mLCC.exist159) THEN $
             Widget_Control, mLocal.wLCLabel, $
                Set_Value=mLocal.mLCC.lcctable[1,fix(mLocal.mLCC.Image(x,y))]

          IF(ev.release eq 1) THEN begin

             if (NOT Widget_Info(mLocal.mParent.wSmoother, /Valid_ID)) THEN $
                        mLocal.mParent.wSmoother = Smoother(mLocal.mParent)

             Widget_Control, mLocal.mParent.wBase, Set_UValue=mLocal.mParent

;
; FAKE EVENT TO PLOT POINT
;
             FakeEvent = {WZOOMDRAW, $
                          id: ev.id, $
                          top: ev.top, $
                          handler: mLocal.mParent.wSmoother, $
                          x: x, $
                          y: y }
             Widget_Control, mLocal.mParent.wSmoother, Send_Event=FakeEvent

          END; ev.release

       END ELSE BEGIN
          x=0 
          y=0
       END
;
; FAKE EVENT TO SEND TO POSITION MONITOR
;
       FakeEvent={WIMAGE $
                 , id: ev.id $
                 , top: ev.top $
                 , handler: mLocal.mParent.wPosition $
                 , x: x $
                 , y: y $
                 } 

       if(Widget_Info(mLocal.mParent.wPosition, /Valid_ID)) THEN $
          Widget_Control, mLocal.mParent.wPosition, Send_Event=FakeEvent

    END; wZoomDraw


;=== WZOOMSLIDE ===

    'wZoomSlide': BEGIN
       Widget_Control, mLocal.wZoomSlide, Get_Value=ZoomX
       Widget_Control, mLocal.wZoomSlide, Set_Value=ZoomX
;=== MJS 6/22/98
       Widget_Control, mLocal.wZoomSlide, Get_Value= ZoomX

       mFulBox = mLocal.mFulBox
       fullzoom = round_to(mLocal.ZoomWinSz/ZoomX, 2) < $
                   (mLocal.mFulBox.XWinSize < mLocal.mFulBox.YWinSize)
       halfzoom = fullzoom/2
       Widget_Control, mLocal.awField[3], Get_Value= x
       Widget_Control, mLocal.awField[4], Get_Value= y


; Get zoomed image size and coordinates
         mLocal.ZoomImgSz = mLocal.ZoomWinSz < (mLocal.mImage.ns > mLocal.mImage.nl)*ZoomX

         ZXUL = (0 > (x - halfzoom)) < (mLocal.mImage.ns - fullzoom)
         ZYUL = (0 > (y - halfzoom)) < (mLocal.mImage.nl - fullzoom)

; Zoom image
         Zimg = congrid(mLocal.mImage.Image(ZXUL:ZXUL+fullzoom-1, ZYUL:ZYUL+fullzoom-1), $
               mLocal.ZoomImgSz, mLocal.ZoomImgSz)

         zxoff= (0> (mLocal.ZoomWinSz-mLocal.ZoomImgSz))/2
         zyoff= (0> (mLocal.ZoomWinSz-mLocal.ZoomImgSz))/2

; Draw zoomed image
         Widget_Control, mLocal.wZoomDraw, Get_Value=wzd
         wSet,wzd
         if (mLocal.ZoomImgSz lt mLocal.ZoomWinSz) THEN $
            tv, bytarr(mLocal.ZoomWinSz, mLocal.ZoomWinSz) ; Blank out window
         if (mLocal.customColor eq 1) then tv,zimg, zxoff, zyoff $
	 else tvscl, zimg, zxoff, zyoff
;===

    END; wZoomSlide

    ELSE:
ENDCASE   


IF (Widget_Info(ev.top, /Valid_ID)) THEN $
   Widget_Control, ev.top, Set_UValue=mLocal

END


;====================;
; WIDGET DEFINITION  ;
;====================;
FUNCTION FSZView, mParent
COMMON DRSLUTINFO, LineFile, saved_REDct, saved_GREENct, saved_BLUEct

;!p.background=rgb(172,172,172)
OldBackground = !p.Background
!p.background=rgb(120,140,140)
;help, mParent, /structure

;INPUTS
CASE (N_PARAMS()) OF
   1: BEGIN
;      IF (mParent.mInfo.File EQ '') THEN mParent.mInfo = Open_File()
;      IF (mParent.mInfo.File eq '') THEN return,-1
;      mInfo = mParent.mInfo
;       IF (mParent.wOpenFIle EQ -1) THEN mParent.wOpenFile=Open_File(mParent)
       IF (mParent.wOpenFIle EQ -1) THEN mParent.wOpenFile=Open_File()
       IF (mParent.wOpenFIle EQ -1) THEN return, -1
       Widget_Control, mParent.wOpenFile, Get_UValue= mInfo
      END
   0: 
   ELSE:
END

;
; Look for land cover classification image
;
fileroot=str_sep(mInfo.file, '.')
lccfile=fileroot[0]+'.lcc'

startdt=minfo.dt

IF (compare(findfile(lccfile) EQ lccfile, [1])) THEN BEGIN
  lccexist=1
  startband=-1
  startfile=lccfile
  lcc159=findfile('lcc159.att', count=lcc159exist)

  IF lcc159exist THEN BEGIN
    lcctable=readtab('lcc159.att', 2, 160, 0,sep=':') 
    lcctable=lcctable.data
  END ELSE lcctable=-1L
  lccimg=BandRead(startfile,0,minfo.ns, minfo.nl, dtype=1)
  startdt=1
END ELSE BEGIN
  lccexist=0
  lcc159exist=0
  startband=0
  startfile=minfo.file
  lccfile=''
  lcctable={data:-1L}
  lccimg=-1L
END

device, Get_Screen_Size=ScreenSize

  img=BandRead(startfile,0,minfo.ns, minfo.nl, dtype=startdt)
if(minfo.dt eq 4) then img=float(img)

;WORKING WITH INPUTS
FullWinSz = (ScreenSize(1)/2 - 30) < (minfo.nl > minfo.ns)
if(FullWinSz eq max([minfo.nl, minfo.ns])) THEN scroll = 0 $
ELSE scroll=1

IF (mInfo.Dt EQ 4) THEN BEGIN
  Flt=1
  Int=0
END ELSE BEGIN
  Flt=0
  Int=1
END

ZoomWinSz = (FullWinSz /2) > ((ScreenSize(1)/2 - 30)/2)
RedWinSz= (mInfo.ns > mInfo.nl) < ZoomWinSz


maxdim=max([minfo.ns, minfo.nl])
reddim=scale([minfo.ns, minfo.nl], max=maxdim,min=0, xmax=RedWinSz,xmin=0)
reddim=round_to(reddim, 1)
RedWinSz=fix(RedWinSz)


imgred=ReduceRead(startfile, reddim(0), reddim(1), 0,minfo.ns, minfo.nl, DTYPE=startdt)
xredoff=(RedWinSz-reddim(0))/2
yredoff=(RedWinSz-reddim(1))/2
redoff=long([xredoff, yredoff])


;=================

wBase = Widget_Base(Title="Image View",/Column,/Base_Align_Center, $
                    Group_Leader=mParent.wBase)

label=Widget_Label(wBase, value="Full Resolution")
wFullDraw = Widget_Draw(wBase, $
             XSize=minfo.ns, YSize=minfo.nl, /Motion_Events,$
             Scroll=scroll, Scr_XSize=FullWinSz < minfo.ns, $
             Scr_YSize=FullWinSz<minfo.nl,$
             /Button_Events, /Frame, UValue='wFullDraw')

infoBase = Widget_Base(wBase, /ROW)
wPosText = Widget_Base(infoBase, Row=2,/Frame,/Base_Align_Center)
asText=["X   :","Y   : ","DN  :", "X0 :","Y0 : ","DN0:"]
nasText=N_Elements(asText)
awField=LonArr(nasText, N_Elements(wPosText))

FOR i = 0, N_Elements(awField)-1 DO BEGIN
   awField[i] = CW_Field(wPosText,Value=0.0,tITle=asText[i],Float=flt, Integer=Int,XSize=6)
END

; ====== Buttons & CheckBoxes added ======== DRS 4-99

button_font = '-adobe-helvetica-medium-r-normal--12-*-*-*'
ibutBase = Widget_base(infoBase, /COLUMN);
ckbutBase = Widget_base(ibutBase, /COLUMN, /NONEXCLUSIVE);
ctButton =  Widget_Button(ckbutBase,  VALUE='NDVI Colors', $
	UValue='ctLoadEvent', FONT=button_font)
lineButton= Widget_Button(ibutBase,  VALUE='Overlay Lines', $
	UValue='ckLineOvrEvent', FONT=button_font)
optButton = Widget_Button(ibutBase, VALUE=' Viz Tool ', $
	UValue='optButtonEvent', FONT=button_font)

; ========= Save original LUT's ========= DRS 4-99

saved_REDct = bytarr(256)
saved_GREENct = bytarr(256)
saved_BLUEct = bytarr(256)
tvlct, saved_REDct, saved_GREENct, saved_BLUEct, /GET

if(lcc159exist)THEN begin
   wLCLabel=CW_Field(wBase, Title=' ',XSize=55)
END ELSE wLCLabel=-1

wBottom = Widget_Base(wBase, /Row)
wBottomL = Widget_Base(wBottom, /Column,/Frame, /Base_Align_Center)
wBottomR = Widget_Base(wBottom, /Column,/Frame)

label=Widget_Label(wBottomL, Value="Reduced Image")
wReduceDraw = Widget_Draw(wBottomL, XSize = RedWinSz, YSize=RedWinSz, /Motion_Events, $
              /Button_Events, /Frame, UValue='wReduceDraw')
if minfo.nb gt 1 THEN $
  wReduceSlide= Widget_Slider(wBottomL, value=StartBand, minimum=StartBand, maximum=minfo.nb-1, scroll=1,$
              title="Display Band:", XSize=ZoomWinSz, UValue='wReduceSlide') $
ELSE wReduceSlide=-1

label=Widget_Label(wBottomR, Value="Zoomed Image")
wZoomDraw = Widget_Draw(wBottomR, XSize = ZoomWinSZ, YSize=ZoomWinSZ, /Motion_Events, $
              /Button_Events, /Frame, UValue='wZoomDraw')
wZoomSlide= Widget_Slider(wBottomR, value=2, minimum=1, maximum=16, scroll=1,$
              title="Zoom Factor:", UValue='wZoomSlide') 


Widget_Control, wBase, /realize

Widget_Control, wFullDraw, Get_Value=wfd
Widget_Control, wReduceDraw, Get_Value=wrd
Widget_Control, wZoomDraw, Get_Value=wzd

wSet, wrd
tvscl, imgred,xredoff,yredoff


wSet, wfd
tvscl, img


mImage={file:minfo.file, image: img, $
        ns:minfo.ns, nl:minfo.nl, nb:minfo.nb, dt:minfo.dt, $
        cb: StartBand, bname: 'NDVI' }

mLCC={exist:lccexist, exist159:lcc159exist, file:lccfile, image: lccimg, $
        ns:minfo.ns, nl:minfo.nl, nb:1, dt:1, $
        cb: StartBand, LCCFile:LCCFile, LCCTable:LCCTable}

;mBox = {XCenter:-1L, YCenter: -1L, $
;        XWinSize:-1L, YWinSize:-1L, $
;        XBox:intarr(5), YBox:intarr(5), $
;        ImgOffset: intarr(2), ImgSize:intarr(2)}

mRedBox = {mBox}
mFulBox = {mBox}

;mRedBox.XWinSize = ZoomWinSz
;mRedBox.YWinSize = ZoomWinSz
mRedBox.XWinSize = RedWinSz
mRedBox.YWinSize = RedWinSz
mRedBox.ImgOffset = redoff
mRedBox.ImgSize = reddim

mFulBox.XWinSize = FullWinSz < mInfo.ns
mFulBox.YWinSize = FullWinSz < mInfo.nl
mFulBox.ImgOffset = [0,0]
mFulBox.ImgSize = [mImage.ns, mImage.nl]

mRedBoxOld=mRedBox
mFulBoxOld=mFulBox

mParent.wFSZView = wBase
mLocal = {mParent: mParent, $
          mImage: mImage, $
          mRedBox: mRedBox, $
          mFulBox: mFulBox, $
          mRedBoxOld: mRedBoxOld, $
          mFulBoxOld: mFulBoxOld, $
          wBase: wBase, $
          wFullDraw: wFullDraw, $
          wReduceDraw: wReduceDraw, $
          wReduceSlide: wReduceSlide, $
          wZoomDraw: wZoomDraw, $
          wZoomSlide: wZoomSlide, $
	  ctLoadEvent: ctButton, $
	  lineLoadEvent: lineButton, $
          awField: awField, $
          MouseClick2:-1L, $
          MouseClick1:-1L, $
          scroll:scroll, $
          ZoomWinSz:ZoomWinSz, $
          ZoomImgSz:-1L, $
          customColor:0, $
	  LineFileDefined: 0L, $
 wLClabel:wLCLabel, $
 mLCC:mLCC $
         }
wSet, wfd
Widget_Control, wBase, Set_UValue=mLocal, Event_Pro='FSZView_event'
XManager, 'fszview', wbase, Event_Handler='fszview_event', /No_Block

!p.Background = OldBackground

Return, wBase

END
