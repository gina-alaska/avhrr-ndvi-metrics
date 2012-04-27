;======================;
; WIDGET EVENT HANDLER ;
;======================;
PRO  MultiScale_EVENT, ev

      WIDGET_CONTROL,ev.id,GET_UVALUE=uvalue
      WIDGET_CONTROL,ev.top,GET_UVALUE=mLocal

      CASE (UValue) OF

         'GENPSF': BEGIN

            Widget_Control, mLocal.wBandToModel, Get_Value=BandToModel
            Widget_Control, mLocal.wLookAngle, Get_Value=LookAngle
            Widget_Control, mLocal.wHiPixSize, Get_Value=HiPixSize
            Widget_Control, mLocal.wLoPixSize, Get_Value=LoPixSize
            Widget_Control, mLocal.wKerSizeX, Get_Value=KerSizeX
            Widget_Control, mLocal.wKerSizeY, Get_Value=KerSizeY
            Widget_Control, mLocal.wShowPSFWin, Get_Value=ShowPSFWin
            Widget_Control, mLocal.wSensor, Get_Value=Sensor

            Widget_Control, mLocal.wPS, Get_Value=PostScript

            BandToModel=BandToModel+1

            CASE (Sensor[0]) OF
              0:BEGIN
                   PSF=GenVegPSF(BandToModel, LookAngle, HiPixSize, LoPixSize, KerSizeX, KerSizeY)
                   SensorName='VEGETATION'
                END
              1:BEGIN
                   PSF=GenAvhrrPSF(BandToModel, LookAngle, HiPixSize, LoPixSize, KerSizeX, KerSizeY)
                   SensorName='AVHRR'
                END
              ELSE:
            ENDCASE

            X=(findgen(KerSizeX)-KerSizeX/2)*HiPixSize
            Y=(findgen(KerSizeY)-KerSizeY/2)*HiPixSize

            CurDev='X'
            Set_Plot, CurDev 

            IF (PostScript) THEN BEGIN
               Set_Plot, 'PS'
               Device, file=SensorName+'b'+strcompress(BandToModel,/Remove_All)+'a'+flt2str(LookAngle,0)+'.ps', $
                XOffset=1, YOffset=10, /Inches, /Landscape, YSize=6
            END

            IF (NOT PostScript) THEN   Window, ShowPSFWin[0], XSize=700, YSIze=700

            !p.font=1
            shade_surf, psf, X, Y, $
               Title=SensorName+' PSF!CBand:'+strcompress(BandToModel)+ $
                ', Scan Angle: '+flt2str(LookAngle,1), $
               CharSize=2, $
               XTitle='Along Scan, (m)', /XStyle, XCharSize=1, XMargin=15, $
               YTitle='Along Track, (m)', /YStyle, YCharSize=1

            IF (PostScript) THEN Device, /Close

Set_Plot, CurDev
;            shade_surf, psf, X, Y, $
;               Title=SensorName+' PSF!CBand:'+strcompress(BandToModel)+ $
;                ', Scan Angle: '+flt2str(LookAngle,1), $
;               CharSize=2, $
;               XTitle='Along Scan, (m)', /XStyle, XCharSize=1, XMargin=15, $
;               YTitle='Along Track, (m)', /YStyle, YCharSize=1


