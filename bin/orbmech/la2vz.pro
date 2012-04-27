FUNCTION la2vz, LookAngle, ALTITUDE=Altitude, RE=Re
;
; This function converts satellite look angle to viewer zenith
; angle.  
;
; INPUT:
;   LookAngle: Satellite look-angle in degrees
; 
; OUTPUT:
;   ViewerZenith: Viewer zenith angle in degrees
;
; KEYWORDS:
;   Altitude: Spacecraft altitude in m.  Default=800000.
;   Re: Earth (or planet) Radius.  Default=6378000. 
;

IF(N_ELEMENTS(ALTITUDE) EQ 0) THEN Altitude=800000.
IF(N_ELEMENTS(RE) EQ 0) THEN Re = 6378000.

SinVZ = float(Re+Altitude)/Re * sin(d2r(LookAngle))
VZ = r2d(asin(SinVZ))

ViewerZenith= VZ < (180-VZ)

Return, ViewerZenith
END
