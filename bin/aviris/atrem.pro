;
;  NAME:
;     ATREM
;
;  PURPOSE:
;     ATREM provides a GUI for the ATmospheric REMoval code used
;      for processing hyperspectral data from AVIRIS or HYDICE
;
;  CATEGORY:
;     Application
;
;  CALLING SEQUENCE:
;     atrem
;
;  INPUTS:
;
;  KEYWORDS:
;
;  OUTPUTS:
;     Can generates:
;        Atrem input file
;        Atrem output log file
;        Reflectance Image
;        Water Vapor Image
;        Spectral Library
;
;  COMMON BLOCKS:
;     None
;
;  LIMITATIONS:
;
;  EXTERNALS:
;     Runs the External Fortran program, atrem
;

;====================;
; HANDLER DEFINITION ;
;====================;
PRO AtRem_Event, ev

   Widget_Control, ev.id, Get_UValue=UValue
   Widget_Control, ev.top, Get_UValue=mLocal


   CASE (UValue) OF
   'wInNav': BEGIN
      Widget_Control, mLocal.wInNav, Get_Value=InNav
      Print, InNav
   END
;
; WREADIMAGE
;
   'wReadImage': BEGIN
      Widget_Control, mLocal.wInImage, Get_Value=InImage
      tmp=findfile(InImage[0], count=count)
      
      if(count EQ 1) THEN BEGIN
        OpenR, LUN, tmp[0], /Get_LUN
        tmp=FStat(LUN)
        Free_LUN, LUN 
        InSize=tmp.Size

        Widget_Control, mLocal.awFileDim[1], Get_Value=NS
        Widget_Control, mLocal.awFileDim[3], Get_Value=NB
        Widget_Control, mLocal.awFileDim[2], Set_Value=InSize/(Long(NS)*Long(NB)*2)

        filename=str_sep(InImage[0], '/')
        n=n_elements(filename)
        filename=FileName[n-1]
        tmpname=str_sep(filename, '.')
        n=n_elements(tmpname)
        filename=''
        for i=0, n-2 do filename=filename+tmpname[i]+'.'
        filename=filename+'refl.img'


        Widget_Control, mLocal.wOutRefl, Set_Value=filename
       

        Widget_Control, mLocal.wReadNav, Sensitive=1
      END ELSE $
         errmess=Dialog_Message('File Not Found: '+InImage, Dialog_Parent=mLocal.wBase)


   END; wReadImage

;
; WREADNAV 
;
   'wReadNav': BEGIN
      Widget_Control, mLocal.wInNav, Get_Value=InNav
      tmp=findfile(inNav[0], count=count)

      if (count eq 1) then BEGIN 
         spawn, '/sg1/sab1/suarezm/idl/bin/aviris/rmctrl.sed '+tmp[0]
         Nav=ReadNavFile(tmp[0], 512)
         Widget_Control, mLocal.wAltitude, Set_Value=Nav.Altitude
         Widget_Control, mLocal.awDate[0], Set_Value=(Nav.MM[0])
         Widget_Control, mLocal.awDate[1], Set_Value=(Nav.DD[0])
         Widget_Control, mLocal.awDate[2], Set_Value=(Nav.YYYY[0])
         Widget_Control, mLocal.awTime[0], Set_Value=(Nav.Hour[0])
         Widget_Control, mLocal.awTime[1], Set_Value=(Nav.Minute[0])
         Widget_Control, mLocal.awTime[2], Set_Value=(Nav.Second[0])

         For i=0,2 DO BEGIN
            Widget_Control, mLocal.awLat[i], Set_Value=Nav.Latitude[i]
            Widget_Control, mLocal.awLon[i], Set_Value=Nav.Longitude[i]
         END
        
         IF(Nav.LatHem[0] EQ 'N') THEN LatHem=1 ELSE LatHem=0
         IF(Nav.LonHem[0] EQ 'E') THEN LonHem=1 ELSE LonHem=0
         Widget_Control, mLocal.wEW, Set_DropList=LatHem
         Widget_Control, mLocal.wNS, Set_DropList=LonHem

        Widget_Control, mLocal.wReadSpect, Sensitive=1

      END ELSE $
         errmess=Dialog_Message('File Not Found: '+InNav, Dialog_Parent=mLocal.wBase)

   END; Case wReadNav

