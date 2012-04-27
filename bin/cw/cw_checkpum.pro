;---------------------------------------------------------------------------
; Author: Manuel J. Suarez
; $RCSfile$
; $Revision$
; Orig: 1999/05/07 12:10:30
; $Date$
;---------------------------------------------------------------------------
; Module: CW_CHECKPUM
;
; Purpose: Pop-up menu (PUM) with check-boxes
;
; Functions: 
; Procedures: 
;
; Calling Sequence: wcbmenu=CW_CheckMenu(wParent)
;
; Inputs: 
;   wParent - Widget ID of Parent
;
; Outputs: 
;   wBase - Widget ID
;
; Keywords: 
;   Title - String title for menu
;   Names - String array of button names
;   Initial - Initial settings of checkboxes, default=0
;   XPos,YPos - X and Y location to place Widget
;
; History: 
;---------------------------------------------------------------------------
; $Log$
;---------------------------------------------------------------------------

;===================;
; WIDGET DEFINITION ;
;===================;
FUNCTION CW_CheckPUM, wParent, Title=Title, Names=Names, Initial=Initial, $
   XOFFSET=XOffset, YOFFSET=YOffset, XSize=XSize, YSize=YSize, Map=Map

numbuttons=N_Elements(Names)
IF (N_Elements(Initial) eq 0) then Initial=lonarr(numbuttons)

fonts=fontgen()
;on_error, 2

   CASE N_Params() OF
     0: wBase=Widget_Base(Title=Title, Column=1, TLB_Frame_Attr=5, $
              XOffset=XOffset, YOffset=YOffset)
        
     1: wBase=Widget_Base(wParent,Title=Title, $
              XOffset=XOffset, YOffset=YOffset, $
;              XSize=XSize, YSize=YSize, $
              Group_Leader=wParent);, /Column)  
     ELSE:
   ENDCASE

button_font = fonts.prop12m;'-adobe-helvetica-medium-r-normal--12-*-*-*'

   wPUM=CW_BGroup(wBase, Names, Set_Value=Initial, /NonExclusive, /Frame, $
        XSize=XSize, YSize=YSize, Font=Button_Font)

   Widget_Control, wBase, Map=0
   Widget_Control, wBase, /Realize

   state={wBase:wBase $
         ,wPUM:wPUM $
         ,OldValue:Initial $
         ,CurValue:Initial $
         ,Map:0 $
         }
   Widget_Control, wBase, Set_UValue=state, /No_Copy

Return, wBase
END
