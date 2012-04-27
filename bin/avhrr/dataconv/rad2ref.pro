FUNCTION rad2ref, rad, band, SolZen, jd

;
; This function converts NOAA-14 radiance to
; reflectance using the Vermote constants
;

case(band) of
  1: begin
       F = 221.42 ; W/m^2
       W = 0.136  ; um
       K = 1./0.19569 ; VERMOTE
     end
  2: begin
       F = 252.29 ; W/m^2
       W = 0.245  ; um
       K = 1./0.30539 ; VERMOTE
     end
  else: MESSAGE, 'BAND must be 1 or 2'
endcase

case N_PARAMS() of
   2: begin
        jd = 0.0
        SolZen = rad*0.0
      end
   3: jd = 0.0
   4: jd = jd 
   else: MESSAGE, 'Wrong number of parameters in rad2ref'
endcase

d = sunearthdist(jd)

ref = rad*d^2/cos(d2r(SolZen))/K/100.0

return, ref

end
