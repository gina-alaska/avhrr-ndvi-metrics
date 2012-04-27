PRO SMHDR__Define

  SMHDR = {SMHDR $
;
; File Information
;
	, file:''		$ ; File Name
	, NS: -1L		$ ; Number of Samples
	, NL: -1L		$ ; Number of Lines
	, NB: -1L		$ ; Number of Bands
	, DT: -1L		$ ; Data Type
;
; Projection Information	  ; LAS Projection Information
;
	, ProjCode: -1L		$ ; LAS Projection Code
	, ZoneCode: -1L		$ ; LAS Zone Code
	, Ellipsoid: -1L	$ ; LAS Ellipsoid Code
	, ProjCoef: dblarr(15)	$ ; LAS Projection Coefficients
	, UL: dblarr(2)		$ ; Upper Left Corner in Packed DMS
	, LL: dblarr(2)		$ ; Lower Left Corner in Packed DMS
	, UR: dblarr(2)		$ ; Upper Right Corner in Packed DMS
	, LR: dblarr(2)		$ ; Lower Right Corner in Packed DMS
	, ProjDist: dblarr(2)	$
	, ProjIncr: dblarr(2)	$
;
; Data Information
;
	, Label: ''		$ ; Data Label (NDVI, SOST, etc.)
	, UnScale: dblarr(2)	$ ; [Intercept, Slope]
	, Min: -1		$ ; Minimum Value of Data Type
	, Max: -1		$ ; Maximum Value of Data Type
;
; Compositing Information
;
	, BPY: -1L		$ ; Bands Per Year
	, DPP: -1L		$ ; Days Per Band
	, DATE: lonarr(3)	$ ; Start Day, Month, Year
	}

END
