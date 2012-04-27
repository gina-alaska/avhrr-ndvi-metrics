PRO smoother_event, ev

  WIDGET_CONTROL,ev.id,GET_UVALUE=uvalue
  WIDGET_CONTROL,ev.top,GET_UVALUE=mLocal


;
; Handle fake events
;
  tname = Tag_Names(ev, /Structure_Name)
  CASE (tname) OF
     'WZOOMDRAW': BEGIN
	Widget_Control,mLocal.xtxt,set_value=ev.x
	Widget_Control,mLocal.ytxt,set_value=ev.y
        UValue = 'wPlotPt'
      END
     'WFULLPLOT': BEGIN
	Widget_Control,mLocal.xtxt,set_value=ev.x
	Widget_Control,mLocal.ytxt,set_value=ev.y
        UValue = 'wPlotPt'
      END
     ELSE:
  ENDCASE

;
; Handle Events
;
  CASE (uvalue) OF

;=== BGOPTIONS ===
;
; Select which control base to map
;
    'bgOptions': BEGIN
        Widget_Control, mLocal.bgOptions, get_value=butval
        CASE (butval) OF
;
; Map Plotter Base
;
          0: BEGIN
               Widget_Control, mLocal.wSmoothOpt, map=0 
               Widget_Control, mLocal.wMetricOpt, map=0 
               Widget_Control, mLocal.wPlotOpt, map=1 
             END
;
; Map Smoother Base
;
          1: BEGIN
               Widget_Control, mLocal.wPlotOpt, map=0 
               Widget_Control, mLocal.wMetricOpt, map=0 
               Widget_Control, mLocal.wSmoothOpt, map=1 
             END
;
; Map Metrics Base
;
          2: BEGIN
               Widget_Control, mLocal.wPlotOpt, map=0 
               Widget_Control, mLocal.wSmoothOpt, map=0 
               Widget_Control, mLocal.wMetricOpt, map=1 
             END
          ELSE:
        ENDCASE;mLocal.bgOptions
     END;bgOptions


;=== FULLPLOT ===
;
; Handle events for small plot
;
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
           xMax0 = mLocal.minfo.nb-1
           yMin0 = mLocal.minfo.MinVal
           yMax0 = mLocal.minfo.MaxVal 
 

           xyData = Convert_Coord(ev.x, ev.y, /Device, /To_Data)
           
           xmindiff = abs(xyData(0)-xmin) 
           xmaxdiff = abs(xyData(0)-xmax) 

           ymindiff = abs(xyData(1)-ymin) 
           ymaxdiff = abs(xyData(1)-ymax) 

           MinXDiff= xmindiff < xmaxdiff
           MinYDiff= ymindiff < ymaxdiff

           IF(ev.press EQ 1 AND $
             (MinXDiff LT mLocal.minfo.nb*.025 OR $
              MinYDiff LT mLocal.minfo.MaxVal*.025)) THEN BEGIN
              mLocal.MouseClick1=1
              mLocal.ChangeX=(MinXDiff LT mLocal.minfo.nb*0.025)
              mLocal.ChangeY=(MinYDiff LT mLocal.minfo.MaxVal*0.025)
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
           inumbers = findgen(mLocal.minfo.nb)
           oplot, inumbers(xmin:xmax), mLocal.mData.Smooth(xmin:xmax), $
                     color = rgb(255,0,0)

           mLocal.mPlotBoxOld=mLocal.mPlotBox
           mLocal.fpscale=[!X.S, !Y.S]
           Widget_Control, mLocal.wXMin, set_value=round_to(xmin, 1)
           Widget_Control, mLocal.wXMax, set_value=round_to(xmax, 1)
           Widget_Control,mLocal.wYMin, set_value=round_to(ymin, 1)
           Widget_Control,mLocal.wYMax, set_value=round_to(ymax, 1)
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


