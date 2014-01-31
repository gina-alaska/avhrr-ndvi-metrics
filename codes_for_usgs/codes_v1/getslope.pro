FUNCTION GetSlope, Start_End, MaxND, bpy,DaysPerBand

;
; This function calculates the slope-up and slope-down for
; ndvi data using start, end and maxnd for each year that
; all three quantities exist.
;
   FILL=-1.0
; DaysPerBand=365./bpy         ; This is used to scale results to /day

   sSize=Size(Start_End.SOST)
   ny=sSize[sSize[0]]


   SlopeUp=Make_Array(Size=sSize)+FILL
   SlopeDown=Make_Array(Size=sSize)+FILL

;
; Up slope
;
   NotZero=Where(Start_End.SOST-MaxND.MaxT lt  0, nZ)
   FillIdx=where(Start_End.SOST EQ FILL OR MaxND.MaxT EQ FILL,nF)

   IF (nz gt 0) THEN $
      SlopeUp[NotZero]=(Start_End.SOSN[NotZero]-MaxND.MaxN[NotZero])/ $
                       (Start_End.SOST[NotZero]-MaxND.MaxT[NotZero])/ $
                        DaysPerBand
   IF (nF gt 0) THEN $
      SlopeUp[FillIdx]=FILL


;
; Down Slope
;
   NotZero=Where(Start_End.EOST-MaxND.MaxT gt 0, nZ)
   FillIdx=where(Start_End.EOST EQ FILL OR MaxND.MaxT EQ FILL,nF)

;
; Take absolute value of slope down.  Negative slope is implied.
; This is done to because our FILL value is set to a negative number
; and we don't want any ambiguities.
;
   IF (nz gt 0) THEN $
      SlopeDown[NotZero]=(Start_End.EOSN[NotZero]-MaxND.MaxN[NotZero])/ $
                         (Start_End.EOST[NotZero]-MaxND.MaxT[NotZero])/ $
                         DaysPerBand
   IF (nF gt 0) THEN $
      SlopeDown[FillIdx]=FILL

   Slope={SlopeUp:SlopeUp, SlopeDown:SlopeDown}

RETURN, Slope
END
