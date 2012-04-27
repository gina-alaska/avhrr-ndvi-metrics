;===========;
; GET_VALUE ;
;===========;
FUNCTION CW_MetricOpt_GET_VALUE, id
 
   Widget_Control, id, Get_UValue=State, /No_Copy


        Widget_Control,State.wSWindowLength,get_value=SWindowLength
        Widget_Control,State.wEWindowLength,get_value=EWindowLength
        Widget_Control,State.wStartYear,get_value=StartYear
        Widget_Control,State.wCurrentBand,get_value=CurrentBand

          State.CurrentValue.SWindowLength=SWindowLength  
          State.CurrentValue.EWindowLength=EWindowLength  
          State.CurrentValue.StartYear=StartYear  
          State.CurrentValue.CurrentBand=CurrentBand  
  

   ret=State.CurrentValue
   Widget_Control, id, Set_UValue=State, /No_Copy


Return, ret
END; GET_VALUE

;===========;
; SET_VALUE ;
;===========;
PRO CW_MetricOpt_SET_VALUE, id, NewValue

   ; Retrieve the state information
      stash=id
      Widget_Control, stash, Get_UValue=State, /No_Copy

      Widget_Control, State.wSWindowLength, Set_Value=NewValue.SWindowLength_def
      Widget_Control, State.wEWindowLength, Set_Value=NewValue.EWindowLength_def
      Widget_Control, State.wStartYear, Set_Value=NewValue.StartYear_def
      Widget_Control, State.wCurrentBand, Set_Value=NewValue.CurrentBand_def
  
   Widget_Control, stash, Set_UValue=state, /No_Copy
END; SET_VALUE


;=========================;
; CW_SMOOTHOPT DEFINITION ;
;=========================;
FUNCTION CW_MetricOpt, Parent

;
; Smoother Options
;

   wBase = Widget_Base(Parent,/column,/frame,map=0, $
              Func_Get_Value='CW_MetricOpt_GET_VALUE', $
              Pro_Set_Value='CW_MetricOpt_SET_VALUE')

;
;  Metrics Options
;
   plabel = Widget_Label(wBase,value="Metrics Parameters:")

   wSWindowLength = CW_Field(wBase,/integer, $
                    title="SOS Window Length:", xsize=5)

   wEWindowLength = CW_Field(wBase,/integer, $
                    title="EOS Window Length:", xsize=5)

   wStartYear = CW_Field(wBase,/integer, $
                    Title="Starting Year:", xsize=5)

   wCurrentBand = CW_Field(wBase,/integer, $
                    Title="Current Band:", xsize=5)

   CurrentValue={$
                   SWindowLength:-1 $
                 , EWindowLength:-1 $
                 , StartYear:-1 $
                 , CurrentBand:-1 $
                }
    
   State={  wBase:wBase   $
          , wSWindowLength:wSWindowLength $
          , wEWindowLength:wEWindowLength $
          , wStartYear:wStartYear $
          , wCurrentBand:wCurrentBand $
          , CurrentValue:CurrentValue $
         }
 
    ;Widget_Control, Widget_Info(wBase, /Child), Set_UValue=State, /No_Copy
    Widget_Control, wBase, Set_UValue=State, /No_Copy

Return, wBase
END
