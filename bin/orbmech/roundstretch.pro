FUNCTION  RoundStretch, LookAngle, Altitude, X=X, Y=Y

;
; This function returns the ratio of a round earth off-nadir
; pixel size to its flat earth equivalent
;
; Input:
;    LookAngle: Satellite view angle in degrees
;    Altitude : Satellite altitude in m
;
; Output:
;    RoundStretch: Ratio of round to flat earth off-nadir pixelsize
;

Re = 6378000.0
rLookAngle = d2r(LookAngle)
NadirSize=1.0


IFOV = float(NadirSize)/Altitude

SinGamma = sin(rLookAngle)*(Re+Altitude)/Re

Gamma = (!pi-asin(SinGamma)) 

Beta = (!pi - (rLookAngle + Gamma)) 

LOSCurve = Re*sin(Beta)/sin(rLookAngle)
LOSFlat = Altitude/cos(rLookAngle)

;print, "LOSCurve:", LOSCurve
;print, "LOSFlat:", LOSFlat
;print, "Beta:", r2d(Beta)
;print, r2d(Beta+Gamma)+LookAngle

RoundStretch = (LOSCurve*IFOV/Cos(rLookAngle+Beta))/(LOSFlat*IFOV/cos(rLookAngle))
IF(KEYWORD_SET(Y)) THEN RoundStretch=LOSCurve/LOSFlat

LZero = where(LookAngle EQ 0, nLZero)
if nLZero gt 0 then RoundStretch[LZero] = 1.0

Return, (RoundStretch)
END
