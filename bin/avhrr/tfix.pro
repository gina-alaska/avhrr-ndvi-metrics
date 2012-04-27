;=== TFIX ==============================================
;  This function corrects the misapplication of the
;  nonlinearity correction for ADAPS processing of
;  NOAA-14 AVHRR Thermal data
;
;  It assumes the central wave numbers of the default 
;  temperature range options of US and 1km processing.
;
;  It takes as input an incorrectly processed data value
;  (scalar or array) and band number (3,4 or 5), and 
;  outputs the corrected value(s). 
;
;  The default is to correct temperatures, however
;  keywords are available to allow input to be BYTE or
;  I*2
;
;=======================================================
FUNCTION  tfix, Tbad, band, BYTE=byte, I2=i2

@noaa14cal.h
tmp=tbad
Tmin = 0.0

if(KEYWORD_SET(BYTE)) then begin
   TBad = b2k(TBad)
   Tmin = 203.0
   Tmax = 330.0
endif

if(KEYWORD_SET(I2))   then begin
   TBad = i2k(Tbad)
   Tmin = 160.0
   Tmax = 340.0
endif

case (band) of 
   3: begin
        Tlin3 = quadtbad(Tbad, coef3)
        Rlin3 = planck(Tlin3, cwn3)
        R3 = poly(Rlin3, coef3)
        T3 = R3*0

        gt0 = where (R3 gt 0 , ngt0)
        if (ngt0 gt 0) then T3(gt0) = planckinv(R3(gt0), cwn3)

        lt0 = where (R3 lt 0 or T3 lt Tmin, nlt0)
        if (nlt0 gt 0) then T3(lt0) = Tmin
        T = T3
;print, TBad, Tlin3, Rlin3, R3, T3
      end
   4: begin
        Tlin4 = quadtbad(Tbad, coef4)
        Rlin4 = planck(Tlin4, cwn4)
        R4 = poly(Rlin4, coef4)
        T4 = planckinv(R4, cwn4)
        T = T4
;print, tmp,TBad, Tlin4, Rlin4, R4, T4
      end
   5: begin
        Tlin5 = quadtbad(Tbad, coef5)
        Rlin5 = planck(Tlin5, cwn5)
        R5 = poly(Rlin5, coef5)
        T5 = planckinv(R5, cwn5)
        T = T5
      end
   else: MESSAGE, 'ERROR: BAND must be 3, 4 or 5'
endcase

if(KEYWORD_SET(BYTE)) then T = byte(round(k2b(T)))
if(KEYWORD_SET(I2))   then T = long(round(k2i(T)))

Tbad = tmp

return, T
end
