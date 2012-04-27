;=====   SCALECOEF   =========================================
; This function calculates the linear scale transformation
; coefficients a(0) and a(1) for
;
;       Xoutput = a(0) + a(1)Xinput
;     
; where the transformation is a linear scaling from
;
;       Tmin:Tmax  to  Xmin:Xmax
;
;=============================================================

FUNCTION   scalecoef,Tmin,Tmax,Xmin,Xmax

a = fltarr(2)
a(1) = Float(Xmax - Xmin)/(Tmax - Tmin)
a(0) = Xmax - a(1)*Tmax

return,a
end
