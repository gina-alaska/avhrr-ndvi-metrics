;==========================;
; CW_PLOTOPT EVENT HANDLER ;
;==========================;
PRO CW_PLOTOPT_EVENT, ev

   Widget_Control, ev.id, Get_UValue=uvalue
   Widget_Control, ev.top, Get_UValue=mLocal

;
; Handle Fake Events
;

;
; Handle Real Events
;
   CASE (UVALUE) OF

   'wFullPlot': BEGIN
        !X.S=mLocal.fpscale(0:1)
        !Y.S=mLocal.fpscale(2:3)
        CASE (!X.S[0] NE !X.S[1]) OF
        1: BEGIN
           Widget_Control,mLocal.wXMin, get_value=xmin
           Widget_Control,mLocal.wXMax, get_value=xmax
           Widget_Control,mLocal.wYMin, get_value=ymin
           Widget_Control,mLocal.wYMax, get_value=ymax

           mPlotBox=mLocal.mPlotBox

           mPlotBox.XBox=[XMin, XMax, XMax, XMin, XMin]
           mPlotBox.YBox=[YMin, YMin, YMax, YMax, YMin]

           Widget_Control, mLocal.wFullPlot, get_value=wfp
           wset,wfp
           fpgeo=Widget_Info(mLocal.wFullPlot, /Geometry)

           IF(mLocal.PixMapID LT 0) THEN BEGIN
              Window, /Free, /Pixmap, XSize=fpgeo.XSize, YSize=fpgeo.YSize
              mLocal.PixMapID=!D.Window
              Device, Copy=[0,0,fpgeo.XSize-1, fpGeo.YSize-1, 0, 0, wfp]
              PlotS, mPlotBox.XBox, mPlotBox.YBox, Color=rgb(255,0,0), /Data

           END

           IF (mLocal.MouseClick1 LT 0) THEN mLocal.MouseClick1 = 0



           xMin0 = 0
           xMax0 = mLocal.nb-1
           yMin0 = mLocal.MinVal
           yMax0 = mLocal.MaxVal


           xyData = Convert_Coord(ev.x, ev.y, /Device, /To_Data)

           xmindiff = abs(xyData(0)-xmin)
           xmaxdiff = abs(xyData(0)-xmax)

           ymindiff = abs(xyData(1)-ymin)
           ymaxdiff = abs(xyData(1)-ymax)

           MinXDiff= xmindiff < xmaxdiff
           MinYDiff= ymindiff < ymaxdiff

           IF(ev.press EQ 1 AND $
             (MinXDiff LT mLocal.nb*.025 OR $
              MinYDiff LT mLocal.MaxVal*.025)) THEN BEGIN
              mLocal.MouseClick1=1
              mLocal.ChangeX=(MinXDiff LT mLocal.nb*0.025)
              mLocal.ChangeY=(MinYDiff LT mLocal.MaxVal*0.025)
           END

           IF(mLocal.ChangeX) THEN BEGIN
              xmin = xmin*(xmaxdiff lt xmindiff) + $
                     xyData(0)*(xmaxdiff ge xmindiff)
              xmax = xmax*(xmaxdiff ge xmindiff) + $
                     xyData(0)*(xmaxdiff lt xmindiff)
           END

           IF(mLocal.ChangeY) THEN BEGIN
              ymin = ymin*(ymaxdiff lt ymindiff) + $
                     xyData(1)*(ymaxdiff ge ymindiff)
              ymax = ymax*(ymaxdiff ge ymindiff) + $
                     xyData(1)*(ymaxdiff lt ymindiff)
           END

           xmin = xmin > xMin0
           xmax = xmax < xMax0
           ymin = ymin > yMin0
           ymax = ymax < yMax0




;
; Mouse MOTION
;

        IF(ev.type eq 2 AND mLocal.MouseClick1 EQ 1) THEN BEGIN

           wset,wfp
           mPlotBox.XBox=[XMin, XMax, XMax, XMin, XMin]
           mPlotBox.YBox=[YMin, YMin, YMax, YMax, YMin]

           Device, Copy=[0,0,fpgeo.XSize-1, fpGeo.YSize-1, 0, 0, $
                     mLocal.PixMapID]
           PlotS, mPlotBox.XBox, mPlotBox.YBox, Color=rgb(255,0,0), /Data
           inumbers = findgen(mLocal.nb)
           oplot, inumbers(xmin:xmax), mLocal.mData.Smooth(xmin:xmax), $
                     color = rgb(255,0,0)

           mLocal.mPlotBoxOld=mLocal.mPlotBox
           mLocal.fpscale=[!X.S, !Y.S]
           Widget_Control, mLocal.wXMin, set_value=round_to(xmin, 1)
           Widget_Control, mLocal.wXMax, set_value=round_to(xmax,1)
           Widget_Control,mLocal.wYMin, set_value=round_to(ymin,1)
           Widget_Control,mLocal.wYMax, set_value=round_to(ymax,1)
        END; if ev.type =2 (Motion)