;=== WZOOMPLOT ===
;
; Events for big plot 
;
    'wZoomPlot': BEGIN
        Widget_Control,mLocal.wXMin, get_value=xmin
        Widget_Control,mLocal.wXMax, get_value=xmax
        Widget_Control,mLocal.wYMin, get_value=ymin
        Widget_Control,mLocal.wYMax, get_value=ymax

        !X.S=mLocal.zpscale(0:1)
        !Y.S=mLocal.zpscale(2:3)

        Widget_Control, mLocal.wMetricOpt, Get_Value=tmp
        StartYear=tmp.StartYear
;        Widget_Control, mLocal.wStartYear, Get_Value=StartYear

        xminyear=band2year(xmin, StartYear, mLocal.minfo.nb, mLocal.minfo.bpy)
        xmaxyear=band2year(xmax, StartYear, mLocal.minfo.nb, mLocal.minfo.bpy)

        yminndvi=poly(ymin, mLocal.NDCoefs)
        ymaxndvi=poly(ymax, mLocal.NDCoefs)

        IF(not Compare(!x.s, [0,0])) THEN BEGIN
           Widget_Control, mLocal.wZoomPlot, Get_Value=wzp
           wset, wzp
           xyData = Convert_Coord(ev.x, ev.y, /Device, /To_Data)

           xloc = (xminyear > xyData[0]) < xmaxyear
           yloc = (yminndvi > xyData[1]) < ymaxndvi

           xloc=strcompress(frac2date(xloc, /CALENDAR))

           Widget_Control, mLocal.wXonPlot, Set_Value=xloc
           Widget_Control, mLocal.wYonPlot, Set_Value=flt2str(yloc, 3, /plus)

       END; !x.s is 0
    END; WFULLPLOT


;=== BGPLOT ===
;
; Button group for showing what's on plot
; (updates plot every time button is changed)
;
    'bgPlot': BEGIN

;
; Generate and send fake event to update plots when button is 
; selected/deselected
;
           Widget_Control,mLocal.xtxt,get_value=x
	   Widget_Control,mLocal.ytxt,get_value=y
           FakeEvent = {WFULLPLOT, $
                          id: ev.id, $
                          top: ev.top, $
                          handler: mLocal.mParent.wSmoother, $
                          x: x, $
                          y: y }

           Widget_Control, mLocal.mParent.wSmoother, Send_Event=FakeEvent

     END;bgPlot 





;=== WPLOTPT ===
;
; Generate plot with latest plot parameters
;

    'wPlotPt':BEGIN
        ;mLocal.PixMapID=-1L
        !p.background=rgb(180,180,180)
        !p.color=0

;
; Get current data point
;
	Widget_Control,mLocal.xtxt,get_value=x
	Widget_Control,mLocal.ytxt,get_value=y


;
; Get current metrics parameters
;
        Widget_Control, mLocal.wMetricOpt, Get_Value=tmp
        SWindowLength=tmp.SWindowLength 
        EWindowLength=tmp.EWindowLength 
        CurrentBand=tmp.CurrentBand 
        StartYear=tmp.StartYear 
        WindowLength=[SWindowLength, EWindowLength]


;
; Get smoother parameters and stuff them in mSmoothParam structure
;

        Widget_Control, mLocal.wSmoothOpt, Get_Value=tmp

        mLocal.mSmoothParam=tmp
        mLocal.mSmoothParam.MaxVal=mLocal.minfo.MaxVal
        mLocal.mSmoothParam.MinVal=mLocal.minfo.MinVal




        IF ( NOT Compare(mLocal.mData.xyOld, [x,y]) ) THEN BEGIN 

            Widget_Control, /HourGlass
            RawNDVI = pixread(mLocal.minfo.file, x,y,$
                      mLocal.minfo.ns, mLocal.minfo.nl, $
                      mLocal.minfo.nb, dtype=mLocal.minfo.dt)

            ImgWrite, RawNDVI, '/tmp/pixel'
            mLocal.mData.Raw = RawNDVI


            SmoothNDVI=Call_New_Smoother(mLocal)
            mLocal.mData.Smooth = SmoothNDVI(*)


            IF(mLocal.minfo.nb GT mlocal.minfo.bpy  AND $
               mLocal.minfo.dt lt 3) THEN $
                     mMetrics=ComputeMetrics(poly(mLocal.mData.Smooth,$
                              mLocal.NDCoefs),  WindowLength, $
                              mlocal.minfo.bpy, CurrentBand)


        END ELSE BEGIN

            SmoothNDVI=Call_New_Smoother(mLocal)                    ;,x,y)
            mLocal.mData.Smooth = SmoothNDVI(*)

            IF(mLocal.minfo.nb GT mlocal.minfo.bpy  AND $
               mLocal.minfo.dt lt 3) THEN $
                     mMetrics=ComputeMetrics(poly(mLocal.mData.Smooth,$
                              mLocal.NDCoefs), WindowLength, $
                              mlocal.minfo.bpy, CurrentBand)

        END

        SmoothNDVI = mLocal.mData.Smooth
        RawNDVI = mLocal.mData.Raw

	tstr = 'X: '+strcompress(x,/Remove_All)+$
               '  Y: '+strcompress(y,/Remove_All)

        Widget_Control, mLocal.wZoomPlot, get_value=wzp
        wset, wzp

