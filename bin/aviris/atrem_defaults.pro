;
; Channel Ratio Parameters
; Waves in um, Width in #pts
;
   Ratio1Waves=[[0.865, 1.030, 0.935],$   ;Vegetation 
                [0.865, 1.040, 0.945],$   ;Snow
                [0.865, 1.030, 0.940]]    ;Rock, Soil & Mineral

   Ratio1Width=[[3, 3, 5],$             
                [3, 3, 7],$
                [3, 3, 7]]

   Ratio2Waves=[[1.050, 1.230, 1.130],$   ;Vegetation
                [1.065, 1.250, 1.140],$   ;Snow
                [1.050, 1.235, 1.1375]]   ;Rock, Soil & Mineral

   Ratio2Width=[[3, 3, 5],$
                [3, 3, 7],$
                [3, 3, 7]]


;
; Atmosphere Model
;
   sAtmModel=['Tropical', 'Mid Latitude Summer', 'Mid Latitude Winter',$
            'Sub Arctic Summer', 'Sub Arctic Winter', 'US Standard 1962',$
            'User Defined Model...']
   AtmModel_Def=1

;
; Aerosol Models
;
   sAeroModel=['No Aerosol', 'Continental Aerosol', 'Maritime Aerosol', $
               'Urban Aerosol']
   AeroModel_Def=1

;
; Default Ozone
;
   Ozone_Def=0.34
;
; Default Visibility (in km OR 0 if Optical Depth is to be used)
;
   Visibility_Def=50

;
; Default Elevation (in km)
;
   Elevation_Def=0

;
; Gases
;
  sGases=['H2O ', 'CO2 ', 'O3 ', 'NO ', 'CH4 ', 'O2 ']


;
; File Dimension Defaults: [NH, NS, NL, NB]
; Storage Defaults: 0-BSQ, 1-BIP, 2-BIL
;
  FileDim_Def=[0, 614, 512, 224]
  Storage_Def=1



  ScaleFactor=1000.
