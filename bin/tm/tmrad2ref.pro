PRO tmrad2ref, RadFile, RefFile, CalFile, SZA=SZA, JD=JD
;
; This function converts spot radiance to reflectance for
; bands XS=1, 2 and 3.
;
; INPUTS:
;    RadFile=Name of input Radiance Spot Image
;    RefFile=Name of output Reflectance SpotImage
;    CalFile=Name of file containing Gain/Bias Info in 
;               mW/cm^2-sr and BandWidth in um.  Order 
;               is [Gain, Bias, BandWidth].
; KEYWORDS:
;    SZA=Solar Zenith Angle
;    HRV=Spot acquisition mode (1 or 2), default is 1
;    JD =Julian Day year, default is Jan 1
;

   IF(NOT KEYWORD_SET(SZA)) THEN SZA = 0. ELSE SZA=SZA
   IF(NOT KEYWORD_SET(JD))  THEN JD = 0 ELSE JD=JD


;
; Read LAS ddr
;
   In_Base=str_sep(RadFile, '.')
   nIn_Base=N_Elements(In_Base)
   ddr=Read_LAS_DDR(In_Base[0]+'.ddr')

;
; Open and Read Calibration File
;
   OpenR, Cal_LUN, CalFile, /Get_LUN
   CalParm=fltarr(3,ddr.nb)
   ReadF, Cal_LUN, CalParm
   Free_LUN, Cal_LUN

   Lmax = CalParm(0,*)/Calparm(2,*)
   Lmin = CalParm(1,*)/Calparm(2,*)


;
; Open Radiance file and associate variable
;
;   OpenR, In_LUN, RadFile, /Get_LUN
;   Radiance
;   Radiance=Assoc(In_LUN, bytarr(ddr.ns, ddr.nl))


;
; Open output Reflectance file and associate variable
;
   OpenW, Out_LUN, RefFile, /Get_LUN
;   Reflectance=Assoc(Out_LUN, bytarr(ddr.ns, ddr.nl))
   Free_LUN, Out_LUN

   Out_Base=str_sep(RefFile, '.')
   nOut_Base=N_Elements(Out_Base)

;
; Create DDR by simply copying input DDR
;
   Spawn, 'cp '+In_Base[0]+'.ddr '+Out_Base[0]+'.ddr'



;
;Exo-Atmosphere Solar Irradiance (W/m^2/um) Esun[Band]
;
   Esun=[195.7, 182.9, 155.7,104.7, 21.93, 0.0, 7.452]

;
; Distance from the earth to the sun in AU for given JD
;
   D=SunEarthDist(JD)

;
; Planck Constants L-5
;
   K1 = 60.776 
   K2 = 1260.56


   FOR I = 0, ddr.nb-1 DO BEGIN
      print, 'PROCESSING BAND: ',strcompress(i+1, /Remove_All)
FOR J = 0, ddr.nl-1 DO BEGIN
      Radiance=LineRead(RadFile, j, i, ddr.ns, ddr.nl, dt=1)

         L = Lmin[i] + (Lmax[i]-Lmin[i])/255. * Radiance

      IF (i ne 5) THEN BEGIN
         zero=where(L LE 0, nzero)
         notzero = where(L GT 0, nnotzero)
         Reflectance=bytarr(ddr.ns)

         IF (NNotZero GT 0) THEN $
            Reflectance = SpotRef2B(L*!pi*D^2 /(Esun[i]*cos(d2r(SZA))))
         IF (NZero GT 0) THEN $ 
            Reflectance[Zero] = 0

      END ELSE BEGIN

         zero=where(L LE 0, nzero)
         notzero = where(L GT 0, nnotzero)
         Reflectance=bytarr(ddr.ns)

         IF (NNotZero GT 0) THEN $
            Reflectance[NotZero] = K2B(K2/alog(K1/L[NotZero] + 1.))
         IF (NZero GT 0) THEN $
            Reflectance[Zero] = 0

      END 

      OpenW, Out_LUN, RefFile,/Append
      WriteU,Out_LUN, Reflectance
      Free_LUN, Out_LUN
END
   END

   ;Free_LUN, In_LUN
   ;Free_LUN, Out_LUN

END