;            Window, ShowPSFWin[0]-1, XSize=700, YSIze=700
;            plot, psf[*, KerSizeY/2-1], /xstyle
;            oplot, psf[KerSizeX/2-1,*]
;            oplot, shift(psf[*,KerSizeY/2-1], 50)
;            oplot, shift(psf[*,KerSizeY/2-1], -50)

            print, total(psf)
         END; GENPSF

         'APPLYPSF': BEGIN

            Widget_Control, mLocal.wBandToModel, Get_Value=BandToModel
            Widget_Control, mLocal.wLookAngle, Get_Value=LookAngle
            Widget_Control, mLocal.wHiPixSize, Get_Value=HiPixSize
            Widget_Control, mLocal.wLoPixSize, Get_Value=LoPixSize
            Widget_Control, mLocal.wKerSizeX, Get_Value=KerSizeX
            Widget_Control, mLocal.wKerSizeY, Get_Value=KerSizeY
            Widget_Control, mLocal.wSensor, Get_Value=Sensor
            BandToModel=BandToModel+1

            CASE (Sensor[0]) OF
              0: BEGIN
                    Altitude=832000.
                    RoundScaleX=1./cos(d2r(LookAngle));RoundStretch(LookAngle, Altitude)
                    RoundScaleY=1.;RoundStretch(LookAngle, Altitude, /Y)

                    PSF=GenVegPSF(BandToModel, LookAngle, HiPixSize, LoPixSize, KerSizeX, KerSizeY)

                 END
              1: BEGIN
                    Altitude=833000.
                    VZ=la2vz(0, Altitude=Altitude)
                    PixelSize, vz, sa0, ss0, st0, ap
                    VZ=la2vz(LookAngle, Altitude=Altitude)
                    PixelSize, vz, sa, ss, st, ap
print,"SCAN ANGLE:",  SA
                    RoundScaleX=ss/ss0  ;  RoundStretch(LookAngle, Altitude)
                    RoundScaleY=1.  ;  RoundStretch(LookAngle, Altitude, /Y)
print, RoundScaleX, RoundScaleY
                    PSF=GenAvhrrPSF(BandToModel, LookAngle, HiPixSize, LoPixSize, KerSizeX, KerSizeY)

                 END

              ELSE:
            ENDCASE

            Widget_Control, mLocal.wHiFile, Get_Value=HiFile
            Widget_Control, mLocal.wUseBand, Get_Value=UseBand
            Widget_Control, mLocal.wSamp, Get_Value=Samp
            Widget_Control, mLocal.wLine, Get_Value=Line
            Widget_Control, mLocal.wDT, Get_Value=DT
            Widget_Control, mLocal.wPixSpaceX, Get_Value=PixSpaceX
            Widget_Control, mLocal.wPixSpaceY, Get_Value=PixSpaceY
            Widget_Control, mLocal.wOutFile, Get_Value=OutFile
            Widget_Control, mLocal.wLoPixSize, Get_Value=LoPixSize
            Widget_Control, mLocal.wShowImgWin, Get_Value=ShowImgWin

            Samp=long(Samp[0])
            line=long(Line[0])
            dt=long(dt[0])+1
            PixSpaceX = Round_To(PixSpaceX[0]/HiPixSize[0] * RoundScaleX, 0.01)
            PixSpaceY = Round_To(PixSpaceY[0]/HiPixSize[0] * RoundScaleY, 0.01)
print, PixSpaceX, PixSpaceY
            LoResImg=ApplyPSF(PSF,HiFile[0], UseBand, Samp, Line, DT, PixSpaceX, PixSpaceY, LoResDDR)

