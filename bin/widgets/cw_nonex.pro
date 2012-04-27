;
;  NAME:
;     CW_NONEX
;
;  PURPOSE:
;     CW_NonEx creates a dropdown menu of nonexclusive buttons
;
;  CATEGORY:
;     Compound Widgets
;
;  CALLING SEQUENCE:
;     Widget = CW_NonEx(Parent)
;
;  INPUTS:
;     Parent:  The ID of the calling Widget
;
;  KEYWORDS:
;     VALUE:  The array containing the menu button labels.
;             Can be strings or bitmaps
;     TITLE:  String of label to attach to droplist
;     START:  Index into VALUE array for initial button label
;     UVALUE: User Value
;
;  OUTPUTS:
;     The ID of the created Widget
;
;  COMMON BLOCKS:
;     None
;
;  LIMITATIONS:
;

;====================;
; HANDLER DEFINITION ;
;====================;
PRO CW_NonEx, ev

END; CW_NONEX
;====================;
; GET VALUE          ;
;====================;
FUNCTION CW_NonEx_Get_Value, id

END; GET_VALUE

;====================;
; SET VALUE          ;
;====================;
PRO CW_NonEx_Set_Value, id, NewValue

END; SET_VALUE

;====================;
; WIDGET DEFINITION  ;
;====================;
FUNCTION CW_NonEx, Parent, Names, SET_VALUE=Set_Value, Label_Top

;
; Initialize Keywords
;
   IF (N_Elements(SET_VALUE) EQ 0) THEN Set_Value=intarr(N_Elements(Names))


;
; Definitions
;
   wBase=Widget_Base(Parent)
   wNonEx=CW_BGroup(wBase, Names, Set_Value=Set_Value, /Column, $
                    /NonExclusive, Label_Top=Label_Top)

END; CW_NONEX
