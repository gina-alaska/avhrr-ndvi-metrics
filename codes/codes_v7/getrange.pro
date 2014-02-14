FUNCTION GetRange, Start_End, MaxND, bpy,DaysPerBand

;
; This function calculates the ranges of the seasons both
; in time (length of season) and ndvi (ndvi range) whenever
; both a start and end are found, otherwise the length is
; set to zero
;

FILL=-1.0

;DaysPerBand=365./bpy


;RangeT=(Start_End.EOST-Start_End.SOST)*DaysPerBand/365.
;RangeT=(Start_End.EOST-Start_End.SOST)/bpy
;
RangeT=(Start_End.EOST-Start_End.SOST)*DaysPerBand

RangeN=MaxND.MaxN-(Start_End.EOSN<Start_End.SOSN)


BadLength = where (Start_End.EOST lt 0 or Start_End.SOST lt 0 or $
                   RangeT lt 0,nBad)

;BadLength = where (RangeT LE 0 or RangeT GT DaysPerBand*bpy*1.5,nBad)

IF (nBad GT 0) THEN RangeT(BadLength) = FILL
IF (nBad GT 0) THEN RangeN(BadLength) = FILL

Range={RangeT:RangeT, RangeN:RangeN}

Return, Range
END