;
; Copy over Remaining ddr info (Can't do straigt copy because LoResDDR has
;  only 1 band)
;
            LoResDDR.ProjDist=[LoPixSize, LoPixSize]
            LoResDDR.Rec1Header = mLocal.HiResDDR.Rec1Header
            LoResDDR.SysType = mLocal.HiResDDR.SysType
            LoResDDR.ProjUnit = mLocal.HiResDDR.ProjUnit
            LoResDDR.Last_Used_Date = mLocal.HiResDDR.Last_Used_Date
            LoResDDR.Last_Used_Time = mLocal.HiResDDR.Last_Used_Time
            LoResDDR.Master_Line = mLocal.HiResDDR.Master_Line
            LoResDDR.Valid = mLocal.HiResDDR.Valid
            LoResDDR.ProjCoef = mLocal.HiResDDR.ProjCoef
            LoResDDR.ProjCode = mLocal.HiResDDR.ProjCode
            LoResDDR.ZoneCode = mLocal.HiResDDR.ZoneCode
            LoResDDR.Ellipsoid = mLocal.HiResDDR.Ellipsoid
            LoResDDR.Rec2Header = mLocal.HiResDDR.Rec2Header
            LoResDDR.UL = mLocal.HiResDDR.UL
            LoResDDR.UR = mLocal.HiResDDR.UR
            LoResDDR.LL = mLocal.HiResDDR.LL
            LoResDDR.LR = mLocal.HiResDDR.LR
            LoResDDR.Increment = mLocal.HiResDDR.Increment

            ShowImg, LoResImg, ShowImgWin[0]
            ImgWrite, LoResImg, OutFile[0]+'.img'
            ImgWrite, LoResDDR, OutFile[0]+'.ddr'
            Write_Tiff, OutFile[0]+'.tif', LoResImg
         END; APPLYPSF

         'QUIT': BEGIN
            WIDGET_CONTROL,/destroy,ev.top
         END; QUIT

         ELSE:

      ENDCASE

      IF (Widget_Info(ev.top, /Valid_ID)) THEN $
           Widget_Control, ev.top, Set_UValue=mLocal

END; MultiScale_EVENT




;===================;
; WIDGET DEFINITION ;
;===================;

;FUNCTION  MultiScale, mParent

PRO MultiScale
!p.font=1
      mFont=FontGen()
      Font=mFont.mono12m
      Font=''
;
; Open Hi Res Image
;
      HiResFile=Dialog_PickFile(title='Choose Hi-Res Source Image',Filter='*.img')
      HiFileRoot=str_sep(HiResFile, '.')
      HiDDRName=HiFileRoot[0]+'.ddr'


;
; Read DDR
;
      if (compare(findfile(HiDDRName) EQ HiDDRName, [1]))  THEN BEGIN
         HiResDDR=Read_LAS_DDR(HiDDRName)
         HiNS = HiResDDR.ns
         HiNL = HiResDDR.nl
         HiNB = HiResDDR.nb
         HiDTflag = HiResDDR.dt-1
         HiPixSize= HiResDDR.ProjDist
      END ELSE BEGIN
         HiResDDR={LASDDR}
         HiNS=1;0
         HiNL=1;0
         HiNB=1;0
         HiDTflag=0
         HiPixSize=10
      END


      wBase=Widget_Base(Title='Multi-Scale', /Column, /Base_Align_Center);, $
;                  Group_Leader=mParent.wBase)

;
;  Input File Size Info
;
      wLabel=Widget_Label(wBase, Value='Hi-Res Image Info',Font=font)
      wHiResBase = Widget_Base(wBase, /Column, /Frame)
      wHiFile= CW_Field(wHiResBase, Title='Input Hi Res File:', Value=HiResFile, Font=font, XSize=40, /String)
      wHiSize = Widget_Base(wHiResBase, Row=1)
      wSamp = CW_Field(wHiSize, Title='Samples:', /Integer, Value=HiNS, XSize=6)
      wLine = CW_Field(wHiSize, Title='Lines:', /Integer, Value=HiNL, XSize=6)
      wBand = CW_Field(wHiSize, Title='Bands:', /Integer, Value=HiNB, XSize=6)
      asText=['Byte', 'Integer','Long','Real']
      wHiPixSize=CW_Field(wHiResBase, Title='Pixel Size, (m):', /Float, Value=HiPixSize[0], Font=font, XSize=6)
      wDT = CW_Select(wHiSize, Value=asText, Title='Data:',Start=HiDTflag)

;
;  Which band to reduce
;
      asText=['Band 1']
      For i = 1, HiNB-1 DO BEGIN
         asText= [asText,'Band'+strcompress(i+1)]
      END
      wUseBand= CW_Select(wHiResBase, Title='Use Band:', Value=asText, Start=0)