;
; Plot zoomed in plot to screen
;
        SM_PlotZoom, mLocal, mMetrics

;
; Get Current Plot Parameters
;
	Widget_Control,mLocal.wXMin,get_value=xmin
	Widget_Control,mLocal.wXMax,get_value=xmax

        inumbers = findgen(mLocal.minfo.nb)
        xnumbers = band2year(findgen(xmax - xmin+1) + xmin, $
                   StartYear, mLocal.minfo.nb, mLocal.minfo.bpy)


;
; Do little metrics plots
;

        Widget_Control, mLocal.wDiffPlot, get_value=wdp
        wset, wdp

        PlotThoseMetrics, SmoothNDVI, mMetrics, mLocal.minfo.bpy, $
            mLocal.NDCoefs, background=!p.background,startyear=startyear

;
; Plot full data set in PlotOptions box
;
        Widget_Control, mLocal.wFullPlot, get_value=wfp
        wset,wfp
        !p.multi=0

        yMin0 = mLocal.minfo.MinVal
        yMax0 = mLocal.minfo.MaxVal 

	plot,inumbers,RawNDVI,$
             yrange=[ymin0,ymax0],xrange=[min(inumbers),max(inumbers)], $
	     color=0, title=tstr, $
             /xstyle,  /ystyle, $
             xmargin=[5,1],ymargin=[2,2]

        mPlotBox = mLocal.mPlotBox
        mPlotBoxOld=mPlotBox

        Widget_Control, mLocal.wXMin, Get_Value=XMin
        Widget_Control, mLocal.wXMax, Get_Value=XMax
        Widget_Control, mLocal.wYMin, Get_Value=YMin
        Widget_Control, mLocal.wYMax, Get_Value=YMax
        mPlotBox.XBox = [XMin, XMax, XMax, XMin, XMin]
        mPlotBox.YBox = [YMin, YMin, YMax, YMax, YMin]

        fpgeo=Widget_Info(mLocal.wFullPlot, /Geometry)

        IF (mLocal.PixMapID GT 0) THEN  WDelete, mLocal.PixMapID
           Window, /Free, /Pixmap, XSize=fpgeo.XSize, YSize=fpgeo.YSize
           mLocal.PixMapID=!D.Window
           Device, Copy=[0,0,fpgeo.XSize-1, fpGeo.YSize-1, 0, 0, wfp]
           WSet, wfp

           PlotS, mPlotBox.XBox, mPlotBox.YBox, Color=rgb(255,0,0), /Data
           oplot, inumbers(xmin:xmax), SmoothNDVI(xmin:xmax), $
                  color = rgb(255,0,0)

;IF (mLocal.PixMapID LT 0) THEN Color=rgb(0,0,0) ELSE Color=rgb(255,0,0)
;        plots, mPlotBox.XBox, mPlotBox.YBox, color=Color
;        Draw_Box, mPlotBox, mLocal.mPlotBoxOld, /Data, Color=rgb(255,0,0)

        mLocal.mPlotBoxOld=mLocal.mPlotBox

        mLocal.fpscale=[!X.S, !Y.S]



        mLocal.mData.xyOld = [x,y]
        mLocal.mData.SmoothOld = mLocal.mData.Smooth
        mLocal.mData.RawOld = mLocal.mData.Raw

     END;wPlotPt

    'dt':BEGIN
	print,ev.value
     END;dt
    'ftype':BEGIN
	print,ev.index
     END;ftype
    'quit':BEGIN
        WIDGET_CONTROL,/destroy,ev.top
     END;quit
    'gencube':BEGIN
        Widget_Control, /hourglass
        gen_cube, mLocal
     END;gencube