;
; WREADSPECT
;
   'wReadSpect': BEGIN
      Widget_Control, mLocal.wInSpect, Get_Value=InSpect
      spcname=findfile(inSpect[0], count=scount)
      spcname=spcname[0]
      tmp=str_sep(InSpect[0], '.')
      ntmp=n_elements(tmp)
      wavname=''
      for i=0, ntmp-2 do wavname=wavname+tmp[i]+'.'
      wavname=wavname+'wav'
      wavnameshort=str_sep(wavname, '/')
      wavnameshort=wavnameshort[n_elements(wavnameshort)-1]

      fileroot=strmid(wavname, 0, strlen(wavname)-4)

      if (scount EQ 1) THEN BEGIN
         wavcheck=findfile(wavname, count=wcount)          
         if (wcount EQ 1) THEN BEGIN
            question=Dialog_Message('File Exists: '+wavnameshort+' Recreate?', /Question)
               if (question EQ 'Yes') Then spc2wav,fileroot
         END

        mLocal.wavname=wavname
        Widget_Control, mLocal.wMakeInput, Sensitive=1
          
      END ELSE $
         errmess=Dialog_Message('File Not Found: '+InSpect, Dialog_Parent=mLocal.wBase)

   END; Case wReadWav

;
; RATIO 1
;
   'wRatio1DList': BEGIN
      Ratio1DList=Widget_Info( mLocal.wRatio1DList, /DropList_Select)
      FOR i=0,2 DO BEGIN
         Widget_Control, mLocal.awRatio1Waves[i], Set_Value=mLocal.Ratio1Waves[i, Ratio1DList]
         Widget_Control, mLocal.awRatio1Width[i], Set_Value=mLocal.Ratio1Width[i, Ratio1DList]
      END
   END;wRatio1DList

;
; RATIO 2
;
   'wRatio2DList': BEGIN
      Ratio2DList=Widget_Info( mLocal.wRatio2DList, /DropList_Select)
      FOR i=0,2 DO BEGIN
         Widget_Control, mLocal.awRatio2Waves[i], Set_Value=mLocal.Ratio2Waves[i, Ratio2DList]
         Widget_Control, mLocal.awRatio2Width[i], Set_Value=mLocal.Ratio2Width[i, Ratio2DList]
      END
   END;wRatio2DList

;
; CASE ATMO MODEL
;
   'wAtmModel': BEGIN
      AtmModel=WIdget_Info(mLocal.wAtmModel, /DropList_Select)
      IF (AtmModel EQ 6) THEN $
         Widget_Control, mLocal.wUserAtm, Sensitive=1 $
      ELSE $
         Widget_Control, mLocal.wUserAtm, Sensitive=0
   END
;
; CASE VISIBILITY
; 
   'wVisibility': BEGIN
      Widget_Control, mLocal.wVisibility, Get_Value=Visibility
      If(float(Visibility[0]) EQ 0) THEN $
         Widget_Control, mLocal.wOpticalDepth, Sensitive=1 $
      ELSE $
         Widget_Control, mLocal.wOpticalDepth, Sensitive=0 
  

   END


;
; WMAKEINPUT
;
   'wMakeInput': BEGIN
      GetAtRemParams,mLocal
$more 'atrem.input'

      Widget_Control, mLocal.wRunAtrem, Sensitive=1
   END; wMakeInput

;
; WRUNATREM
;
   'wRunAtRem': BEGIN
      spawn, 'atrem <atrem.input >atrem.log'
    
   END; wRunAtrem

;
; CLOSE
;
   'wClose': BEGIN
      WIDGET_CONTROL, /Destroy, ev.top
   END
   ELSE:
   ENDCASE

   IF (Widget_Info(ev.top, /Valid_ID)) THEN $
        Widget_Control, ev.top, Set_UValue=mLocal


END; AtRem_Event

;====================;
; WIDGET DEFINITION  ;
;====================;
PRO AtRem

mOSInfo=OsInfo()
mFont=FontGen()
FileWidth=50
Font=mFont.Mono18m
BoldFont=mFont.Mono18b

Font=mFont.Mono10m
BoldFont=mFont.Mono10b
BigFont=mFont.Mono18m
;
; Create Top Level Base
;
   wBase=Widget_Base(Title='ATREM Interface', /Base_Align_Center, /Column)


