;---------------------------------------------------------------------------
; Author: Manuel J. Suarez
; $RCSfile$
; $Revision$
; Orig: 1999/05/07 19:40:05
; $Date$
;---------------------------------------------------------------------------
; Module: 
; Purpose: 
; Functions: 
; Procedures: 
; Calling Sequence: 
; Inputs: 
; Outputs: 
; Keywords: 
; History: 
;---------------------------------------------------------------------------
; $Log$
;---------------------------------------------------------------------------
PRO ZoomView_Event, ev
   Widget_Control, ev.id, Get_UValue=UValue
   Widget_Control, ev.top, Get_UValue=mLocal
  


; ========= Motion Send Position and Cover Event =========
   ZoomView_Motion, ev


; ========= Left Release to Bring up smoother =========
   IF (ev.release eq 1) THEN ZoomView_Left_Release_Event, mLocal, ev


; ========= Right Click to Bring up Zoom Slider =========
   IF (ev.press eq 4) THEN BEGIN
      mLocal.MapSlider=abs(mLocal.MapSlider-1)
      Widget_Control, mLocal.wSlideBase, Map=mLocal.MapSlider
   END


   Widget_Control, ev.top, Set_UValue=mLocal

END

;=======================;
; EVENT HANDLER: MOTION ;
;=======================;
PRO ZoomView_Motion, ev

   Widget_Control, ev.top, Get_UValue=mLocal

; ====== Fake motion event to send to position monitor =========
   Widget_Control, mLocal.wParent, Get_UValue=mParent
   Widget_Control, mParent.wParent, Get_UValue=mGParent
   Widget_Control, mLocal.wZoomSlider, Get_Value=ZoomFactor

   x = mParent.mFullBox.xbox[0]+ev.x/ZoomFactor
   y = mParent.mFullBox.ImgSize[1]-(mParent.mFullBox.ybox[0]+ev.y/ZoomFactor)-1

   FakeEvent={WIMAGE $
             , id: ev.id $
             , top: ev.top $
             , handler: mGParent.wPosition $
             , x: x $
             , y: y $
             }

   if(Widget_Info(mGParent.wPosition, /Valid_ID)) THEN $
      Widget_Control, mGParent.wPosition, Send_Event=FakeEvent

; ========= FAKE EVENT TO SEND TO COVER TYPE MONITOR =========
      value=long(mParent.Image[x,y])
      CASE (mParent.mClassInfo.attExist) OF
         0: cover='<NO DATA>'
         1: BEGIN
               covervalue=long(mParent.mClassInfo.lccImage[x,y])
               cover=mParent.mClassInfo.attTable[covervalue]
            END
         ELSE:
      ENDCASE
      FakeEvent={WCOVERMOTION $
                , id: ev.id $
                , top: ev.top $
                , handler: mGParent.wCoverType $
                , x: x $
                , y: y $
                , value:value $
                , cover:cover $
                }

      if(Widget_Info(mGParent.wCoverType, /Valid_ID)) THEN $
         Widget_Control, mGParent.wCoverType, Send_Event=FakeEvent


   Widget_Control, mLocal.wParent, Set_UValue=mParent
   Widget_Control, ev.top, Set_UValue=mLocal


END; ZoomView_Motion
;============================================;
; EVENT HANDLER: ZoomView_Left_Release_Event ;
;============================================;
PRO ZoomView_Left_Release_Event, mLocal, ev

   Widget_Control, mLocal.wParent, Get_UValue=mParent
   Widget_Control, mParent.wParent, Get_UValue=mGParent
   Widget_Control, mLocal.wZoomSlider, Get_Value=ZoomFactor

   x = mParent.mFullBox.xbox[0]+ev.x/ZoomFactor
   y = mParent.mFullBox.ImgSize[1]-(mParent.mFullBox.ybox[0]+ev.y/ZoomFactor)-1
   
; ========= FAKE EVENT TO SEND TO COVER TYPE MONITOR (LAST VALUE) =========
   value=long(mParent.Image[x,y])
   covervalue=long(mParent.mClassInfo.lccImage[x,y])
   CASE (mParent.mClassInfo.attExist) OF
      0: cover='<NO DATA>'
      1: cover=mParent.mClassInfo.attTable[covervalue]
      ELSE:
   ENDCASE

   FakeEvent={WCOVERSELECT $
             , id: ev.id $
             , top: ev.top $
             , handler: mGParent.wCoverType $
             , x: x $
             , y: y $
             , value:value $
             , cover:cover $
             }

   if(Widget_Info(mGParent.wCoverType, /Valid_ID)) THEN $
      Widget_Control, mGParent.wCoverType, Send_Event=FakeEvent