;=== BGENPS ===
; 
;  Generate a PostScript Plot
;

    'bGenPS': BEGIN
        !p.background=rgb(180,180,180)
        !p.color=0

        file=dialog_pickfile(filter='*.ps', /write)

        IF(file NE '') THEN BEGIN
           Widget_Control,mLocal.xtxt,get_value=x
           Widget_Control,mLocal.ytxt,get_value=y
           Widget_Control, mLocal.wMetricOpt, Get_Value=tmp
           SWindowLength=tmp.SWindowLength 
           EWindowLength=tmp.EWindowLength 
           CurrentBand=tmp.CurrentBand 
           WindowLength=[SWindowLength, EWindowLength]

        IF(mLocal.minfo.nb GT mlocal.minfo.bpy  AND $
                     mLocal.minfo.dt lt 3) THEN $
           mMetrics=ComputeMetrics(poly(mLocal.mData.Smooth, mLocal.NDCoefs), $
                 WindowLength,  mlocal.minfo.bpy, CurrentBand)


        tstr = 'X: '+strcompress(x,/Remove_All)+'    Y: '+$
                          strcompress(y,/Remove_All)

;
; Read plot parameters
;
        Widget_Control, mLocal.wMetricOpt, Get_Value=tmp
        StartYear=tmp.StartYear

        Widget_Control,mLocal.wXMin,get_value=xmin
        Widget_Control,mLocal.wXMax,get_value=xmax
        Widget_Control,mLocal.wYMin,get_value=ymin
        Widget_Control,mLocal.wYMax,get_value=ymax

;        Widget_Control,mLocal.ydmin,get_value=ydmin
;        Widget_Control,mLocal.ydmax,get_value=ydmax
;        xmin = fix(xmin_year); - mLocal.minfo.bpy)
;        xmax = fix(xmax_year); - 1)

        inumbers = findgen(mLocal.minfo.nb)
        xnumbers = band2year(findgen(xmax - xmin+1) + xmin, $
                     StartYear, mLocal.minfo.nb, mLocal.minfo.bpy)


;
; Plot Zoomed in Data
;
        CurDev=!D.Name
        Set_Plot, 'PS'
        Device, file=file, /color, bits=8, /Landscape;, /Encapsulated
        loadct,12

        SM_PlotZoom, mLocal, mMetrics, /PS

        device, /close
        set_plot, curdev
        loadct, 0

        END;file ne ''

     END;bGenPS
   ENDCASE;uvalue

   IF (Widget_Info(ev.top, /Valid_ID)) THEN $
        Widget_Control, ev.top, Set_UValue=mLocal

END;event_handler

;=============================;
; WIDGET DEFINITION: smoother ;
;=============================;

FUNCTION smoother, mParent

;
; Get Default values for smoother interface
;
@smoother_defaults

;
; Open input file if it doesn't already exist
;

   ;IF (mParent.wOpenFIle EQ -1) THEN mParent.wOpenFile=Open_File(mParent)
   IF (mParent.wOpenFIle EQ -1) THEN mParent.wOpenFile=Open_File()
   IF (mParent.wOpenFIle EQ -1) THEN return, -1
   Widget_Control, mParent.wOpenFile, Get_UValue= mInfo


   !order = 1
   !p.background=rgb(180,180,180)
   !p.color=0
 
  

   NDCoefs=scalecoef(mInfo.MinVal, mInfo.MaxVal, -1.0, 1.0)

   wBase = Widget_Base(title='Seasonal Metrics Display',/row, $
                     Group_Leader=mParent.wBase)

   lbase = Widget_Base(wBase,/column,/frame)

   asText = ["Plotter", "Smoother", "Metrics"]
   bgOptions = cw_bgroup(lbase, asText, set_value=0, row=1, /exclusive,$
                uvalue="bgOptions",/frame)

   spoptbase = Widget_Base(lbase)
   Widget_Control, spoptbase, Set_UValue=wBase