;
; Button RELEASE
;
        IF(ev.release EQ 1) THEN BEGIN
           mLocal.MouseClick1=0

           Widget_Control,mLocal.xtxt,get_value=x
           Widget_Control,mLocal.ytxt,get_value=y

;
; Generate and send fake event to update plots when button is released
;
           FakeEvent = {WFULLPLOT, $
                          id: ev.id, $
                          top: ev.top, $
                          handler: mLocal.mParent.wSmoother, $
                          x: x, $
                          y: y }

           Widget_Control, mLocal.mParent.wSmoother, Send_Event=FakeEvent

         END; Release 1
      END;CASE1
      ELSE:
      ENDCASE

    END;wFullPlot


    ELSE:
    ENDCASE





   
END; CW_PLOTOPT_EVENT



;===========;
; GET_VALUE ;
;===========;
FUNCTION CW_PlotOpt_GET_VALUE, id
 
   Widget_Control, id, Get_UValue=State, /No_Copy


;
; Pull Current Values from Widgets
;
        Widget_Control,State.wXMin,get_value=XMin
        Widget_Control,State.wXMax,get_value=XMax
        Widget_Control,State.wYMin,get_value=YMin
        Widget_Control,State.wYMax,get_value=YMax

;
; Place Current values into the current value structure
;
          State.CurrentValue.wXMin=XMin 
          State.CurrentValue.wXMax=XMin 
          State.CurrentValue.wYMin=YMax 
          State.CurrentValue.wYMax=YMax 
  
;
; Save CurrentValue structure
;
   ret=State.CurrentValue

   Widget_Control, id, Set_UValue=State, /No_Copy


Return, ret
END; GET_VALUE

;===========;
; SET_VALUE ;
;===========;
PRO CW_PlotOpt_SET_VALUE, id, NewValue

   ; Retrieve the state information
      ;stash=Widget_Info(id, /Child)
      stash=id
      Widget_Control, stash, Get_UValue=State, /No_Copy

      Widget_Control, State.wXMin, Set_Value=NewValue.XMin_def
      Widget_Control, State.wXMax, Set_Value=NewValue.XMax_def
      Widget_Control, State.wYMin, Set_Value=NewValue.YMin_def
      Widget_Control, State.wYMax, Set_Value=NewValue.YMax_def
   
   Widget_Control, stash, Set_UValue=state, /No_Copy
END; SET_VALUE


;=========================;
; CW_SMOOTHOPT DEFINITION ;
;=========================;
FUNCTION CW_PlotOpt, Parent

;
; Plotter Options
;

   wBase = Widget_Base(Parent,/column,/frame,map=0, $
              Func_Get_Value='CW_PlotOpt_GET_VALUE', $
              Pro_Set_Value='CW_PlotOpt_SET_VALUE')


   plabel = Widget_Label(wBase,value="Plot Parameters:")
   xbase = Widget_Base(wBase,/row)
   wXMin = CW_Field(xbase,/integer,title="X Min: ", xsize=5)
   wXMax = CW_Field(xbase,/integer,title="X Max: ", xsize=5)

;  asText=["Periods","Years"]
;  xunit = Widget_Droplist(xbase, value=asText)

   ybase = Widget_Base(wBase,/row)
   wYMin = CW_Field(ybase,/integer,title="Y Min: ", xsize=5)
   wYMax = CW_Field(ybase,/integer,title="Y Max: ", xsize=5)

;  asText=["Data","NDVI"]
;  yunit = Widget_Droplist(ybase, value=asText)
;  dlabel = Widget_Label(wBase,value="Difference Plot Parameters:")
;  dbase = Widget_Base(wBase,/row)
;  ydmin = CW_Field(dbase,/integer,title="Y Min: ",value=-200,xsize=5)
;  ydmax = CW_Field(dbase,/integer,title="Y Max: ",value=200,xsize=5)

   wpbasegeo = Widget_Info(wBase, /geometry)


;
; Full View Box
;
   label=Widget_Label(wBase, Value='Plot Range:')
   wFullPlot = Widget_Draw(wBase, /frame, $
               /Button_Events, /Motion_Events, uvalue='wFullPlot',$
               xsize=wpbasegeo.xsize, ysize=wsbasegeo.ysize-wpbasegeo.ysize)


;
; Allocate space for Plot Scales
;
   IF(N_Elements(fpscale) EQ 0) THEN fpscale = fltarr(4)

   CurrentValue={           $
                   XMin:-1L  $
                 , XMax:-1L  $
                 , YMin:-1L  $
                 , YMax:-1L  $
                }

   
   State={ Parent:Parent  $
          , wBase:wBase   $
          , wXMin:wXMin   $
          , wXMax:wXMax   $
          , wYMin:wYMin   $
          , wYMax:wYMax   $
          , wFullPlot:wFullPlot $
          , FPScale:FPScale $
          , CurrentValue:CurrentValue $
         }
 
    Widget_Control, wBase, Set_UValue=State, /No_Copy

XManager,'cw_smoothopt',wBase,event_handler='cw_smoothopt_event', /No_Block
Return, wBase
END
