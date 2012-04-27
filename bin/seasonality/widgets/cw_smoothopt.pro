;===========;
; GET_VALUE ;
;===========;
FUNCTION CW_SmoothOpt_GET_VALUE, id
 
   Widget_Control, id, Get_UValue=State, /No_Copy


        Widget_Control,State.pp,get_value=pp
        Widget_Control,State.ps,get_value=ps
        Widget_Control,State.nmin,get_value=nmin
        Widget_Control,State.nmax,get_value=nmax
        Widget_Control,State.swin,get_value=swin
        Widget_Control,State.rwin,get_value=rwin
        Widget_Control,State.cwin,get_value=cwin
        Widget_Control,State.pwght,get_value=pwght
        Widget_Control,State.swght,get_value=swght
        Widget_Control,State.vwght,get_value=vwght

          State.CurrentValue.pp=pp  
          State.CurrentValue.ps=ps 
          State.CurrentValue.nmin=nmin 
          State.CurrentValue.nmax=nmax 
          State.CurrentValue.swin=swin 
          State.CurrentValue.rwin=rwin 
          State.CurrentValue.cwin=cwin 
          State.CurrentValue.pwght=pwght 
          State.CurrentValue.swght=swght 
          State.CurrentValue.vwght=vwght 
  

;die
   ret=State.CurrentValue
   Widget_Control, id, Set_UValue=State, /No_Copy


Return, ret
END; GET_VALUE

;===========;
; SET_VALUE ;
;===========;
PRO CW_SmoothOpt_SET_VALUE, id, NewValue

   ; Retrieve the state information
      ;stash=Widget_Info(id, /Child)
      stash=id
      Widget_Control, stash, Get_UValue=State, /No_Copy

      Widget_Control, State.pp, Set_Value=NewValue.pp_def
      Widget_Control, State.ps, Set_Value=NewValue.ps_def
      Widget_Control, State.nmin, Set_Value=NewValue.nmin_def
      Widget_Control, State.nmax, Set_Value=NewValue.nmax_def
      Widget_Control, State.swin, Set_Value=NewValue.swin_def
      Widget_Control, State.rwin, Set_Value=NewValue.rwin_def
      Widget_Control, State.cwin, Set_Value=NewValue.cwin_def
      Widget_Control, State.pwght, Set_Value=NewValue.pwght_def
      Widget_Control, State.swght, Set_Value=NewValue.swght_def
      Widget_Control, State.vwght, Set_Value=NewValue.vwght_def
   
   Widget_Control, stash, Set_UValue=state, /No_Copy
END; SET_VALUE


;=========================;
; CW_SMOOTHOPT DEFINITION ;
;=========================;
FUNCTION CW_SmoothOpt, Parent

;
; Smoother Options
;

   wBase = Widget_Base(Parent,/column,/frame,map=0, $
              Func_Get_Value='CW_SmoothOpt_GET_VALUE', $
              Pro_Set_Value='CW_SmoothOpt_SET_VALUE')

   slabel = Widget_Label(wBase,value="Smooth Parameters:")

   pp    = cw_field(wBase,/floating,title="Peak Percentage     ",$
                        uvalue="percent",xsize=10)

   ps    = cw_field(wBase,/integer, title="Peaks per Season   ",$
                        uvalue="peak_season",xsize=10)

   nmin  = cw_field(wBase,/Floating,title="Minimum NDVI      ",$
                        uvalue="nmin",xsize=10)

   nmax  = cw_field(wBase,/Floating,title="Maximum NDVI      ",$
                        uvalue="nmax",xsize=10)

   swin  = cw_field(wBase,/integer,title="Season Window     ",$
                        uvalue="season",xsize=10)

   rwin  = cw_field(wBase,/integer,title="Regression Window ",$
                        uvalue="regwin",xsize=10)

   cwin  = cw_field(wBase,/integer,title="Combination Window",$
                        uvalue="comwin",xsize=10)

   pwght = cw_field(wBase,/floating,title="Peak Weights",$
                        uvalue="peak_wght",xsize=10)

   swght = cw_field(wBase,/floating,title="Slope Weights",$
                        uvalue="slp_wght",xsize=10)

   vwght = cw_field(wBase,/floating,title="Valley Weights",$
                        uvalue="valley_wght",xsize=10)


;   wsbasegeo = Widget_Info(wBase, /geometry)

CurrentValue={msmoothparam}
   
   State={  Parent:Parent $ 
          , wBase:wBase   $
          , pp:pp        $ 
          , ps:ps        $ 
          , nmin:nmin        $ 
          , nmax:nmax        $ 
          , swin:swin        $ 
          , rwin:rwin        $ 
          , cwin:cwin        $ 
          , pwght:pwght        $ 
          , swght:swght        $ 
          , vwght:vwght        $ 
          , CurrentValue:CurrentValue $
         }
 
    ;Widget_Control, Widget_Info(wBase, /Child), Set_UValue=State, /No_Copy
    Widget_Control, wBase, Set_UValue=State, /No_Copy

Return, wBase
END
