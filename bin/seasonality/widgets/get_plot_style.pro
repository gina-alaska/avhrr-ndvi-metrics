PRO  Get_Plot_Style_Event, ev

Widget_Control, ev.id, Get_UValue=uvalue
Widget_Control, ev.top, Get_UValue=mLocal

CASE (UValue) OF

;
; Change Bitmap On LineStyle Menu Button
;
   'bgLineStyle0': Widget_Control, mLocal.bmLineStyle, Set_Value=mLocal.Lines_BM[*,*,0]
   'bgLineStyle1': Widget_Control, mLocal.bmLineStyle, Set_Value=mLocal.Lines_BM[*,*,1]
   'bgLineStyle2': Widget_Control, mLocal.bmLineStyle, Set_Value=mLocal.Lines_BM[*,*,2]
   'bgLineStyle3': Widget_Control, mLocal.bmLineStyle, Set_Value=mLocal.Lines_BM[*,*,3]
   'bgLineStyle4': Widget_Control, mLocal.bmLineStyle, Set_Value=mLocal.Lines_BM[*,*,4]
   'bgLineStyle5': Widget_Control, mLocal.bmLineStyle, Set_Value=mLocal.Lines_BM[*,*,5]
   'bgLineStyle6': Widget_Control, mLocal.bmLineStyle, Set_Value=mLocal.Lines_BM[*,*,6]

;
; Change Bitmap On SymbolStyle Menu Button
;
   'bgSymbolStyle0': Widget_Control, mLocal.bmSymbolStyle, Set_Value=mLocal.Symbols_BM[*,*,0]
   'bgSymbolStyle1': Widget_Control, mLocal.bmSymbolStyle, Set_Value=mLocal.Symbols_BM[*,*,1]
   'bgSymbolStyle2': Widget_Control, mLocal.bmSymbolStyle, Set_Value=mLocal.Symbols_BM[*,*,2]
   'bgSymbolStyle3': Widget_Control, mLocal.bmSymbolStyle, Set_Value=mLocal.Symbols_BM[*,*,3]
   'bgSymbolStyle4': Widget_Control, mLocal.bmSymbolStyle, Set_Value=mLocal.Symbols_BM[*,*,4]
   'bgSymbolStyle5': Widget_Control, mLocal.bmSymbolStyle, Set_Value=mLocal.Symbols_BM[*,*,5]
   'bgSymbolStyle6': Widget_Control, mLocal.bmSymbolStyle, Set_Value=mLocal.Symbols_BM[*,*,6]
   'bgSymbolStyle7': Widget_Control, mLocal.bmSymbolStyle, Set_Value=mLocal.Symbols_BM[*,*,7]

   'cwcolor': BEGIN
      Widget_Control, mLocal.cwcolor, Get_Value=colorval
print, colorval
   end

   ELSE:

ENDCASE

IF (Widget_Info(ev.top, /Valid_ID)) THEN $
        Widget_Control, ev.top, Set_UValue=mLocal

END

;======================
;  WIDGET DEFINITION  ;
;======================
PRO  Get_Plot_Style;, mParent

;
; Get symbols for LineStyle and SymbolStyle menus
;
   @lines_bm
   @symbols_bm


   wBase=Widget_Base(Title='Plot Style',/Column);, Group_Leader=mParent.wBase)

;
;  Menu for Line Style
;
   wLineStyle=Widget_Base(wBase, /Row)

   Lines_BM=[ [[none_bm]], [[solid_bm]], [[dot_bm]], [[dash_bm]], [[dashdot_bm]], $
            [[dashdotdot_bm]],[[longdash_bm]] ]
   nLines_BM=n_elements(Lines_BM[0,0,*])

   bmLineStyle=Widget_Button(wLineStyle, value=Lines_BM[*,*,1],/menu, xsize=44)
   bgLineStyle=lonarr(nLines_BM)

   FOR i = 0, nLines_BM-1 DO BEGIN
      bgLineStyle[i]=Widget_Button(bmLineStyle, value=Lines_BM[*,*,i], $
                     UValue='bgLineStyle'+strcompress(i, /Remove_All))
   END

   label=Widget_Label(wLineStyle, Value='Line Style')


;
;  Menu for Symbol Style
;
   wSymbolStyle=Widget_Base(wBase, /Row)

   Symbols_BM=[ [[none_bm]], [[cross_bm]],[[asterisk_bm]], [[point_bm]], [[diamond_bm]], $
            [[triangle_bm]], [[square_bm]], [[x_bm]] ]
   nSymbols_BM=n_elements(Symbols_BM[0,0,*])

   bmSymbolStyle=Widget_Button(wSymbolStyle, value=Symbols_BM[*,*,0],/menu, xsize=44)
   bgSymbolStyle=lonarr(nSymbols_BM)

   FOR i = 0, nSymbols_BM-1 DO BEGIN
      bgSymbolStyle[i]=Widget_Button(bmSymbolStyle, value=Symbols_BM[*,*,i], $
                     UValue='bgSymbolStyle'+strcompress(i, /Remove_All))
   END
   label=Widget_Label(wSymbolStyle, Value='Symbol Style')

   cwcolor=cw_colorpick(wBase, UValue='cwcolor')


   Widget_Control, wBase, /Realize



   mLocal={wBase:wBase, $
           bgLineStyle:bgLineStyle, bmLineStyle:bmLineStyle, Lines_BM:Lines_BM, $
           bgwSymbolStyle:bgSymbolStyle, bmSymbolStyle:bmSymbolStyle, Symbols_BM:Symbols_BM, $
           cwcolor:cwcolor $
          }

   Widget_Control, wBase, Set_UValue=mLocal

   XManager, 'get_plot_style', wBase, event_handler='get_plot_style_event', /No_Block

;RETURN, wBase
END
