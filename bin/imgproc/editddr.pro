PRO EditDDR_event, ev

    WIDGET_CONTROL,ev.id,GET_UVALUE=uvalue
    WIDGET_CONTROL,ev.top,GET_UVALUE=mLocal

    CASE (UValue) OF
    'DT': mLocal.ddr.dt = ev.index +1

    'Save': BEGIN
;
; File Name
;
       Widget_Control, mLocal.wFileName, Get_Value=FileName
       FileName=string(FileName[0])

;
; Data File Information
;
       Widget_Control, mLocal.wNB, Get_Value=nb
       nbold=mLocal.ddr.nb                       ; Store original number of bands
       mLocal.ddr.nb=nb

       IF (nbold NE mlocal.ddr.nb) THEN BEGIN
           NewDDR=Update_DDR_Size(mlocal.ddr[0], nbold)           
       END ELSE NewDDR=mLocal.ddr

       Widget_Control, mLocal.wNL, Get_Value=nl
       Widget_Control, mLocal.wNS, Get_Value=ns
       Widget_Control, mLocal.wDT, Get_Value=dt


       NewDDR.nl=nl
       NewDDR.ns=ns
       NewDDR.nb=nb
       NewDDR.dt=dt+1



;
; Modification history
;
       Widget_Control, mLocal.wLastDate, Get_Value=Last_Used_Date
       Widget_Control, mLocal.wLastTime, Get_Value=Last_Used_Time
       Widget_Control, mLocal.wSysType, Get_Value=SysType

       NewDDR.Last_Used_Date=byte(Last_Used_Date)
       NewDDR.Last_Used_Time=byte(Last_Used_Time)
       NewDDR.SysType=byte(SysType)

;
; Projection Code
;
       Widget_Control, mLocal.wProjCode, Get_Value=ProjCode
       Widget_Control, mLocal.wProjVal, Get_Value=ProjVal

       NewDDR.ProjCode=ProjCode
       NewDDR.Valid[0]=ProjVal

;
; Zone Code
;
       Widget_Control, mLocal.wZoneCode, Get_Value=ZoneCode
       Widget_Control, mLocal.wZoneVal, Get_Value=ZoneVal

       NewDDR.ZoneCode=ZoneCode
       NewDDR.Valid[1]=ZoneVal

;
; Datum (Ellipsoid) Code
;
       Widget_Control, mLocal.wDatumCode, Get_Value=DatumCode
       Widget_Control, mLocal.wDatumVal, Get_Value=DatumVal

       NewDDR.Ellipsoid=DatumCode
       NewDDR.Valid[2]=DatumVal

;
; Projection Coefficients
;
       Widget_Control, mLocal.wProjCoefVal, Get_Value=ProjCoefVal
       NewDDR.Valid[3]=ProjCoefVal
       FOR i = 0, 14 DO BEGIN
          Widget_Control, mLocal.wProjCoef[i], Get_Value=ProjCoef_TMP
          NewDDR.ProjCoef[i]=ProjCoef_TMP
       END


;
; Corner Coordinates
;
       Widget_Control, mLocal.wCornerVal, Get_Value=CornerVal
       NewDDR.Valid[4]=CornerVal

       FOR i = 0,1 DO BEGIN
          Widget_Control, mLocal.wUL[i], Get_Value=Corner_TMP
          NewDDR.UL[i]=Corner_TMP
       END
       FOR i = 0,1 DO BEGIN
          Widget_Control, mLocal.wUR[i], Get_Value=Corner_TMP
          NewDDR.UR[i]=Corner_TMP
       END
       FOR i = 0,1 DO BEGIN
          Widget_Control, mLocal.wLL[i], Get_Value=Corner_TMP
          NewDDR.LL[i]=Corner_TMP
       END
       FOR i = 0,1 DO BEGIN
          Widget_Control, mLocal.wLR[i], Get_Value=Corner_TMP
          NewDDR.LR[i]=Corner_TMP
       END




       IF (mLocal.wBackup GT 0) THEN $
          Widget_Control, mLocal.wBackup, Get_Value=Backup $
       ELSE Backup = 0
       print, 'Backup:',Backup

       IF (mLocal.Make) THEN BEGIN
           BDDR =Bytarr(199, NewDDR.nb)
           NewDDR[0] = Create_Struct(NewDDR[0], 'bddr', bddr)
       END
       

       
       IF (Strlen(FileName) eq 0) THEN ddrFile=Dialog_PickFile(/Write)