;
;  Create Base for selecting input files
;
   wInFiles=Widget_Base(wBase, /Frame, Row=3)

   wInFiles1=Widget_Base(wInFiles, /Row)
   wInImage=CW_File(wInFiles1, FileLabel='Input Image     :', FieldWidth=FileWidth, $
            /Row, Filter='*.img', Font=Font)
   wReadImage=Widget_Button(wInFiles1, Value=' Check In ', Font=Font, UValue='wReadImage')

   wInFiles2=Widget_Base(wInFiles, /Row)
   wInNav=CW_File(wInFiles2, FileLabel='Input Navigation:', FieldWidth=FileWidth, $
            /Row, Filter='*.nav', Font=Font, UValue='wInNav')
   wReadNav=Widget_Button(wInFiles2, Value=' Read Nav ', Font=Font, UValue='wReadNav')
   Widget_Control, wReadNav, Sensitive=0

   wInFiles3=Widget_Base(wInFiles, /Row)
   wInSpect=CW_File(wInFiles3, FileLabel='Input Spectra   :', FieldWidth=FileWidth, $
            /Row, Filter='*.spc', Font=Font)
   wReadSpect=Widget_Button(wInFiles3, Value='spc -> wav', Font=Font, UValue='wReadSpect')
   Widget_Control, wReadSpect, Sensitive=0


;
;  Create Base for Navigation Data
;
   wLabel=Widget_Label(wBase,Value='Navigation Parameters', Font=BoldFont)
   wNavBase=Widget_Base(wBase,/Frame, /Column)
   wAltBase=Widget_Base(wNavBase, /Row)
   wAltLabel=Widget_Label(wAltBase, Value='Altitude :', Font=Font)
   wAltitude=CW_Field(wAltBase, Title=' ', /Float, XSize=7, Font=Font, FieldFont=Font) 
   wLabel=Widget_Label(wAltBase, Value='km', Font=Font)

;
; Date
;
   wDateBase=Widget_Base(wNavBase, /Row)
   wDateLabel=Widget_Label(wDateBase, Value='Date     :', Font=Font)
   asText=['MM', 'DD', 'YYYY']
   xSize=[2,2,4]
   awDate=LonArr(N_Elements(asText))
   For i=0, N_Elements(asText)-1 DO BEGIN
      awDate[i]=CW_Field(wDateBase, Title=' ' , XSize=XSize[i], Font=Font,FieldFont=Font)
      awLabel=Widget_Label(wDateBase, Value=asText[i],Font=Font)
   END

;
; Time
;
   wTimeBase=Widget_Base(wNavBase, /Row)
   wTimeLabel=Widget_Label(wTimeBase, Value='Time     :', Font=Font)
   asText=['hh', 'mm', 'ss']
   xSize=[2,2,2]
   awTime=LonArr(N_Elements(asText))
   For i=0, N_Elements(asText)-1 DO BEGIN
      awTime[i]=CW_Field(wTimeBase, Title=' ', XSize=XSize[i], Font=Font,FieldFont=Font)
      awLabel=Widget_Label(wTimeBase, Value=asText[i],Font=Font)
   END

;
; Latitude
;
   wLatBase=Widget_Base(wNavBase, /Row)
   wLatLabel=Widget_Label(wLatBase, Value='Latitude :', Font=Font)
   asText=['Deg', 'Min', 'Sec']
   xSize=[4,2,2]
   awLat=LonArr(N_Elements(asText))
   For i=0, N_Elements(asText)-1 DO BEGIN
      awLat[i]=CW_Field(wLatBase, Title=' ' , XSize=XSize[i], Font=Font,FieldFont=Font)
      awLabel=Widget_Label(wLatBase, Value=asText[i],Font=Font)
   END
   asText=['N','S']
   wNS=Widget_Droplist(wLatBase,Value=asText, Font=Font, UValue='wNS')
   Widget_Control, wNS, Set_Droplist=0

;
; Longitude
;
   wLonBase=Widget_Base(wNavBase, /Row)
   wLonLabel=Widget_Label(wLonBase, Value='Longitude:', Font=Font)
   asText=['Deg', 'Min', 'Sec']
   xSize=[4,2,2]
   awLon=LonArr(N_Elements(asText))
   For i=0, N_Elements(asText)-1 DO BEGIN
      awLon[i]=CW_Field(wLonBase, Title=' ', XSize=XSize[i], Font=Font,FieldFont=Font)
      awLabel=Widget_Label(wLonBase, Value=asText[i],Font=Font)
   END
   asText=['E','W']
   wEW=Widget_DropList(wLonBase,Value=asText, Font=Font,UValue='wEW')
   Widget_Control, wEW, Set_Droplist=0

   

;
; Wavelength File
;
;   wWaveBase=Widget_Base(wBase, /Row)
;   wWaveCheck=

