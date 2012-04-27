FUNCTION   avhrrunscale, data, BYTE = byte, I2 = i2, RAD=rad, REF=ref

;
;  This Function unscales AVHRR data from its BYTE or 10BIT
;  form to physical units.
;
;  The default is 10BIT, but BYTE can be specified by
;  using the BYTE keyword.
;
;  The equation used for unscaling is:
;
;     actual = (scaled-offset)/scale
;

ImgSize = Size(Data)
NS = ImgSize(1)

if (KEYWORD_SET(BYTE)) then  begin
   DataType = 0
endif else begin
   DataType = 1
endelse

if (KEYWORD_SET(RAD)) then begin
   Rad = 1
   Ref = 0
endif else if(KEYWORD_SET(REF)) then begin
   Rad = 0
   Ref = 1
endif


CASE ImgSize(0) of
   2:  BEGIN
          Actual = fltarr(ImgSize(1), ImgSize(2))
          FOR iBand = 0, ImgSize(2)/ImgSize(1)-1 DO BEGIN
             TMP = ConvertAny(GetBand(data,iBand, ns), $
                   Band=iBand, DATATYPE=datatype, REF=Ref, RAD=Rad)
             PutBand, Actual, iBand, TMP, ns
          ENDFOR
       END
   3:  BEGIN
          Actual = fltarr(ImgSize(1), ImgSize(2), ImgSize(3))
          FOR iBand = 0, ImgSize(3)-1 DO BEGIN
             TMP = ConvertAny(Data(*,*,iBand), $
                   Band=iBand, DATATYPE=datatype, REF=Ref, RAD=Rad)
             Actual(*,*,iBand) = TMP
          ENDFOR
       END
   ELSE:
ENDCASE


return, actual
end