;       IF (mLocal.ddrFile EQ '') THEN ddrFile=Dialog_PickFile(/Write)
       IF (Backup EQ 1) THEN ImgWrite, mLocal.ddrBackup, mLocal.ddrFile+'.bak'
;die

       ImgWrite, NewDDR, FileName

    END; Save
    'Cancel': BEGIN
       Widget_Control, /Destroy, mLocal.wBase
    END; Cancel
    ELSE:
    ENDCASE; UValue


IF (Widget_Info(ev.top, /Valid_ID)) THEN $
        widget_control, ev.top, Set_UValue=mLocal


END; EditDDR_Event

;====================
; WIDGET DEFINITION ;
;====================
PRO EditDDR, DDRFile, MAKE=make

TF = 'courier'
;TF = -1
Device, Get_Screen_Size=ScreenSize
DevXSize=ScreenSize[0]
DevYSize=ScreenSize[1]

   IF (N_Params() EQ 0 AND NOT KEYWORD_SET(MAKE)) THEN BEGIN
      DDRFile=Dialog_PickFile(Filter='*.ddr', /Must_Exist)
      IF (DDRFile EQ '') THEN RETURN
   END

if (NOT KEYWORD_SET(MAKE)) THEN BEGIN
   ddr=read_las_ddr(DDRFile)
   if ddr.dt le 0 then ddr.dt = 1
   Title='Edit LAS DDR'
END ELSE BEGIN
   ddr={lasddr}             ;initialize ddr structure
   ddr.dt=1                 ;can't initialize structure with positive values.  adjust.
   ddr.valid=ddr.valid;+1    ;start with valid rather than invalid
   ddrfile=''
   Title='Make LAS DDR'
END
   ddrBackup=ddr

;
; Main Bases
;
   wBase=Widget_Base(Title=Title, /Column);, YSize=DevYSize)
   wBaseScr1=Widget_Base(wBase,/Frame);, X_Scroll_Size=700,Y_Scroll_Size=DevYSize-150)
   wBaseScr=Widget_Base(wBaseScr1,/Column)


;
; CW_Select Labels
;
   sDataTypes=['BYTE', 'I*2', 'I*4', 'REAL']
   sValid=['INVALID', 'VALID']
   sProjCoef=['A:',' ',' ','B:',' ',' ','C:',' ',' ','D:',' ',' ','E:',' ',' ']
   sCorners=['UL:',' ', 'UR:',' ','LL:', ' ', 'LR:',' ']
   @projcodenames


;
; File Name
;
   wFileName=CW_Field(wBaseScr, /String, Title='DDR File Name:', $
                   Value=DDRFile, XSize=30, Font=TF)


;
; Data File Information
;
   wFile_Info = Widget_Base(wBaseScr, /Row, /Frame)
   wNL=CW_Field(wFile_Info, /Integer, Title='NL:',Value=ddr.nl, XSize=5, Font=TF)
   wNS=CW_Field(wFile_Info, /Integer, Title='NS:',Value=ddr.ns, XSize=5, Font=TF)
   wNB=CW_Field(wFile_Info, /Integer, Title='NB:',Value=ddr.nb, XSize=5, Font=TF)
   wDT=CW_Select(wFile_Info, Title='Data', Value=sDataTypes, Start=ddr.dt-1, Font=TF)


;
; Modification history
;
   wMod_Info = Widget_Base(wBaseScr, /Row, /Frame)
   wLastMod  = Widget_Label(wMod_Info, Value='Last_Modified:     ', Font=TF)
   wLastDate = CW_Field(wMod_Info, /String, Title='Date:', Value=ddr.Last_Used_Date, $
                        XSize=10, Font=TF)
   wLastTime = CW_Field(wMod_Info, /String, Title='Time:', Value=ddr.Last_Used_Time, $
                        XSize=8, Font=TF)
   wSysType  = CW_Field(wMod_Info, /String, Title='System:', Value=ddr.SysType, $
                        XSize=10, Font=TF)


;
; Projection Code
;
   wProj_Info = Widget_Base(wBaseScr, /Row)
   wProjCode = CW_Select(wProj_Info, Title='Projection Code:', Value=sProjNames, $
                         Start=ddr.ProjCode, Font=TF)
   wProjVal = CW_Select(wProj_Info,Value=sValid, Start=ddr.valid[0], Font=TF)


