FUNCTION   avhrrscale, data, BYTE = byte, I2 = i2, RAD=rad, REF=ref

;
;  This Function scales AVHRR data from physical units 
;  to BYTE or 10Bit-I*2.
;
;  The default is 10BIT, but BYTE can be specified by
;  using the BYTE keyword.
;
;  The equation used for scaling is:
;
;     scaled = (actual*scale)+offset
;
;  ***NOTE*** at this point, this code doesn't do anything
;  to keep the data within bounds
;

ns = n_elements(data(*,0))
nl = n_elements(data(0,*))

if (KEYWORD_SET(BYTE)) then  begin
  @us_byte.h 
  scaled = bytarr(ns, nl)
endif else begin
  @avhrr_10bit.h
  scaled = intarr(ns, nl)
endelse

if (KEYWORD_SET(RAD)) then begin
  rscl = radscl
  roff = radoff
endif else if(KEYWORD_SET(REF)) then begin
  rscl = refscl
  roff = refoff
endif



putband, scaled, 0, round((getband(data, 0,ns)*Rscl + Roff)), ns         ; Band 1
putband, scaled, 1, round((getband(data, 1,ns)*Rscl + Roff)), ns         ; Band 2
putband, scaled, 2, round((getband(data, 2,ns)*Tscl + Toff)), ns         ; Band 3
putband, scaled, 3, round((getband(data, 3,ns)*Tscl + Toff)), ns         ; Band 4
putband, scaled, 4, round((getband(data, 4,ns)*Tscl + Toff)), ns         ; Band 5
putband, scaled, 5, round((getband(data, 5,ns)*Nscl + Noff)), ns         ; NDVI 
putband, scaled, 6, round((getband(data, 6,ns)*SatZscl + SatZoff)), ns   ; SatZen
putband, scaled, 7, round((getband(data, 7,ns)*SolZscl + SolZoff)), ns   ; SolZen
putband, scaled, 8, round((getband(data, 8,ns)*RelAzscl + RelAzoff)), ns ; |RelAz|
putband, scaled, 9,  getband(data, 9,ns), ns                      ; Date

if(nl/ns gt 10) then begin
  putband, scaled,10,  getband(data,10,ns), ns                      ;
  putband, scaled,11,  getband(data,11,ns), ns                      ; Cloud
endif

return, scaled
end
