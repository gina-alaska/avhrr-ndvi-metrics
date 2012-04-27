FUNCTION  OffNadir, LookAngle, Altitude, NadirSize 

;
; This function returns the size of an off nadir pixel
; It takes into account the curvature of the earth
;
; Input:
;    LookAngle: Satellite view angle in degrees
;    Altitude : Satellite altitude in km
;    NadirSize: Size of the nadir pixel in km
;
; Output:
;    OffNadirSize: Size of off-nadir pixel in km
;

Re = 6378.0
rLookAngle = d2r(LookAngle)



IFOV = float(NadirSize)/Altitude
Print, "IFOV:", IFOV

SinGamma = sin(rLookAngle)*(Re+Altitude)/Re

Gamma = !pi-asin(SinGamma)  ; Angle between LOS and Earth Radius
print, "GAMMA:", r2d(gamma), " deg"

Beta = !pi - (rLookAngle + Gamma) ; Angle between SatPos and Earth Radius
print, "BETA:", r2d(beta), " deg"

LOS = Re*sin(Beta)/sin(rLookAngle)
print, "LOS:", los
beta=0
OffNadirSize = IFOV*LOS/(cos(rLookAngle+Beta))

LZero = where(LookAngle EQ 0, nLZero)
if nLZero gt 0 then OffNadirSize[LZero]=NadirSize

Return, OffNadirSize
END