;
; Zone Code
;
   wZone_Info = Widget_Base(wBaseScr, /Row)
   wZoneCode = CW_Field(wZone_Info, /Integer, Title='Zone Code:      ', Value=ddr.ZoneCode, $
                        XSize=5, Font=TF)
   wZoneVal = CW_Select(wZone_Info,Value=sValid, Start=ddr.valid[1], Font=TF)


;
; Datum (Ellipsoid) Code
;
   wDatum_Info = Widget_Base(wBaseScr, /Row)
   wDatumCode = CW_Field(wDatum_Info, /Integer, Title='Datum Code:     ', Value=ddr.Ellipsoid, $
                        XSize=5, Font=TF)
   wDatumVal = CW_Select(wDatum_Info,Value=sValid, Start=ddr.valid[2],Font=TF)


;
; Projection Coefficients
;
   wProjCoefVal = CW_Select(wBaseScr, Title='Projection Coefficients',Value=sValid, $
                  Start=ddr.valid[3], Font=TF)
   wProjCoef_Info = Widget_Base(wBaseScr, Row=5)
   wProjCoef = lonarr(15)
   FOR i = 0, 14 DO BEGIN
      wProjCoef[i] = CW_Field(wProjCoef_Info, /Floating, Title=sProjCoef[i], $
                     Value=ddr.ProjCoef[i], Font=TF)
   END


;
; Corner Coordinates
;
   wCornerVal = CW_Select(wBaseScr, Title='Corner Coodinates', Value=sValid, $
                  Start=ddr.valid[4], Font=TF)
   wCorner_Info=Widget_Base(wBaseScr, Row=4)
   wUL=lonarr(2)
   wUR=lonarr(2)
   wLL=lonarr(2)
   wLR=lonarr(2)
   FOR i = 0, 1  DO BEGIN
      wUL[i]=CW_Field(wCorner_Info, /Floating, Title=sCorners[i], Value=ddr.UL[i], Font=TF)
   END
   FOR i = 0, 1  DO BEGIN
      wUR[i]=CW_Field(wCorner_Info, /Floating, Title=sCorners[i+2], Value=ddr.UR[i], Font=TF)
   END
   FOR i = 0, 1  DO BEGIN
      wLL[i]=CW_Field(wCorner_Info, /Floating, Title=sCorners[i+4], Value=ddr.LL[i], Font=TF)
   END
   FOR i = 0, 1  DO BEGIN
      wLR[i]=CW_Field(wCorner_Info, /Floating, Title=sCorners[i+6], Value=ddr.LR[i], Font=TF)
   END



;
; Save/Cancel
;
wSaveCancel = Widget_Base(wBase, /Row)
wSave=Widget_Button(wSaveCancel, Value='Save', UValue='Save');,XSize=DevXSize/2-10)
wCancel=Widget_Button(wSaveCancel, Value='Cancel', UValue='Cancel');,XSize=DevXSize/2-10)
IF (NOT KEYWORD_SET(MAKE)) THEN $
   wBackup=CW_BGroup(wSaveCancel, 'Make Backup', UValue='Backup', /NonExclusive) $
ELSE wBackup=-1L

   mLocal= {ddr:ddr, ddrFile:ddrFile, ddrBackup:ddrBackup, $
            make:Keyword_Set(MAKE), $
            wBase: wBase, wFileName:wFileName, $
            wNL:wNL, wNS:wNS, wNB:wNB, wDT:wDT, $
            wLastDate:wLastDate, wLastTime:wLastTime, wSysType:wSysType, $
            wProjCode:wProjCode, wProjVal:wProjVal, $
            wZoneCode:wZoneCode, wZoneVal:wZoneVal, $
            wDatumCode:wDatumCode, wDatumVal:wDatumVal, $
            wProjCoef:wProjCoef, wProjCoefVal:wProjCoefVal, $
            wUL:wUL, wUR:wUR, wLL:wLL, wLR:wLR, wCornerVal:wCornerVal, $ 
            wSave:wSave, wCancel:wCancel, wBackup:wBackup $
           }

   Widget_Control, wBase, /Realize

   Widget_Control, wBase, Set_UValue=mLocal
   XManager, 'editddr', wBase, Event_Handler='editddr_event', /No_Block
END


