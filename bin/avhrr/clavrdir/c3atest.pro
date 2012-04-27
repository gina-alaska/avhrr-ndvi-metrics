FUNCTION c3atest, data, jd, c3a, c3at, SATNUM = satnum

T3 = data(*,*,2)
T4 = data(*,*,3)
T5 = data(*,*,4)

ImgSize = Size(t3)

;
;  Constants
;
c1=1.1910659d-5         ; Planck's 1st
c2=1.438833d0           ; Planck's 2nd
d2r=3.1415926d0/180.d0  ; Degrees to Radians

;
;  Satellite dependent constants.  Default is NOAA-14
;
if(KEYWORD_SET(SATNUM)) THEN BEGIN
CASE SATNUM of
   9:   BEGIN
           nu = 2678.11d0
           s3 = 16.682d0
           a3 = 0.94249d0
           b3 = -2.6590d0
           c3 = 1.6855d0
           d3 = -1.25d0
        END
   11:  BEGIN
           nu = 2670.95d0
           s3 = 16.62d0
           a3 = 0.96242
           b3 = -2.12758
           c3 = 1.16516
           d3 = -0.744
        END
   else:BEGIN
           nu = 2645.899
           s3 = 15.805d0
           a3 = 1.000d0
           b3 = -2.915924d0
           c3 = 1.92754d0 ;? is second digit a 9 or a 4 ?
           d3 = -1.21284d0
        END
ENDCASE
ENDIF ELSE BEGIN
           nu = 2645.899
           s3 = 15.805d0
           a3 = 1.000d0
           b3 = -2.915924d0
           c3 = 1.92754d0 ;? is second digit a 9 or a 4 ?
           d3 = -1.21284d0
ENDELSE

nu3=nu*nu*nu
t3coef = [b3/a3, c3/a3, d3/a3]

;
; C3AT, channel 3 albedo test: separate emissive and reflective components
; of ch 3 signal, is cloudy if ch 3 reflectance is high (> .06)
;

t3e = - (t3coef(0)*t4) - (t3coef(1)*t5) - t3coef(2)
bt3 = c1*nu3/(exp(c2*nu/T3)-1.0d0)
bt3e = c1*nu3/(exp(c2*nu/t3e)-1.0d0)
delr3 = bt3-bt3e
c3a = 3.1415926d0*delr3/(cos(data(*,*,7)*d2r)*s3)
c3at = (c3a ge .06)

shad3 = c3a lt 0

return, c3a

END