; ========= FAKE EVENT TO PLOT POINT =========
   if (NOT Widget_Info(mGParent.wSmoother, /Valid_ID)) THEN $
               mGParent.wSmoother = Smoother(mGParent)

   Widget_Control, mGParent.wBase, Set_UValue=mGParent

   FakeEvent = {WZOOMDRAW, $
                id: ev.id, $
                top: ev.top, $
                handler: mGParent.wSmoother, $
                x: x, $
                y: y }
   Widget_Control, mGParent.wSmoother, Send_Event=FakeEvent




END

;===========================;
; EVENT HANDLER: ZOOMSLIDER ;
;===========================;
PRO ZoomSlider_Event,ev
   Widget_Control, ev.top, Get_UValue=mLocal
   Widget_Control, mLocal.wBase, TLB_Get_Size=TLBSize
   Widget_Control, mLocal.wZoomSlider, Get_Value=ZoomFactor
   Widget_Control, mLocal.wParent, Get_UValue=parent    
   Parent.mFullBox.XBoxSize=TLBSize[0]/ZoomFactor
   Parent.mFullBox.YBoxSize=TLBSize[1]/ZoomFactor
   Widget_Control, mLocal.wParent, Set_UValue=parent    
END

;=======================;
; EVENT HANDLER: RESIZE ;
;=======================;
PRO ZoomView_Resize_Event, ev

   Widget_Control, ev.id, Get_UValue=UValue
   Widget_Control, ev.top, Get_UValue=mLocal

   Widget_Control, mLocal.wBase, TLB_Get_Size=TLBSize
   Widget_Control, mLocal.wZoomView, Scr_XSize=TLBSize[0]
   Widget_Control, mLocal.wZoomView, Scr_YSize=TLBSize[1]

   Widget_Control, mLocal.wSlideBase, SCR_XSize=TLBSize[0]
   Widget_Control, mLocal.wZoomSlider, SCR_XSize=TLBSize[0]

   ZoomViewGeo=Widget_Info(mLocal.wZoomView, /Geometry)
   Widget_Control, mLocal.wZoomSlider, Get_Value=ZoomFactor
   Widget_Control, mLocal.wParent, Get_UValue=parent    
   Parent.mFullBox.XBoxSize=ZoomViewGeo.XSize/ZoomFactor
   Parent.mFullBox.YBoxSize=ZoomViewGeo.YSize/ZoomFactor
   Widget_Control, mLocal.wParent, Set_UValue=parent    

END


;===================;
; WIDGET DEFINITION ;
;===================;
FUNCTION ZoomView, wParent, XSize=XSize, YSize=YSize

   SCR_XSIZE=250
   SCR_YSIZE=250

   wBase=Widget_Base(Title='Zoom View', $
         Group_Leader=wParent, /Tlb_Size_Events, $
         Event_Pro='ZoomView_Resize_Event', TLB_Frame_Attr=8)

   wZoomView=Widget_Draw(wBase, XSize=XSize, YSize=YSize, $
         /Motion_Events, /Button_Events, $
         Event_Pro='ZoomView_Event')
   wbaseGeo=Widget_Info(wBase,/Geo)
   
   Widget_Control, wBase, map=0
   Widget_Control, wBase, /Realize
   wSlideBase=Widget_Base(wBase, Group_Leader=wBase,$
         XOffset=0, YOffset=0)
   wZoomSlider= Widget_Slider(wSlideBase, value=2, minimum=1, maximum=16, $
         scroll=1, XSize=wBasegeo.xsize,/drag)

   Widget_Control, wZoomView, Get_Value=CurWin

   Widget_Control, wSlideBase, Map=0
   Widget_Control, wSlideBase, /Realize


   state={ wParent:wParent $
         , wBase:wBase $
         , wZoomView:wZoomView $
         , wSlideBase:wSlideBase $
         , wZoomSlider:wZoomSlider $
         , MapSlider:0 $
         }
   Widget_Control, wBase, Set_UValue=State


   XManager, 'ZoomView', wBase, Event_Handler='ZoomView_Resize_Event', $
             /No_Block

   XManager, 'ZoomView', wZoomSlider, Event_Handler='ZoomSlider_Event', $
             /No_Block
   XManager, 'ZoomView', wZoomView, Event_Handler='ZoomView_Event', $
             /No_Block

Return, wBase
END
