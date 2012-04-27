; NAME: CW_SMOOTHCUBE
;
; PURPOSE: This function is an interface which starts up the
;  external C program to smooth a cube
;



;===============;
; EVENT HANDLER ;
;===============;
PRO CW_SmoothCube_Event, ev




END

;===================;
; WIDGET DEFINITION ;
;===================;
FUNCTION CW_SmoothCube, mParent
@smoother_defaults


   wBase=Widget_Base(Title='Smooth Cube', Group_Leader=mParent.wBase, /Column)
   wSmoothOpt=CW_SmoothOpt(wBase)
   Widget_Control, wSmoothOpt, Set_Value=sm_def
   wSC=Widget_Base(wBase, Col=2)
   wSmooth=Widget_Button(wSC, Value='Smooth Cube', UValue='wSmooth')
   wCancel=Widget_Button(wSC, Value='Cancel', UValue='wCancel')
   Widget_Control, wSmoothOpt, Map=1

   mParent.wCubeSmooth=wBase

   mLocal={ mParent:mParent $
          , wBase:wBase $
          , wSmooth:wSmooth $
          , wCancel:wCancel $
;          , Map:Map $
          }


;   Widget_Control, wBase, Map=0
   Widget_Control, wBase, /Realize
   Widget_Control, wBase, Set_UValue=mLocal, Event_Pro='CW_SmoothCube_Event'
   XManager, 'cw_smoothcube', wBase, Event_Handler='cw_smoothcube_event',$
              /No_Block


die
   
Return, wBase
END
