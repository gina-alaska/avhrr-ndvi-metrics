;---------------------------------------------------------------------------
; Author: Manuel J. Suarez
; $RCSfile$
; $Revision$
; Orig: 1999/05/27 16:54:45
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
PRO CW_CoverType_Event, ev
   Widget_Control, ev.top, Get_UValue=mLocal

        
   tagname= Tag_Names(ev, /Structure_Name)
   CASE (tagname) OF
      'WCOVERMOTION': BEGIN
         Widget_Control, mLocal.wCurrentLine, Set_Value=ev.y
         Widget_Control, mLocal.wCurrentSamp, Set_Value=ev.x
         Widget_Control, mLocal.wCurrentValu, Set_Value=ev.value
         Widget_Control, mLocal.wCover, Set_Value=ev.cover
      END
      'WCOVERSELECT': BEGIN
         Widget_Control, mLocal.wLastLine, Set_Value=ev.y
         Widget_Control, mLocal.wLastSamp, Set_Value=ev.x
         Widget_Control, mLocal.wLastValu, Set_Value=ev.value
      END
      ELSE:
   ENDCASE

   



   Widget_Control, ev.top, Set_UValue=mLocal
END
;===============;
; WIDGET RESIZE ;
;===============;
PRO CW_CoverType_Resize_Event, ev
;
; This section of the code resizes the widget based on which buttons
; are selected.
;
   Widget_Control, ev.id, Get_UValue=UValue
   Widget_Control, ev.top, Get_UValue=mLocal

;
; Find out which buttons are selected
;
   Widget_Control, mLocal.wChoose, Get_Value=Map
   mLocal.Map=Map

;
; Get the overall size of the resized widget
;
   YSize=mLocal.geoChoose.YSize + mLocal.geoCurrentSL.YSize*Map[0] + $
         mLocal.geoLastSL.YSize*Map[1] + mLocal.geoCoverType.YSize*Map[2]
   Widget_Control, mLocal.wBase, YSize=YSize

;
; Get position of fields based on which ones are mapped
;
   YPosCurrentSL=mLocal.geoChoose.YSize
   YPosLastSL=mLocal.geoChoose.YSize + mLocal.geoCurrentSL.YSize*Map[0]
   YPosCoverType=mLocal.geoChoose.YSize + mLocal.geoCurrentSL.YSize*Map[0] + $
          mLocal.geoLastSL.YSize*Map[1]

;
; Map only the selected fields
;
   Widget_Control, mLocal.wCurrentSL, YOff=YPosCurrentSL, Map=Map[0]
   Widget_Control, mLocal.wLastSL, YOff=YPosLastSL, Map=Map[1]
   Widget_Control, mLocal.wCoverType, YOff=YPosCoverType, Map=Map[2]

END


;===================;
; WIDGET DEFINITION ;
;===================;
FUNCTION CW_CoverType, wParent

   Font='Courier'


   wBase=Widget_Base(Title='Cover Type', Group_Leader=wParent)
   asText=['Current', 'Last', 'Cover Type']
   Map=[1,1,1]
   wChoose = CW_BGroup(wBase, asText, /NonExclusive, Row=1, Set_Value=Map, $
                    Font=Font, UValue='wChoose')
   geoChoose=Widget_Info(wChoose, /Geometry)


; ========= Current Position =========
   wCurrentSL = Widget_Base(wBase, /Row, Map=Map[0])
   wCurrentSamp = CW_Field(wCurrentSL, Title='Sample    :', Value=0, XSize=8, $
                    Font=Font, FieldFont=Font, /NoEdit)
   wCurrentLine = CW_Field(wCurrentSL, Title='Line     :', Value=0, XSize=8, $
                    Font=Font, FieldFont=Font, /NoEdit)
   wCurrentValu = CW_Field(wCurrentSL, Title='Value    :', Value=0, XSize=8, $
                    Font=Font, FieldFont=Font, /NoEdit)
   geoCurrentSL=Widget_Info(wCurrentSL, /Geo)


; ========= Last Position =========
   wLastSL = Widget_Base(wBase, /Row, Map=Map[1])
   wLastSamp = CW_Field(wLastSL, Title='Sample    :', Value=0, XSize=8, $
                    Font=Font, FieldFont=Font, /NoEdit)
   wLastLine = CW_Field(wLastSL, Title='Line     :', Value=0, XSize=8, $
                    Font=Font, FieldFont=Font, /NoEdit)
   wLastValu = CW_Field(wLastSL, Title='Value    :', Value=0, XSize=8, $
                    Font=Font, FieldFont=Font, /NoEdit)
   geoLastSL=Widget_Info(wLastSL, /Geo)


; ========= Cover Type =========
   wCoverType = Widget_Base(wBase, /Row, Map=Map[2])
   wCover = CW_Field(wCoverType, Title='Cover Type:', Value='', XSize=52, $
                    Font=Font, FieldFont=Font, /NoEdit)
   geoCoverType=Widget_Info(wCoverType, /Geo)


; Get Starting Size
   YSize=geoChoose.YSize + geoCurrentSL.YSize*Map[0] + $
           geoLastSL.YSize*Map[1] + geoCoverType.YSize*Map[2]

   YPosCurrentSL=geoChoose.YSize
   YPosLastSL=geoChoose.YSize + geoCurrentSL.YSize*Map[0]
   YPosCoverType=geoChoose.YSize + geoCurrentSL.YSize*Map[0] + geoLastSL.YSize*Map[1]


   Widget_Control, wChoose, XSize=geoCurrentSL.XSize
   Widget_Control, wBase, YSize=YSize

   Widget_Control, wCurrentSL, YOff=YPosCurrentSL
   Widget_Control, wLastSL, YOff=YPosLastSL
   Widget_Control, wCoverType, YOff=YPosCoverType


   mLocal={ wParent:wParent $

          , wBase: wBase $

          , wChoose:wChoose $
          , geoChoose:geoChoose $

          , wCurrentSL:wCurrentSL $
          , wCurrentSamp:wCurrentSamp $
          , wCurrentLine:wCurrentLine $
          , wCurrentValu:wCurrentValu $
          , geoCurrentSL:geoCurrentSL $

          , wLastSL:wLastSL $
          , wLastSamp:wLastSamp $
          , wLastLine:wLastLine $
          , wLastValu:wLastValu $
          , geoLastSL:geoLastSL $

          , wCoverType:wCoverType $
          , wCover:wCover $
          , geoCoverType:geoCoverType $

          , Map:Map $
          }

   Widget_Control, wBase, Map=0
   Widget_Control, wBase, /Realize
   Widget_Control, wBase, Set_UValue=mLocal, Event_Pro='CW_CoverType_Event'
   XManager, 'cw_covertype', wBase, Event_Handler='cw_CoverType_event', /No_Block
   XManager, 'cw_covertype', wChoose, Event_Handler='cw_CoverType_Resize_event', /No_Block

Return, wBase

END
