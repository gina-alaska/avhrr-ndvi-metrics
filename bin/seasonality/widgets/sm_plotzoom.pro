PRO SM_PlotZoom, mLocal, mMetrics, PS=PS, EIGHTBPP=EIGHTBPP

;   Widget_Control, mLocal.mParent.wFullView, Get_UValue=mFullView
;   customColor=mFullView.customColor

; ======== MJS 5/27/99 - These two lines were my attempt to replace
;                        the COLORS structure below using the current
;                        palette from the image viewer for METRICS2.
;                        I'm not quite sure why it didn't work, but
;                        it might be useful at some point.  Similar
;                        changes would need to be made in SMOOTHER.PRO
;                        and PLOTTHOSEMETRICS.PRO
;   ct=UpdateCT()
;   colors=GetPlotColors(ct, customColor)

;
; This function plots the Smoother Zoomed in window
;

;
; Set Colors depending on whether 8 or 24bit
;
   CASE (KEYWORD_SET(PS) OR KEYWORD_SET(EIGHTBPP)) OF
      
     0: BEGIN
          colors={ Red:rgb(255,0,0) $
                 , Green:rgb(0,255,0) $
                 , Blue:rgb(0,0,255) $
                 , Black:rgb(0,0,0) $
                 , White:rgb(255,255,255) $
                 , Cyan:rgb(0,255,255) $
                 , Magenta:rgb(255,0,255) $
                 , Yellow:rgb(255,255,0) $
                 , LightYellow:rgb(220,220,0) $
                 , LightBlue:rgb(0,220,220) $
                 }

        END;

     1: BEGIN
          LoadCT, 12
          colors={ Black:0 $
                 ; Green:32 $
                 ; Blue:96 $
                 ; Red:176 $
                 ; LightBlue:80 $
                 ; LightYellow:32 $
                 ; Yellow:32 $
                 }

        END

     ELSE:
   ENDCASE

;
; Plot Zoomed in Data
;
; 
; Get Current Plot Parameters
;       
;
; Get current data point
;
        Widget_Control,mLocal.xtxt,get_value=x
        Widget_Control,mLocal.ytxt,get_value=y
        tstr = 'X: '+strcompress(x,/Remove_All)+$
               '  Y: '+strcompress(y,/Remove_All)

            SmoothNDVI = mLocal.mData.Smooth
            RawNDVI = mLocal.mData.Raw

        Widget_Control,mLocal.wXMin,get_value=xmin
        Widget_Control,mLocal.wXMax,get_value=xmax
        Widget_Control,mLocal.wYMin,get_value=ymin
        Widget_Control,mLocal.wYMax,get_value=ymax
;       Widget_Control,mLocal.ydmin,get_value=ydmin
;       Widget_Control,mLocal.ydmax,get_value=ydmax
        Widget_Control, mLocal.wMetricOpt, Get_Value=tmp
        StartYear=tmp.StartYear
;        Widget_Control, mLocal.wStartYear, Get_Value=StartYear

        
        inumbers = findgen(mLocal.minfo.nb)
        xnumbers = band2year(findgen(xmax - xmin+1) + xmin, $
                   StartYear, mLocal.minfo.nb, mLocal.minfo.bpy)



;       Widget_Control, mLocal.wZoomPlot, get_value=wzp
;       wset, wzp
        afilename=str_sep(mLocal.minfo.file, '/')
        filename=afilename[n_elements(afilename)-1]

        plot,xnumbers,poly(RawNDVI(xmin:xmax),mLocal.NDCoefs), $
                        YRange=poly([ymin,ymax],mLocal.NDCoefs),$
                        XRange=[min(xnumbers), max(xnumbers)], color=colors.black, $
                        Title=filename+'  '+tstr, $
                        /XStyle, /NoData, /YStyle, $
                        XTitle='Year', $
                        YTItle='NDVI'

        Widget_Control, mLocal.bgPlot, get_value=butval


; Raw Data
        IF (butval[1] EQ 1) THEN $
           oplot, xnumbers, poly(RawNDVI(xmin:xmax),mLocal.NDCoefs),color=colors.black

; Smoothed Line
        IF (butval[0] EQ 1) THEN $
           oplot, xnumbers,poly(SmoothNDVI(xmin:xmax),mLocal.NDCoefs), $
                  color = colors.red

; Forward Moving Average
        IF (butval[6] EQ 1) THEN BEGIN
           oplot, xnumbers, mMetrics.FwdMA[Xmin:Xmax], color=colors.Yellow
        END

; Backward Moving Average
        IF (butval[7] EQ 1) THEN BEGIN
           oplot, xnumbers, mMetrics.BkwdMA[Xmin:Xmax], color=colors.Blue
        END



; Start of Season
        SOSfracyear = band2year(mMetrics.SOST, StartYear, mLocal.minfo.nb, mLocal.minfo.bpy)
        IF (butval[3] EQ 1) THEN $
           oplot, SOSfracyear,  mMetrics.SOSN, psym=4, color=colors.Green


; End of Season
        EOSfracyear = band2year(mMetrics.EOST, StartYear, mLocal.minfo.nb, mLocal.minfo.bpy)
        IF (butval[4] EQ 1) THEN $
           oplot, EOSFracYear,  mMetrics.EOSN, psym=4, color=colors.Blue

; Current Date
        Nowfracyear = band2year(mMetrics.NowT, StartYear, mLocal.minfo.nb, mLocal.minfo.bpy)
        IF (butval[5] EQ 1) THEN $
           oplot, NowFracYear, mMetrics.NowN, psym=4, color=colors.Black;, min=0.0001


           FOR i = 0, n_elements(mMetrics.sost) -2 DO BEGIN

              SOSMoDayFrac = frac2date(SOSfracyear[i+1], /CALENDAR)
              SOSMoDay = strmid(sosmodayfrac, 0, 6);Str_Sep(SOSMoDayFrac,' ')
              IF (butval[2] EQ 1) THEN $
                 xyouts, SOSFracYear[i+1], 0.0, SOSMoDay,orientation=90, Alignment=1.0,$
                      noclip=0

              EOSMoDayFrac = frac2date(EOSfracyear[i], /CALENDAR)
              EOSMoDay = strmid(eosmodayfrac, 0, 6);Str_Sep(EOSMoDayFrac,' ')
              IF (butval[2] EQ 1) THEN $
                 xyouts, EOSFracYear[i], 0.0, EOSMoDay,orientation=90, Alignment=1.0 ,$
                      noclip=0

           END




;
; Put Total NDVI on Plot
;
           FOR i = 0, n_elements(mMetrics.MaxT) -1 DO begin
              IF (butval[2] EQ 1 and mMetrics.MaxT[i] gt 0) THEN $
              xyouts, band2year(mMetrics.MaxT[i], StartYear, mLocal.minfo.nb, mLocal.minfo.bpy), $
                    mMetrics.MaxN[i],  flt2str(mMetrics.TotalNDVI[i], 1), noclip=0
           END


        mLocal.zpscale=[!X.S, !Y.S]

;
;
;---END CUT
;CASE (KEYWORD_SET(PS)) OF
;0: loadct,0
;else:
;endcase

end
