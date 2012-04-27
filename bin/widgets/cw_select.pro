;
;  NAME:
;     CW_Select
;
;  PURPOSE:
;     CW_Select generates what amounts to droplist made of
;     menu buttons.  It is different from a droplist in that
;     it can have bitmaps as choices and the initial choice
;     doesn't have to be the first in the list of values.
;
;  CATEGORY:
;     Compound Widgets
;
;  CALLING SEQUENCE:
;     Widget = CW_Select(Parent)
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
;     Bitmaps on buttons must be of same size
;

;====================;
; HANDLER DEFINITION ;
;====================;
PRO CW_Select_Event, ev

; Retrive the state of this compoutnd wicget
   base=ev.handler
   stash=Widget_Info(base,/Child)
   Widget_Control, stash, Get_UValue=state, /No_Copy
   Widget_Control, ev.id, Get_UValue=UValue

   FOR i = 0, state.nButtons-1 DO BEGIN
      IF (UValue EQ 'wButtons'+strcompress(i,/Remove_All)) THEN BEGIN
         CASE state.ButtonType OF
            'STRING':$
                Widget_Control, state.wMenuButton, Set_Value=state.value[i]
            'BITMAP':$
                Widget_Control, state.wMenuButton, Set_Value=state.value[*,*,i]
            ELSE:
         ENDCASE
         State.CurrentValue=i
      END
   END


   Widget_Control, Widget_Info(base, /Child), Set_UValue=state, /No_Copy
END


;
; REALIZE  ;THIS CURRENTLY DOESN'T DO ANYTHING
;
PRO CW_Select_REALIZE, id
   ;Retrieve the state information
   stash=Widget_Info(id, /Child)
   Widget_Control, stash, Get_UValue=state, /No_Copy

   ;Initialize Everything
   ;

END; REALIZE


;
; GET VALUE
;
FUNCTION  CW_Select_Get_Value, id
   ;Retrieve state of this compound widget
   stash = Widget_Info(id, /Child)
   Widget_Control, stash, Get_UValue=state, /No_Copy

   Ret= state.CurrentValue

   Widget_Control, stash, Set_UValue=state, /No_Copy
   Return, ret
END; GET_VALUE


;
; SET VALUE
;
PRO  CW_Select_Set_Value, id, NewValue


  IF (NewValue EQ -1) THEN BEGIN
;     CW_Select_REALIZE, id
  ENDIF ELSE BEGIN
  ; Retrieve the state information
     stash=Widget_Info(id, /Child)
     Widget_Control, stash, Get_UValue=state, /No_Copy
     IF (state.ButtonType EQ 'STRING') THEN $
        Widget_Control, state.wMenuButton, Set_Value=state.value[NewValue] $
     ELSE $
        Widget_Control, state.wMenuButton, Set_Value=state.value[*,*,NewValue]
     state.CurrentValue=NewValue
  END
  Widget_Control, stash, Set_UValue=state, /No_Copy
END; SET_VALUE

;===================;
; WIDGET DEFINITION ;
;===================;

FUNCTION  CW_Select, Parent, VALUE=value, TITLE=title, START=start,$
          UVALUE=uvalue, XSIZE=xsize, FONT=font

   IF NOT KEYWORD_SET(TITLE) THEN title=''
   IF N_ELEMENTS(START) EQ 0 THEN start=0
   IF N_ELEMENTS(VALUE) EQ 0 THEN value=''
   IF NOT KEYWORD_SET(XSIZE) THEN XSize=0
   IF N_ELEMENTS(FONT) EQ 0  THEN Font=''

   ValueSize=Size(Value)
   nValueSize=N_Elements(ValueSize)
   nButtons=ValueSize(nValueSize-3)
   wButtons=lonarr(nButtons)

   wBase=Widget_Base(Parent, /Row, $
;         Event_Func='CW_Select_EVENT', $
         Func_Get_Value='CW_Select_GET_VALUE', $
         Pro_Set_Value='CW_Select_SET_VALUE')
   wLabel=Widget_Label(wBase, value=title, FONT=FONT)

;
;  If buttons have string labels
;
   IF(ValueSize[0] EQ 1) THEN BEGIN
;Device, Font='courier'
;Font='courier'

; Need to find the longest string in the list to size the button, then
; set actual value.
      ilongest = where(strlen(value) eq max(strlen(Value)))

      wMenuButton=Widget_Button(wBase,Value=Value(ilongest[0]),/Menu,FONT=FONT,XSize=XSize)

      mgeo=widget_info(wMenuButton, /Geometry)
      widget_control, wMenuButton, xsize=mgeo.xsize
      widget_control, wMenuButton, set_value=value(start)

      ButtonType='STRING'
      FOR i = 0, nButtons-1 DO BEGIN
         wButtons[i]=Widget_Button(wMenuButton, value=value[i], $
                     UValue='wButtons'+strcompress(i, /Remove_All),FONT=FONT)
      END;FOR
   END;IF

;
;  IF the buttons have bitmap labels
;
   IF(ValueSize[0] EQ 3) THEN BEGIN
      wMenuButton=Widget_Button(wBase,Value=Value[*,*,start],/Menu)
      ButtonType='BITMAP'
      FOR i = 0, nButtons-1 DO BEGIN
         wButtons[i]=Widget_Button(wMenuButton, value=value[*,*,i], $
                        UValue='wButtons'+strcompress(i, /Remove_All), ysize=2)
      END;FOR
;wtest=widget_button(wBase, Value=value[*,*,5])

   END;IF


State={wBase:wBase, $
       value:value, $
       CurrentValue:start, $
       wButtons:wButtons, $
       wMenuButton:wMenuButton, $
       nButtons:nButtons, $
       ButtonType:ButtonType $
       }

; Stash the state
   Widget_Control, Widget_Info(wBase, /Child), Set_UValue=state, /No_Copy
   ;Widget_Control, wBase, /Realize


;Widget_Control, wBase, Set_UValue=State

XManager, 'cw_select', wBase, event_handler='cw_select_event', /No_Block

Return, wBase
END
