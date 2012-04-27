PRO spotrad2ref, RadFile, RefFile, SZA=SZA, HRV=HRV, JD=JD
;
; This function converts spot radiance to reflectance for
; bands XS=1, 2 and 3.
;
; INPUTS:
;    RadFile=Name of input Radiance Spot Image
;    RefFile=Name of output Reflectance SpotImage
;
; KEYWORDS:
;    SZA=Solar Zenith Angle
;    HRV=Spot acquisition mode (1 or 2), default is 1
;    JD =Julian Day year, default is Jan 1
;

   IF(NOT KEYWORD_SET(SZA)) THEN SZA = 0. ELSE SZA=SZA
   IF(NOT KEYWORD_SET(HRV)) THEN HRV = 1 ELSE HRV=HRV
   IF(NOT KEYWORD_SET(JD))  THEN JD = 0 ELSE JD=JD

OpenR, In_LUN, RadFile, /Get_LUN
In_Base=str_sep(RadFile, '.')
nIn_Base=N_Elements(In_Base)
ddr=Read_LAS_DDR(In_Base[0]+'.ddr')
Radiance=Assoc(In_LUN, bytarr(ddr.ns, ddr.nl))


OpenW, Out_LUN, RefFile, /Get_LUN
Reflectance=Assoc(Out_LUN, bytarr(ddr.ns, ddr.nl))
Out_Base=str_sep(RefFile, '.')
nOut_Base=N_Elements(Out_Base)
Spawn, 'cp '+In_Base[0]+'.ddr '+Out_Base[0]+'.ddr'



;
;Exo-Atmosphere Solar Irradiance (W/m^2/um) E[XS, HRV]
;
   E=[[1854., 1580., 1065.], [1855., 1597., 1067.]]

;
; Distance from the earth to the sun in AU for given JD
;
   D=SunEarthDist(JD)

;
; Inverse Gain
; 
   Inverse_Gain=[[0.98242, 0.95000, 1.09938], $
                 [0.93362, 0.92122, 1.09801] ]


   FOR I = 0, 2 DO BEGIN
      print, 'PROCESSING BAND: ',strcompress(i+1, /Remove_All)
      Reflectance[i] = SpotRef2B((Radiance[i]/Inverse_Gain[i,HRV-1]) $
                            * !pi * D^2/(E[i, HRV-1]*cos(d2r(SZA))))
   END

Free_LUN, In_LUN
Free_LUN, Out_LUN

END

