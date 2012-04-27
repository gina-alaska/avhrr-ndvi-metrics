PRO NTView_event, event

;   get the local structure from the TLB
Widget_Control, event.top, Get_UValue=mLocal, /No_Copy

CASE event.id OF


;
;  Dimensions/Load button group
;=========================================
   mLocal.wBGDL:  BEGIN

      ;  Dimensions selected
      IF (event.value EQ 0) THEN BEGIN
         ;  Get image size Info 
         Widget_Control, mLocal.wFFImage, Get_Value=sFile
         OpenR, LUN, sFile(0), /GET_LUN, Error = err

         ;  If no errors detected
         IF (err EQ 0) THEN BEGIN

            aFInfo = FStat(LUN) 
            Free_LUN, LUN
            ;  Get Data Type info and scale file size accordingly
            Widget_Control, mLocal.wBGIDT, Get_Value=lDataType
            CASE lDataType of
               0: aFInfo.Size = aFInfo.Size
               1: aFInfo.Size = aFInfo.Size/2
               2: aFInfo.Size = aFInfo.Size/4
               else:
            ENDCASE
   
          
            ;  Determine whether to map or realize 
            IF (Widget_Info(mLocal.WBaseSize, /Realized))  THEN $
               Widget_Control, mLocal.wBaseSize, /Map, /Show $
            ELSE $
               Widget_Control, mLocal.wBaseSize, /Realize
   
            ;  This could take a few moments
            Widget_Control, /Hourglass

            ;  ImgSize returns an array of size LonArr(3,*)
            aData = ImgSize(aFInfo.Size)
            asData = StrTrim(aData(0,*),2) + ' x ' + $
                     StrTrim(aData(1,*),2) + ' x ' + $
                     StrTrim(aData(2,*),2)

            ;  Display the string array on the list widget
            ;  Also store the Long array as the UValue
            Widget_Control, mLocal.wListSize, Set_Value=asData, $
                            Set_UValue=aData

         ENDIF ELSE BEGIN
            ;  An error was detected
            status = Dialog_Message(!Err_String, /Error)
         ENDELSE

      ENDIF ELSE BEGIN

            ;  Get the filename from the file selection widget
            Widget_Control, mLocal.wFFImage, Get_Value=sFile
            sFile = sFile(0)

            Widget_Control, mLocal.wFINSamp, Get_Value=lSamp
            Widget_Control, mLocal.wFINLine, Get_Value=lLine
            Widget_Control, mLocal.wFINBand, Get_Value=lBand

            lSamp = long(lSamp(0))
            lLine = long(lLine(0))
            lBand = long(lBand(0))
            aBandNames = mLocal.aBGBVText

            Widget_Control, mLocal.wBGIDT, Get_Value=lDataType
            Widget_Control, mLocal.wBGRR, Get_Value=lRadRefType

print, "LOADING IMAGE"

            ;  Load the Image
            CASE lDataType OF
               0:    aImage = imgread3(sFile, lSamp, lLine, lBand, dt=1)
               1:    aImage = imgread3(sFile, lSamp, lLine, lBand, dt=2)
               2:    aImage = imgread3(sFile, lSamp, lLine, lBand, dt=3)
               3:    aImage = imgread3(sFile, lSamp, lLine, lBand, dt=4)
              else:
            ENDCASE
         
            ;  Create Image Structure

            mImage = {$
                      aImage: aImage, $
                      lSamp:  lSamp, $
                      lLine:  lLine, $
                      lBand:  lBand, $
                      lDataType: lDataType, $
                      lRadRefType: lRadRefType, $
                      aBandNames: aBandNames $
                     }

            ;  Assign Image Structure to UValue so we can use it later
            Widget_Control, mLocal.wBGDL, Set_UValue = mImage, /No_Copy

print, "LOADING COMPLETE"

      ;
      ;  Sensitize Band View and Plot View Buttons
      ;  
            Widget_Control, mLocal.wBGBV, Sensitive = 1
;            Widget_Control, mLocal.wBGPV, Sensitive = 1
         ENDELSE



   END  ; wBDGL CASE

;   mLocal.wBGRR:  BEGIN
;      Widget_Control, mLocal.wBGRR, Get_Value=lRadRefType, /No_Copy
;      Widget_Control, mLocal.mImage, Get_Value=mImage, /No_Copy
;
;      mLocal.mImage.lRadRefType = lRadRefType
;
;      Widget_Control, mLocal.mImage, Set_Value = mImage, /No_Copy
;      Widget_Control, mLocal.wBGRR, Set_Value=lRadRefType, /No_Copy
;   
;   END  ; wBGRR

;
;  Done/Cancel Button Group
;=========================================
   mLocal.wBGDC:  BEGIN

      ;  Done or Cancel button selected
      ;  delete the pixmap if necessary
      
      IF (mLocal.lPixID NE -1) THEN $
         WDelete, mLocal.lPixID

      Widget_Control, event.top, /Destroy

   END  ; wBGDC CASE




;
;  Band View Button Group
;=========================================
   mLocal.wBGBV:  BEGIN
      Widget_Control, mLocal.wBGDL, Get_UValue=mImage, /No_Copy

      IF (event.select EQ 1) THEN BEGIN
         IF NOT (Widget_Info(mLocal.awChildBase(event.value), $
                             /Valid_ID)) THEN BEGIN

            mLocal.awChildBase(event.value) = ImgTrack(mLocal, $
               mImage, event.value)



         ENDIF

         IF (Widget_Info(mLocal.awChildBase(event.value), /Realized)) THEN $
            Widget_Control, mLocal.awChildBase(event.value), /Show, /Map $
         ELSE $
            Widget_Control, mLocal.awChildBase(event.value), /Realize

         CASE(event.value) OF
           0: tvscl, alog(mImage.aImage(*,*, event.value ) + 1)
           2: tvscl, alog(mImage.aImage(*,*, event.value ) + 1)
           else: tvscl, mImage.aImage(*,*, event.value )
         ENDCASE

      ENDIF ELSE BEGIN
         IF (Widget_Info(mLocal.awChildBase(event.value), /Valid_ID)) THEN $
            Widget_Control, mLocal.awChildBase(event.value), Map=0
      ENDELSE

      Widget_Control, mLocal.wBGDL, Set_UValue=mImage, /No_Copy

   END  ; wBGBV CASE


;
;  Plot View Button Group
;=========================================
   mLocal.wBGPV:  BEGIN


      Widget_Control, mLocal.wBGDL, Get_UValue = mImage, /No_Copy

      iPlot = event.value
      iWinNum = iPlot + 20 

      IF (event.select EQ 1) THEN BEGIN

         CASE iPlot OF
            ;  ND vs T4 Plot
            0:  BEGIN
                  b1 = rad2ref(mImage.aImage(*,*,0),1)
                  b2 = rad2ref(mImage.aImage(*,*,1),2)
                  nd = f_ndvi(b1,b2)
                 ; nd = getband(mImage.aImage, 5, mImage.lSamp)
                  t4 = mImage.aImage(*,*,3)
                  NDT4Idx = uniqpair(nd,t4)
                  window, iWinNum
                  plot, t4(NDT4Idx),nd(NDT4Idx),psym=3
                END
            ELSE:
         ENDCASE

      ENDIF ELSE BEGIN

         WDelete, iWinNum

      ENDELSE

      Widget_Control, mLocal.wBGDL, Set_UValue = mImage, /No_Copy

   END  ; wBGPV CASE

   ELSE:

ENDCASE




IF(Widget_Info(event.top, /Valid_ID)) THEN $
   Widget_Control, event.top, Set_UValue=mLocal, /No_Copy

END
