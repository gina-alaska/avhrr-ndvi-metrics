; NAME: metrics_scaling.h
;
; PURPOSE:
;
; This file contains the Scaling and Unscaling Coefficients
; for converting Floating point metrics to 2-byte integers
; (scaling) and 2-byte integers to floating point metrics
; (unscaling).  So long as it is in your IDL path, it can be
; sourced into any code by:
;
; @metrics_scaling.h
;
; All scalings are given by coefficients of a first order
; polynomial:
;
;    Output = Coeff[0] + Input*Coeff[1]
;
; These can be applied with the IDL function POLY(Input, Coeff[]).
; It is recommended that when scaling the metrics, the scaled
; floating point values should be rounded before conversion to
; integer
;
;
; If for any reason, the scalings in this file should be
; changed, please be so courteous as to comment out the
; old line and tag it with a date, and move it to the
; bottom of this file.
;
; HISTORY:
;	MSuarez		2-18-1999	Created 
;

;
; NDVI Variables will be scaled from [-1,1]-->[-1000,1000]
; (SOSN, EOSN, NowN, RangeN)
;
NDVI_Sc=[0.,1000.]
NDVI_Un=[0.,.001]

;
; Integrated NDVI will be scaled by a factor of 100
; (Total NDVI or NDVI to Date)
;
IntND_Sc=[0.,100.]
IntND_Un=[0.,0.01]

;
; Time variables in floating point will be in fractional
; years, in integer it will be days
; (SOST, EOST, NowT, RangeT)
;
Time_Sc=[0.,365.]
Time_Un=[0.,1./365]

;
; Slope variables (which have already been scaled by 100)
; will be scaled by 1000
; (Slope Up, Slope Down)
;
Slope_Sc=[0.,1000.]
Slope_Un=[0.,0.001]