;======
; Smoother Options
;
   wSmoothOpt=CW_SmoothOpt(spoptbase)
   sm_def.swin_def=minfo.bpy
   Widget_Control, wSmoothOpt, Set_Value=sm_def

   wsbasegeo = Widget_Info(wSmoothOpt, /geometry)
;
;======
 
;
; Plotter Options
;

;   wPlotOpt=CW_PlotOpt(spoptbase)
;   plot_def.XMax_def=minfo.nb-1
;   plot_def.YMin_def=minfo.YMin
;   plot_def.YMax_def=minfo.YMax
;   Widget_Control, wPlotOpt, Set_Value=pl_def

   wPlotOpt = Widget_Base(spoptbase,/column,/frame, map=1)
   plabel = Widget_Label(wPlotOpt,value="Plot Parameters:")
   xbase = Widget_Base(wPlotOpt,/row)
   wXMin = cw_field(xbase,/integer,title="X Min: ",value=0,xsize=5)
   wXMax = cw_field(xbase,/integer,title="X Max: ",$
 			value=minfo.nb-1,xsize=5)
;  asText=["Periods","Years"]
;  xunit = Widget_Droplist(xbase, value=asText)

   ybase = Widget_Base(wPlotOpt,/row)
   wYMin = cw_field(ybase,/integer,title="Y Min: ",value=0,xsize=5)
   wYMax = cw_field(ybase,/integer,title="Y Max: ", $
           value=fix(mInfo.MaxVal),xsize=5)
;  asText=["Data","NDVI"]
;  yunit = Widget_Droplist(ybase, value=asText)
;  dlabel = Widget_Label(wPlotOpt,value="Difference Plot Parameters:")
;  dbase = Widget_Base(wPlotOpt,/row)
;  ydmin = cw_field(dbase,/integer,title="Y Min: ",value=-200,xsize=5)
;  ydmax = cw_field(dbase,/integer,title="Y Max: ",value=200,xsize=5)
   wpbasegeo = Widget_Info(wPlotOpt, /geometry)


   label=Widget_Label(wPlotOpt, Value='Plot Range:')
   wFullPlot = Widget_Draw(wPlotOpt,/Button_Events, $
               /Motion_Events, uvalue='wFullPlot',/frame,$
               xsize=wpbasegeo.xsize, ysize=wsbasegeo.ysize-wpbasegeo.ysize)

  
;=====
;  Metrics Options
;
   wMetricOpt=CW_MetricOpt(spoptbase)
   met_def.CurrentBand_def = (minfo.nb-1) mod minfo.bpy
   Widget_Control, wMetricOpt, Set_Value=met_def
;
;=====

 

   wpsbase = Widget_Base(lbase,column=1,/frame)
   pslbase=Widget_Base(wpsbase,/column )
   pslabel = Widget_Label(pslbase,value="Plot Single Point:")
   wXYBase = Widget_Base(pslbase,/row)
   wPlotPt = Widget_Button(wXYBase,value='Plot Point:',uvalue='wPlotPt')
   x = cw_field(wXYBase,/integer,title="X:",value=0,xsize=5)
   y = cw_field(wXYBase,/integer,title="Y:",value=0,xsize=5)