;
; Channel Ratio Parameters
;

   wLabel=Widget_Label(wBase, Value='Channel Ratio Parameters', Font=BoldFont)
   wRatioBase=Widget_Base(wBase,Row=2, /Frame)

   @atrem_defaults

   awRatio1Waves=lonarr(3)
   awRatio1Width=lonarr(3)
   awRatio2Waves=lonarr(3)
   awRatio2Width=lonarr(3)
   asText=['Vegetation', 'Snow', 'Rock, Soil & Mineral']

   For i=0, 2 DO BEGIN
      awRatio1Waves[i]=CW_Field(wRatioBase, Title=' ', XSize=6, $
                      Value=Ratio1Waves[i,0], Font=Font,FieldFont=Font)
      awRatio1Width[i]=CW_Field(wRatioBase, Title=' ', XSize=2, $
                      Value=Ratio1Width[i,0], Font=Font,FieldFont=Font)
   END
   wRatio1DList=Widget_DropList(wRatioBase, Value=asText, Font=Font, UValue='wRatio1DList')

       
   For i=0, 2 DO BEGIN
      awRatio2Waves[i]=CW_Field(wRatioBase, Title=' ', XSize=6, $
                      Value=Ratio2Waves[i,0], Font=Font,FieldFont=Font)
      awRatio2Width[i]=CW_Field(wRatioBase, Title=' ', XSize=2, $
                      Value=Ratio2Width[i,0], Font=Font,FieldFont=Font)
   END
   wRatio2DList=Widget_DropList(wRatioBase, Value=asText, Font=Font, UValue='wRatio2DList')


;
; Atmospheric Parameters
;
   wLabel=Widget_Label(wBase, Value='Atmospheric Parameters', Font=BoldFont)
; Atm Param Line 1
   wAtmBase=Widget_Base(wBase, Row=4,/Frame)
   wAtmModel=Widget_DropList(wAtmBase, Value=sAtmModel, Font=Font, UValue='wAtmModel')
   Widget_Control, wAtmModel, Set_Droplist=AtmModel_Def
   wUserAtm=CW_Field(wAtmBase, Title='  Atmosphere File:', Font=Font, FieldFont=Font)
   Widget_Control, wUserAtm, Sensitive=0


; Atm Param Line 2
   wAtmBase2=Widget_Base(wAtmBase, /Row)
   wAerosol=Widget_DropList(wAtmBase2, Value=sAeroModel, Font=Font, UValue='wAerosol')
   Widget_Control, wAerosol, Set_DropList=AeroModel_Def

   wElevation=CW_Field(wAtmBase2, Title='   Surface Elevation:', XSize=6,  $
                      /Floating, Font=Font, FieldFont=Font)
   wLabel=Widget_Label(wAtmBase2, Value='km', Font=Font)
   Widget_Control, wElevation, Set_Value=Elevation_Def


; Atm Param Line 3
   wAtmBase3=Widget_Base(wAtmBase, /Row)
   wOzone=CW_Field(wAtmBase3, Title='Ozone:', Value=Ozone_Def, /Floating, $
                      Font=Font, XSize=5, FieldFont=Font, UValue='wOzone')
   wLabel=Widget_Label(wAtmBase3, Value='atm-cm', Font=Font)
 
   wVisibility=CW_Field(wAtmBase3, Title='  Visibility:', Value=Visibility,/Floating,  $
                      Font=Font, XSize=5, FieldFont=Font, UValue='wVisibility', /Return_Events)
   wLabel=Widget_Label(wAtmBase3, Value='km', Font=Font)
   Widget_Control, wVisibility, Set_Value=Visibility_Def

   wOpticalDepth=CW_Field(wAtmBase3, Title='   Optical Depth:', XSize=6,  $
                      /Floating, Font=Font, FieldFont=Font)
   If Visibility_Def eq 0 then ODSense=1 else ODSense=0
   Widget_Control, wOpticalDepth, Sensitive=ODSense
 

; Atm Param Line 4
   wAtmBase4=Widget_Base(wAtmBase, /Row)
   wLabel=Widget_Label(wAtmBase4, Value='Gas Selector:',Font=Font)
   wGases=CW_BGroup(wAtmBase4, sGases, Set_Value=[1,1,1,1,1,1], /Row, $
                      /NonExclusive, Font=Font, UValue='wGases')

   

;
; File parameters
;
   wFileBase=Widget_Base(wBase, Row=4, /Frame)
   
; File Param Line 1
;   wFileBase1=Widget_Base(wFileBase, /Row)
;   wHeadCheck=CW_BGroup(wFileBase1,'Info in Image Header', /NonExclusive, $
;                            Set_Value=[0],font=font)

