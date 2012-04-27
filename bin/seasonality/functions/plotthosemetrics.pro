PRO PlotthoseMetrics, NDVI, mMetrics, bpy, NDCoefs, $
       background=background, StartYear=StartYear

CASE (BPY) OF
   24: band2weeks=15.
   26: band2weeks=14.
   36: band2weeks=10.
   52: band2weeks=7.
   ELSE: band2weeks=float(round(365./bpy))
ENDCASE


;loadct, 0
;wSet, WindowNum
   nseasons=n_elements(mMetrics.TotalNDVI)
   nNDVI=n_elements(NDVI)
   X=StartYear+findgen(nNDVI)/bpy

   OldMulti = !P.Multi
   !P.Multi=[0,2,2]


;
; TOTAL NDVI BAR CHART
;
   Colors=lonarr(nseasons)+background
   IF (KEYWORD_SET(StartYear)) THEN BEGIN
      BarNames=strcompress(round_to(StartYear+indgen(nseasons), 1), /Remove_All)
      barnames=strmid(barnames, 2,2)
      IF (nseasons gt 8) then barnames[where(float(barnames) mod 2 ne 0)]=' '
   END

   Bar_Plot, mMetrics.TotalNDVI, Title="Total NDVI", /Outline, Colors=Colors, $
      background=background, BarNames=Barnames, XTitle='Year'


;
; PLOT GROWING SEASON
;
   Plot, X, Poly(NDVI, NDCoefs), /XStyle, $
      Title='Growing Seasons', YTitle='NDVI', XTitle='Year'
   OPlotGap, StartYear+mMetrics.GrowingT/bpy, mMetrics.GrowingN,2./bpy, $
             Color=rgb(0,255,0)
   OPlotGap, StartYear+mMetrics.GrowingT/bpy, mMetrics.GrowingB,2./bpy, $
             Color=rgb(255,0,0)


;
; PLOT MAXN, SOST, EOST Date vs Year
; 
   intyear=startyear+findgen(nseasons)
   intmonth=mmetrics.maxt mod bpy /bpy * 12
   intsost=mmetrics.sost mod bpy / bpy *12
   inteost=mmetrics.eost mod bpy / bpy *12
   
   a=where (inteost lt intsost, na)
   IF (na gt 0) then inteost[a]=inteost[a]+12

   a=where (intmonth lt intsost, na)
   IF (na gt 0) then intmonth[a]=intmonth[a]+12

maxmed=median(intmonth)
a=where(abs(intmonth-maxmed) gt 6,na)
if (na gt 0) then intmonth[a]=intmonth[a]-(12*sign(intmonth[a]-maxmed))

maxmed=median(intsost)
a=where(abs(intsost-maxmed) gt 6,na)
if (na gt 0) then intsost[a]=intsost[a]-(12*sign(intsost[a]-maxmed))
maxmed=median(inteost)
a=where(abs(inteost-maxmed) gt 6,na)
if (na gt 0) then inteost[a]=inteost[a]-(12*sign(inteost[a]-maxmed))

   snz=where(mmetrics.sost ne 0, nsnz)
   enz=where(mmetrics.eost ne nNDVI-1, nenz)


   if nsnz gt 0 then $
     ymin=floor(min(intsost(snz) )-1) $
   else ymin=0
   if nenz gt 0 then $
      ymax=ceil(max(inteost(enz) )+1) $
   else ymax=nndvi


   
   months=monthnames(index=indgen((ymax-ymin+1)/2)*2+ymin)
   monthsv=indgen((ymax-ymin+1)/2)*2+ymin

   plot, intyear, intmonth , /nodata, $
      Title='Maximum NDVI', XTitle='Year', YTitle='Date', $
      xrange=[min(intyear)-1, max(intyear)+1], /xstyle, $
      yrange=[ymin,ymax],  /ystyle,  $
      ytickname=months, yticks=n_elements(months)-1, yminor=2, xminor=2, $
      ytickv=monthsv
       
      
oplot, [min(intyear)-1, max(intyear)+1], [0,0], line=1
oplot, [min(intyear)-1, max(intyear)+1], [12,12], line=1

   for i=0, nseasons-1 do BEGIN
      IF (mmetrics.maxn[i] ne 0) then BEGIN

         IF (nseasons le 8) then BEGIN
            xyouts, intyear[i] , intmonth[i],flt2str( mmetrics.maxn[i],2),$
                 align=0.5, charsize=0.8
         END ELSE BEGIN

            usersym, [-1, 1, 1, -1, -1], [.5, .5, -.5, -.5, .5], color=rgb(255,0,0)
            IF (mmetrics.maxn[i] GT 0 AND mmetrics.maxt[i] GT 0) then $
                plots, intyear[i], intmonth[i], psym=8
         END
      END

      usersym, [-1, 1, 1, -1, -1], [.5, .5, -.5, -.5, .5], color=rgb(0,255,0)
      IF (mmetrics.sosn[i] GT 0 AND mmetrics.sost[i] GT 0) then $
          plots, intyear[i], intsost[i], psym=8
   
      usersym, [-1, 1, 1, -1, -1], [.5, .5, -.5, -.5, .5], color=rgb(0,0,255)
      IF (mmetrics.eosn[i] GT 0 AND mmetrics.eost[i] ne nNDVI-1) then $
          plots, intyear[i], inteost[i], psym=8

   END



;
; Plot Length of season
;
   LengthOfSeason=mMetrics.RangeT*Band2Weeks

   noseason=where(mmetrics.sost eq 0, nNoSeason )
   IF (nNoSeason GT 0) THEN LengthOfSeason[noseason] = 0

   noseason=where(mmetrics.eost eq nNDVI-1, nNoSeason )
   IF (nNoSeason GT 0) THEN LengthOfSeason[noseason] = 0

;   Bar_Plot, LengthOfSeason, Title="Length of Season", /Outline, $
;      Colors=Colors, background=background, BarNames=Barnames, $
;      XTitle='Year', YTitle='Days'

      usersym, [-1, 1, 1, -1, -1], [.5, .5, -.5, -.5, .5], color=rgb(0,0,255)

tmp=mMetrics.NDVItoDate
a=where(mMetrics.NDVItoDate lt 0, na)
if (na gt 0) then tmp[a]=0.0
;Plot, tmp, min=0, psym=8 $
;   Bar_Plot, mMetrics.NDVItoDate, Title="NDVI to Date", /Outline, $
   Bar_Plot, tmp, Title="NDVI to Date", /Outline, $
      Colors=Colors, background=background, BarNames=Barnames, $
      XTitle='Year', YTitle='NDVI to Date'

;plot, mMetrics.TotalNDVI, mMetrics.NDVItoDate, psym=4, /ynozero, /nodata
;for i=0, nseasons-1 do begin
;xyouts, mmetrics.TotalNDVI[i], mMetrics.NDVItoDate[i], BarNames[i]
;end

   !P.Multi=OldMulti

;die

END