;  gencube = Widget_Button(lbase,value='Generate Cube',uvalue='gencube')
 
 
 
   bgPlot = cw_bgroup(wpsbase, ShowText_def, set_value=ShowBut_def, $
                     column=3, /nonexclusive,$
                uvalue="bgPlot",label_top="Show")

   bGenPS = Widget_Button(lbase,value='Plot PostScript',uvalue='bGenPS')
   qu = Widget_Button(lbase,value='QUIT',uvalue='quit')

   lbasegeo = Widget_Info(lbase, /geometry)

   rbase = Widget_Base(wBase,/column,/frame)

   wZoomPlot = Widget_Draw(rbase, uvalue='wZoomPlot', /frame, $
               xsize=500, ysize=(lbasegeo.ysize-10)/2, $
                     /Motion_Events, /Button_Events)

   wDiffPlot = Widget_Draw(rbase, uvalue='DiffPlot', /frame, $
               xsize=500, ysize=(lbasegeo.ysize-10)/2)

   wfXYonPlot = Widget_Base(rBase, /Row, /Align_Center)
   wXonPlot = CW_Field(wfXYonPlot, title="Date:", XSize=11, /NoEdit)
   wYonPlot = CW_Field(wfXYonPlot, title="NDVI:", XSize=6, /NoEdit)








   IF(n_elements(fpscale) eq 0) THEN $
      fpscale = fltarr(4)
   IF(n_elements(zpscale) eq 0) THEN $
      zpscale = fltarr(4)



   mPlotBox = {mBox}

   mSmoothParam = {msmoothparam}

   Widget_Control, wXMin, Get_Value=XMin
   Widget_Control, wXMax, Get_Value=XMax
   Widget_Control, wYMin, Get_Value=YMin
   Widget_Control, wYMax, Get_Value=YMax
   mPlotBox.XBox = [XMin, XMax, XMax, XMin, XMin]
   mPlotBox.YBox = [YMin, YMin, YMax, YMax, YMin]
   mPlotBoxOld = mPlotBox

   CASE (minfo.dt) OF
      1: mData = {xyNew:[-1,-1], xyOld:[-1,-1], $
                  raw:  bytarr(minfo.nb), smooth: bytarr(minfo.nb), $
                  rawold:  bytarr(minfo.nb), smoothold: bytarr(minfo.nb)}
      2: mData = {xynew:[-1,-1], xyOld:[-1,-1], $
                  raw: intarr(minfo.nb), smooth: intarr(minfo.nb), $
                  rawold: intarr(minfo.nb), smoothold: intarr(minfo.nb)}
      3: mData = {xynew:[-1,-1], xyOld:[-1,-1], $
                  raw: lonarr(minfo.nb), smooth: intarr(minfo.nb), $
                  rawold: lonarr(minfo.nb), smoothold: lonarr(minfo.nb)}
      4: mData = {xynew:[-1,-1], xyOld:[-1,-1], $
                  raw: fltarr(minfo.nb), smooth: fltarr(minfo.nb), $
                  rawold: fltarr(minfo.nb), smoothold: fltarr(minfo.nb)}
      ELSE:
   ENDCASE

   mParent.wSmoother = wBase
   mLocal = {mParent: mParent, $
             wBase:wBase, $				; BASE WIDGET

             wPlotOpt:wPlotOpt, $			; CHILD WIDGETS
             wSmoothOpt:wSmoothOpt, $
             wMetricOpt:wMetricOpt, $     

             minfo:minfo, $    				; Info Structures
             mSmoothParam: mSmoothParam, $
             mData:mData, $

             NDCoefs: NDCoefs, $
             wXMin:wXMin, wXMax:wXMax, xtxt:x,  $	; PLOT PARAMS
             wYMin:wYMin, wYMax:wYMax, ytxt:y,  $
   ;          ydmin:ydmin, ydmax:ydmax, $
             fpscale:fpscale, $
             zpscale:zpscale, $
             mPlotBox:mPlotBox, $
             mPlotBoxOld:mPlotBoxOld, $
             MouseClick1: -1L, MouseClick2: -1L,$	; MOUSE BUTTON STATUS
             PixMapID: -1L, $
             ChangeX: -1L, ChangeY: -1L, $
             bgOptions:bgOptions, $
             wFullPlot:wFullPlot, wZoomPlot:wZoomPlot, $
             wDiffPlot:wDiffPlot,bgPlot:bgPlot,$
             bGenPS: bGenPS, $
             wXonPlot:wXonPlot, wYonPlot:wYonPlot $
            }
          
   Widget_Control, wBase, Set_UValue=mLocal
   Widget_Control,wBase,/Realize

   XManager,'smoother',wBase,event_handler='smoother_event', /No_Block

Return, wBase
END;smoother
