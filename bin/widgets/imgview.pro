;====================;
; HANDLER DEFINITION ;
;====================;

PRO ImgView_EVENT, id

END; ImgView_EVENT
;====================;
; WIDGET DEFINITION  ;
;====================;
FUNCTION ImgTrack, Image, TITLE=Title

;
;  This is a widget which will hold an image and have
;  fields to track line, sample and data value
;

   iSize=Size(Image)
   IF(NOT KEYWORD_SET(TITLE)) Title=''

   ;    create the main base for the ImgTrack widget 
   wBase = Widget_Base(Title=title, /Column)

   ;    create draw base to display image
   wDrawArea = Widget_Draw(wBase, $
        XSize = iSize[1],  YSize = iSize[2], $
        /Frame, /Button_Events, /Motion_Events) 

   ;    create fields for current line, sample, value
   wLabel = Widget_Label(wBase, Value='Cursor Position')
   wBasePos = Widget_Base(wBase, /Frame, Row=2, /Base_Align_Center)

   ;    create fields for selected line, sample, value
   wLabel = Widget_Label(wBase, Value='Selected Value')
   wBaseSel = Widget_Text(wBase, /Frame,/All_Events, /Editable, $
        XSize = 20, YSize = 4 )
 
;   awBase = [wBasePos, wBaseSel]
   awBase = [wBasePos]
   asText = ["Sample", " Line ", "Value"]

   lNFields =  N_Elements(asText)
   awField = LonArr(lNFields, N_Elements(awBase))
   
   FOR i = 0, (N_Elements(awField) - 1) DO $
      awField[i MOD lNFields] = CW_Field(awBase[i/lNFields], $
      Title=asText[i MOD lNFields], /Floating, XSize=7)

   wFPSamp = awField[0]
   wFPLine = awField[1]
   wFPValu = awField[2]


   mLocal={$
           wBase: wBase, $
           wDrawArea: wDrawArea, $
           wFPSamp: wFPSamp, $
           wFPLine: wFPLine, $
           wFPValu: wFPValu $
          }



;Widget_Control, mParent.wBase, Set_UValue=mParent, /No_Copy
;
Widget_Control, wBase, Set_UValue=mLocal, /No_Copy, $
                Event_Pro='ImgTrack_event'

;Widget_Control, mParent.BGDL, Set_UValue=mImage, /No_Copy

;         ImgTrack_event, mEvent


return, wBase
END
