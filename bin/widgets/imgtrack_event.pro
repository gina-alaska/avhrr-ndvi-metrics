PRO ImgTrack_event, event

Widget_Control, event.top, Get_UValue=mLocal, /No_Copy



CASE event.id OF

   mLocal.wDrawArea:  BEGIN

         iBand = long(mLocal.iBand(0))
         lSamp = long(mLocal.mImage.lSamp(0))
         lLine = long(mLocal.mImage.lLine(0))
         lDataType = long(mLocal.mImage.lDataType(0))
         lRadRefType = long(mLocal.mImage.lRadRefType(0))

         aPos = [event.x, lLine-event.y-1]

;print, lRadRefType
         IF (lRadRefType) THEN BEGIN
            Rad=0
            Ref=1
         ENDIF ELSE BEGIN
            Rad=1
            Ref=0
         ENDELSE

         Valu = mLocal.mImage.aImage(aPos[0], aPos[1], iBand)
         Data = ConvertAny(Valu, Band=iBand, DataType=lDataType, $
                Rad=Rad, Ref=Ref)

         Widget_Control, mLocal.wFPSamp, Set_Value=aPos[0]
         Widget_Control, mLocal.wFPLine, Set_Value=aPos[1]
         Widget_Control, mLocal.wFPValu, Set_Value=Valu
         Widget_Control, mLocal.wFPData, Set_Value=Data

         IF (event.type EQ 1)  THEN BEGIN
Widget_Control, mLocal.wDrawArea, /Draw_Motion_Events 

;print, event.x, event.y

           IF (event.release EQ 1) THEN BEGIN
;             Device, copy=[0,0,!D.X_Size, !D.Y_Size, 0,0,$
;                     mlocal.wDrawArea]
;print, !D.X_Size, !D.Y_Size
iPixels=3
iXOff=0>(event.x-1)<(!D.X_Size-iPixels)
iYOff=0>(event.y-1)<(!D.Y_Size-iPixels)

fCursor=Avg(TVRd(iXOff, iYOff, iPixels, iPixels))
;fCursor=Mean(TVRd(iXOff, iYOff, iPixels, iPixels))
PlotS, event.x, event.y, Color=(fCursor LT 128)*$
 (!D.N_Colors-1), Psym=1
           ENDIF
 
;            Widget_Control, mLocal.wFSSamp, Set_Value=aPos[0]
;            Widget_Control, mLocal.wFSLine, Set_Value=aPos[1]
;            Widget_Control, mLocal.wFSValu, Set_Value=Valu
;            Widget_Control, mLocal.wFSData, Set_Value=Data
         ENDIF



   END ; CASE wDrawArea
   ELSE:
ENDCASE

IF (Widget_Info(event.top, /Valid_ID)) THEN $
   Widget_Control, event.top, Set_UValue=mLocal, /No_Copy

END
