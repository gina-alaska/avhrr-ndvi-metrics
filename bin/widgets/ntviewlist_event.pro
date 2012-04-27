;###########################################################################
; File Name:  %M%
; Version:    %I%
; Author:     Mike Schienle
; Orig Date:  97-06-23
; Delta Date: %G% @ %U%
;###########################################################################
; Purpose: Han events from pop-up size list widget.
; History: 
;###########################################################################
; %W%
;###########################################################################

PRO NTViewList_event, event
;   get the structure from the TLB
Widget_Control, event.top, Get_UValue=mLocal, /No_Copy

;   see which event was generated
IF (event.ID EQ mLocal.wBGSize) THEN BEGIN
   ;   done/cancel button group selected
   ;   unmap the hierarchy
   Widget_Control, event.top, Map=0
	
   IF (event.value EQ 0) THEN BEGIN
      ;   done was selected - update size on parent base
      ;   see which item is selected in the list
      iPos = Widget_Info(mLocal.wListSize, /List_Select)
      ;   check to make sure an item was selected
      ;   this really shouldn't happen, but make sure anyway
      IF (iPos NE -1) THEN BEGIN
         ;   the list structure was stored as the list's UValue
	 Widget_Control, mLocal.wListSize, $
		Get_UValue=aData, /No_Copy
	
         ;   use the base of the parent to get the structure
         Widget_Control, mLocal.wParentBase, $
		Get_UValue=mParent, /No_Copy
	
         ;   put the X position in the Sample field
         Widget_Control, mParent.wFINSamp, Set_Value=aData[0, iPos]
         ;   put the Y position in the Line field
         Widget_Control, mParent.wFINLine, Set_Value=aData[1, iPos]
         ;   put the Band position in the Line field
         Widget_Control, mParent.wFINBand, Set_Value=aData[2, iPos]
	
         ;   put the parent structure back
         Widget_Control, mLocal.wParentBase, $
		Set_UValue=mParent, /No_Copy
      ENDIF
   ENDIF
ENDIF ELSE BEGIN
   ;   the list widget was selected
   ;   only process on double click
   IF (event.clicks EQ 2) THEN BEGIN
   ;   create an event to mimick selecting the done button
      mFakeEvent = {$
	ID: mLocal.wBGSize, $
	Top: event.top, $
	Handler: event.handler, $
	Select: 1L, $
	Value: 0}
		
   ;   put the structure back into the TLB
   Widget_Control, event.top, Set_UValue=mLocal, /No_Copy
   ;   call this event handler with our fake event
   NTViewList_event, mFakeEvent

   ;   get the structure from the TLB
   Widget_Control, event.top, Get_UValue=mLocal, /No_Copy
   ENDIF
ENDELSE
	
;  put the structure back into the TLB
Widget_Control, event.top, Set_UValue=mLocal, /No_Copy
END
