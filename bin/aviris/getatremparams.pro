;
; This function gets all the AtRem parameters from the AtRem Interface
; widget and puts them in a structure 
;
PRO  GetATREMParams, mLocal


;
; Get input file names
;
   Widget_Control, mLocal.wInImage, Get_Value=InImage
   InWav=mLocal.WavName

   Widget_Control, mLocal.wAltitude, Get_Value=Altitude

   Widget_Control, mLocal.awDate[0], Get_Value=MM
   Widget_Control, mLocal.awDate[1], Get_Value=DD
   Widget_Control, mLocal.awDate[2], Get_Value=YYYY

   Widget_Control, mLocal.awTime[0], Get_Value=Hour
   Widget_Control, mLocal.awTime[1], Get_Value=Minute
   Widget_Control, mLocal.awTime[2], Get_Value=Second

   Widget_Control, mLocal.awLat[0], Get_Value=LatDeg
   Widget_Control, mLocal.awLat[1], Get_Value=LatMinute
   Widget_Control, mLocal.awLat[2], Get_Value=LatSecond
LatHem=Widget_Info(mLocal.wNS, /DropList_Select)
;   Widget_Control, mLocal.wNS, Get_Value=LatHem


   Widget_Control, mLocal.awLon[0], Get_Value=LonDeg
   Widget_Control, mLocal.awLon[1], Get_Value=LonMinute
   Widget_Control, mLocal.awLon[2], Get_Value=LonSecond
LonHem=Widget_Info(mLocal.wEW, /DropList_Select)
;   Widget_Control, mLocal.wEW, Get_Value=LonHem

   Ratio1Waves=fltarr(3)
   Ratio1Width=lonarr(3)
   Ratio2Waves=fltarr(3)
   Ratio2Width=lonarr(3)
   For i=0,2 DO BEGIN
      Widget_Control, mLocal.awRatio1Waves[i], Get_Value=vRatio1Waves
      Widget_Control, mLocal.awRatio1Width[i], Get_Value=vRatio1Width
      Widget_Control, mLocal.awRatio2Waves[i], Get_Value=vRatio2Waves
      Widget_Control, mLocal.awRatio2Width[i], Get_Value=vRatio2Width
Ratio1Waves[i]=vRatio1Waves
Ratio1Width[i]=vRatio1Width
Ratio2Waves[i]=vRatio2Waves
Ratio2Width[i]=vRatio2Width
   END

   AtmModel=Widget_Info(mLocal.wAtmModel, /DropList_Select)
   Widget_Control, mLocal.wUserAtm, Get_Value=UserAtm

   Aerosol=Widget_Info(mLocal.wAerosol, /DropList_Select)
;   Widget_Control, mLocal.wAerosol, Get_Value=Aerosol

   Widget_Control, mLocal.wOzone, Get_Value=Ozone
   Widget_Control, mLocal.wVisibility, Get_Value=Visibility
   Widget_Control, mLocal.wElevation, Get_Value=Elevation
   Widget_Control, mLocal.wOpticalDepth, Get_Value=OpticalDepth

   Widget_Control, mLocal.wGases, Get_Value=Gases

   Widget_Control, mLocal.awFileDim[0], Get_Value=NH
   Widget_Control, mLocal.awFileDim[1], Get_Value=NS
   Widget_Control, mLocal.awFileDim[2], Get_Value=NL
   Widget_Control, mLocal.awFileDim[3], Get_Value=NB
   Storage=Widget_Info(mLocal.wStorage, /DropList_Select)

   Widget_Control, mLocal.wSpecRes, Get_Value=SpecRes
   Widget_Control, mLocal.wScaleFactor, Get_Value=ScaleFactor

   Widget_Control, mLocal.wOutRefl, Get_Value=OutRefl
   Widget_Control, mLocal.wOutVap, Get_Value=OutVap
   Widget_Control, mLocal.wOutLib, Get_Value=OutLib
   

;
; MAKE ATREM INPUT FILE
;
AtRemFile='atrem.input'

   OpenW, LUN, AtRemFile, /Get_LUN


   PrintF, LUN, 'AVIRIS'
   PrintF, LUN, strtrim(Altitude,2)
   PrintF, LUN, MM+' '+DD+' '+ YYYY+' '+ Hour+' '+ Minute+' '+ Second
   PrintF, LUN, LatDeg+' '+ LatMinute+' '+ LatSecond 
   IF (LatHem EQ 0) THEN PrintF, LUN, 'N' ELSE PrintF, LUN, 'S'
   PrintF, LUN, LonDeg+' '+ LonMinute+' '+ LonSecond 
   IF (LonHem EQ 0) THEN PrintF, LUN, 'E' ELSE PrintF, LUN, 'W'
   PrintF, LUN, '0.'
   PrintF, LUN, InWav
   PrintF, LUN, strtrim(1, 2)
   PrintF, LUN, strtrim(Ratio1Waves[0],2)+' '+ strtrim(Ratio1Width[0],2)+' '+ $
                strtrim(Ratio1Waves[1],2)+' '+ strtrim(Ratio1Width[1],2)+' '+ $
                strtrim(Ratio1Waves[2],2)+' '+ strtrim(Ratio1Width[2],2) 
   PrintF, LUN, strtrim(Ratio2Waves[0],2)+' '+ strtrim(Ratio2Width[0],2)+' '+ $
                strtrim(Ratio2Waves[1],2)+' '+ strtrim(Ratio2Width[1],2)+' '+ $
                strtrim(Ratio2Waves[2],2)+' '+ strtrim(Ratio2Width[2],2) 
   PrintF, LUN, strtrim(AtmModel+1,2)
   IF (AtmModel EQ 6) THEN PrintF, LUN, UserAtm
   PrintF, LUN, strtrim(Gases,2)
   PrintF, LUN, strtrim(Ozone ,2)
   PrintF, LUN, strtrim(Aerosol+1,2)+' '+strtrim(Visibility,2)
   If (Visibility EQ 0) THEN $
      PrintF, LUN, strtrim(OpticalDepth,2)
   PrintF, LUN, strtrim(Elevation,2)
   PrintF, LUN, InImage[0]
   PrintF, LUN, strtrim(1,2)
   PrintF, LUN, strtrim(NH,2)+' '+ strtrim(NS,2)+' '+ strtrim(NL,2)+' '+ $
                strtrim(NB,2)+' '+ strtrim(Storage,2)
   PrintF, LUN, OutRefl
   PrintF, LUN, strtrim(SpecRes,2)
   PrintF, LUN, strtrim(ScaleFactor,2)
   PrintF, LUN, OutVap
   PrintF, LUN, OutLib

   Free_LUN, LUN
END