; File Param Line 2
   wFileBase2=Widget_Base(wFileBase, /Row)
   awFileDim=LonArr(4)
   asText=['Header:', 'NS:', 'NL:', 'NB:']
   For i=0, 3 DO BEGIN
      awFileDim[i]=CW_Field(wFileBase2, Title=asText[i], Value=FileDim_Def[i],  $
                      XSize=5, Font=Font, FieldFont=Font)
   END
   asText=['BSQ','BIP','BIL']
   wStorage=Widget_DropList(wFileBase2, Value=asText, Font=Font)
   Widget_Control, wStorage, Set_Droplist=Storage_Def

; File Param Line 3
   wFileBase3=Widget_Base(wFileBase, /Row)
   wSpecRes=CW_Field(wFileBase3, Title='Output Spectral Resolution:', XSize=5, $
                  /Floating, Font=Font, FieldFont=Font, Value=0)
   wLabel=Widget_Label(wFileBase3, Value='nm OR 0 for same as input', Font=Font)
   
; File Param Line 4
   wFileBase4=Widget_Base(wFileBase, /Row)
   wScaleFactor=CW_Field(wFileBase4, Title='Scale Factor for Output Reflectance:', $
                 Value=ScaleFactor, /Floating, Font=Font, FieldFont=Font, XSize=6)

;
; Output Files
;
   wOutBase=Widget_Base(wBase, Row=4, /Frame)

   wOutRefl=CW_File(wOutBase, FileLabel='Output Relfectance Image:', FieldWidth=Filewidth, $
                    /Row, Font=Font)
   wOutVap=CW_File(wOutBase, FileLabel='Output Water Vapor Image:', FieldWidth=Filewidth, $
                    FieldLabel='vapor.img',/Row, Font=Font)
   wOutLib=CW_File(wOutBase, FileLabel='Output Spectral Library :', FieldWidth=Filewidth, $
                    FieldLabel='spect.lib',/Row, Font=Font)


;
; Operations
;
   wApplyBase=Widget_Base(wBase, Row=1)
   wMakeInput=Widget_Button(wApplyBase, Value=' Make ATREM Input ', Font=BigFont, UValue='wMakeInput')
   wRunAtrem=Widget_Button(wApplyBase, Value=' Run ATREM ', Font=BigFont, UValue='wRunAtrem')
   wClose=Widget_Button(wApplyBase, Value='Close', Font=BigFont, UValue='wClose')

   Widget_Control, wMakeInput, Sensitive=0
   Widget_Control, wRunAtrem, Sensitive=0

   mLocal={ wBase:wBase $
          , wInImage:wInImage $
          , wInSpect:wInSpect $
          , wInNav:wInNav $
          , wReadNav: wReadNav $
          , wAltitude:wAltitude $
          , awDate: awDate $
          , awTime: awTime $
          , awLat: awLat, wNS: wNS $
          , awLon: awLon, wEW: wEW $
          , awRatio1Waves:awRatio1Waves $
          , awRatio1Width:awRatio1Width $
          , wRatio1DList:wRatio1DList $
          , awRatio2Waves:awRatio2Waves $
          , awRatio2Width:awRatio2Width $
          , wRatio2DList:wRatio2DList $
          , wAtmModel: wAtmModel $
          , wUserAtm: wUserAtm $
          , wAerosol: wAerosol $
          , wElevation: wElevation $
          , wOzone: wOzone $
          , wVisibility: wVisibility $
          , wOpticalDepth: wOpticalDepth $
          , wGases:wGases $
;          , wHeadCheck: wHeadCheck $
          , awFileDim: awFileDim $
          , wStorage: wStorage $
          , wSpecRes: wSpecRes $
          , wScaleFactor:wScaleFactor $
          , wOutRefl: wOutRefl $
          , wOutVap: wOutVap $
          , wOutLib: wOutLib $ 
          , wReadSpect: wReadSpect $
          , wMakeInput: wMakeInput $
          , wRunAtrem: wRunAtrem $
          , wClose: wClose $
          , Ratio1Waves:Ratio1Waves $
          , Ratio1Width:Ratio1Width $
          , Ratio2Waves:Ratio2Waves $
          , Ratio2Width:Ratio2Width $
          , WavName:''$
          }

;
; Realize and start event handler
;
   Widget_Control, wBase, /Realize
   Widget_Control, wBase, Set_UValue=mLocal, Event_Pro='AtRem_Event'
   XManager, 'AtRem', wBase, Event_Handler='atrem_event', /No_Block

END
