PRO CW_ColorCube_Event, ev

   Widget_Control, ev.id, Get_UValue=UValue
   Widget_Control, ev.top, Get_UValue=mLocal

   CASE (UValue) OF
   
      'wColorSquare': BEGIN
          Widget_Control, mLocal.wStaticColor, Get_Value=StaticColor

      END; wColorSquare
      'wStaticColor':
      'wStaticSlider':BEGIN
          Widget_Control, mLocal.wStaticSlider, Get_Value=StaticSlider
          Widget_Control, mLocal.wColorSquare, Get_Value=wCS
          wSet, wCS
          
          Widget_Control, mLocal.wStaticColor, Get_Value=StaticColor
          CASE (StaticColor) OF
             0: tv, [[[mLocal.scolor+StaticSlider]], $
                     [[mLocal.vcolor]], $
                     [[mLocal.hcolor]]], true=3
             1: tv, [[[mLocal.vcolor]], $
                     [[mLocal.scolor+StaticSlider]], $
                     [[mLocal.hcolor]]], true=3
             2: tv, [[[mLocal.vcolor]], $
                     [[mLocal.hcolor]], $
                     [[mLocal.scolor+StaticSlider]]], true=3
             ELSE:
          END
 
      END; wStaticSlider

      ELSE:
   ENDCASE

   IF (Widget_Info(ev.top, /Valid_ID)) THEN $
        Widget_Control, ev.top, Set_UValue=mLocal

END

;===================;
; WIDGET DEFINITION ;
;===================;

PRO CW_ColorCube
  
   HColor = bindgen(256,256)    ; Horizontal Color Map
   VColor= transpose(HColor)    ; Vertical Color Map
   SColor= bytarr(256,256)      ; Static Color Map

   wBase=Widget_Base(Title="Color Cube", /Column)
   wColorSquare = Widget_Draw(wBase,/Motion_Events, /Button_Events, $
                  XSize=256,YSize=256, UValue='wColorSquare')

   asText=['Red  ', 'Green', 'Blue ']
   wStaticColor = CW_BGroup(wBase, asText, Set_Value=2, /Exclusive, /Row, $
                  UValue='wStaticColor')
   wStaticSlider= Widget_Slider(wBase, Value=0, Minimum=0, Maximum=255, $
                  Scroll=1, Title='Static Value:', /Drag, $
                  UValue='wStaticSlider')



   
   mLocal={ wBase: wBase $
          , wColorSquare:wColorSquare $
;          , wCurColor:wCurColor $
;          , wPickColor:wPickColor $
;          , wNameColor:wNameColor $
          , wStaticColor:wStaticColor $
          , wStaticSlider:wStaticSlider $
          , HColor:HColor, VColor:VColor, SColor:SColor $
          } 
   
   Widget_Control, wBase, /Realize
   Widget_Control, wColorSquare, Get_Value=wCS
   wSet, wCS
   tv, [[[vcolor]],[[hcolor]],[[scolor]]], true=3
   Widget_Control, wBase, Set_UValue=mLocal
   XManager, 'cw_colorcube', wBase, Event_Handler='cw_colorcube_event',$
           /No_Block

END