;
;  Lo-res output image info
;
      wLabel=Widget_Label(wBase, Value='Lo-Res Image Info',Font=font)
      wLoResBase = Widget_Base(wBase, /Column, /Frame)

      wOutFile=CW_Field(wLoResBase, Title='Output File:',Value='outfile', Font=font)
      asText=['VEGETATION', 'AVHRR']
      wSensor=CW_Select(wLoResBase, Value=asText, Start=0, Title='Sensor:');    ,Font=font)
      asText=['Band 1', 'Band 2', 'Band 3', 'Band 4']
      wBandToModel=CW_Select(wLoResBase, Value=asText, Start=0, Title='Band To Model:');,Font=font)

      wKerSizeX=CW_Field(wLoResBase, Title='X Kernel Size, (pix)', /Integer, Value=128, Font=font, XSize=6)
      wKerSizeY=CW_Field(wLoResBase, Title='Y Kernel Size, (pix)', /Integer, Value=128, Font=font, XSize=6)

      LoPixSize=1000
      wLoPixSize=CW_Field(wLoResBase,  Title='Pixel Size, (m):', /Integer, Value=LoPixSize, Font=font, XSize=6)
      wPixSpaceX=CW_Field(wLoResBase, Title='Pixel Spacing X, (m):', /Integer,Value=LoPixSize, Font=font, XSize=6)
      wPixSpaceY=CW_Field(wLoResBase, Title='Pixel Spacing Y, (m):', /Integer,Value=LoPixSize, Font=font, XSize=6)
      wLookAngle=CW_Field(wLoResBase, Title='Look Angle, (deg)', /Float,Value=0, Font=font, XSize=6)

      wLabel=Widget_Label(wBase, Value='Show Data',Font=font)
      wImgBase=Widget_Base(wBase, /Column, /Frame)
      wShowImgWin=CW_Field(wImgBase, Title='Show Image in Window:', /Integer,Value=0, Font=font,XSize=4)
      wShowPSFWin=CW_Field(wImgBase, Title='Show PSF in Window:', /Integer,Value=1, Font=font,XSize=4)
      wPS = CW_BGroup(wImgBase, 'Generate PostScript', UValue='PS', /nonexclusive)

;
; Controls
;
  wControlBase=Widget_Base(wBase, /Row)
  wGenPSF = Widget_Button(wControlBase, Value='Show PSF', UValue='GENPSF',XSize=150)
  wApplyPSF = Widget_Button(wControlBase, Value='Apply PSF', UValue='APPLYPSF',XSize=150)
  wQuit = Widget_Button(wControlBase, Value='Quit', UValue='QUIT',XSize=150)

;
;
;

;
;  Stash widgets
;
      mLocal= {wBase:wBase, $              ;wBase
         wHiFile:wHiFile, $                ;Hi Res Input Info
         wSamp:wSamp, $
         wLine:wLine, $
         wBand:wBand, $
         wDT:wDT, $
         wHiPixSize:wHiPixSize, $
         wUseBand:wUseBand, $
         wOutFile:wOutFile, $              ;Lo Res Info
         wSensor:wSensor, $
         wBandToModel:wBandToModel, $
         wKerSizeX:wKerSizeX, $
         wKerSizeY:wKerSizeY, $
         wLoPixSize:wLoPixSize, $
         wPixSpaceX:wPixSpaceX, $
         wPixSpaceY:wPixSpaceY, $
         wLookAngle:wLookAngle $
         , wShowImgWin:wShowImgWin $
         , wShowPSFWin:wShowPSFWin $
         , wPS:wPS $
         , wGenPSF:wGenPSF $
         , wApplyPSF:wGenPSF $
         , wQuit:wQuit $
         , HiResDDR:HiResDDR $
        }

;
;  Realize the application window - set the UValue
;
      Widget_Control, wBase, /Realize, Set_UValue=mLocal, /No_Copy


;
;  Set mLocal as UValue for wBase
;
;      Widget_Control, wBase, Set_UValue=mLocal



;
;  Call the XManager
;
      XManager, 'MultiScale', wBase, No_Block=No_Block


END
