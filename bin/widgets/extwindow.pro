PRO extwindow_event, event
Widget_Control, event.top, Get_UValue=mLocal, /No_Copy


;print, event.id
;print, event.value

CASE event.id OF

   mLocal.wViewButton:  BEGIN

      CASE event.value OF 

        0: BEGIN
              print, "VIEW PUSHED"
              IF (Widget_Info(mLocal.wDrawBase, /Realized)) THEN $
                 Widget_Control, mLocal.wDrawBase, /Map, /Show $
              ELSE $
                 Widget_Control, mLocal.wDrawBase, /Realize
;                 tvscl, mLocal.mImage.aImage
           END
        1: BEGIN
              print, "CLOSE PUSHED"        

           END
        ELSE: 
      ENDCASE
 
   END ;

   ELSE:

ENDCASE
IF(Widget_Info(event.top, /Valid_ID)) THEN $
   Widget_Control, event.top, Set_UValue=mLocal, /No_Copy

END




PRO DrawBase_event, event

Widget_Control, event.top, Get_UValue = wBase
Widget_Control, wBase, Get_UValue=mLocal, /No_Copy
;mImage = mLocal.mImage
;tvscl, mImage.aImage
print, "IN DRAWBASE_EVENT"
                 tvscl, mLocal.mImage.aImage
IF(Widget_Info(event.top, /Valid_ID)) THEN $
   Widget_Control, wBase, Set_UValue=mLocal, /No_Copy


END




PRO extwindow

wBase = Widget_Base(Title="Draw Experiment", /base_align_center, /column)


asText = ["View", "Close"]
wViewButton = CW_BGroup2(wBase, asText, /Row, /Frame, /Exclusive, $
              Set_Value=1)


; Pop-up Draw Widget
wDrawBase = Widget_Base(/TLB_Size_Events, $
              XOffset=100, YOffset=100, $
              Event_Pro="DrawBase_Event", $
              Group_Leader=wBase, UValue=wBase)

wDraw = Widget_Draw(wDrawBase, XSize=512, YSize=512)
Widget_Control, wDrawBase, Event_Pro='DrawBase_event', $
              Set_UValue={wParentBase:wBase, wDraw:wDraw}




aImage = imgread("~/rad/ok96/ok_ndvi.img", 512, 512, /I2)

mImage = {$
           aImage: aImage, $
           lSamp:  512, $
           lLine:  512, $
           lBand:  10 $
         }


mLocal = {$
            wBase: wBase, $
            wViewButton: wViewButton, $
            mImage: mImage, $
            wDrawBase: wDrawBase, $
            wDraw: wDraw $
         }


Widget_Control, wBase, Set_UValue=mLocal, /Realize, /No_Copy

XManager, 'ExtWindow', wBase, No_Block=No_Block

END
