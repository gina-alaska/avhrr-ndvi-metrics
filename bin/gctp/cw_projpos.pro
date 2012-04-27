;
;  NAME:
;     CW_ProjPos
;
;  PURPOSE:
;     CW_ProjPos displays any of (Line, Sample), (Proj_Y, Proj_X)
;     and/or (Lat, Lon) using some converted GCTP codes
;
;  CATEGORY:
;     Compound Widgets
;
;  CALLING SEQUENCE:
;     Widget = CW_ProjPos(Parent)
;
;  INPUTS:
;     Parent:  The ID of the calling Widget
;
;  KEYWORDS:
;
;  OUTPUTS:
;     The ID of the created Widget
;
;  COMMON BLOCKS:
;     None
;
;  LIMITATIONS:
;



;===============;
; EVENT HANDLER ;
;===============;
PRO CW_ProjPos_Event, ev

   Widget_Control, ev.id, Get_UValue=UValue
   Widget_Control, ev.top, Get_UValue=mLocal

tname= Tag_Names(ev, /Structure_Name)
CASE (tname) OF
   'WIMAGE': BEGIN
      Widget_Control, mLocal.wLine, Set_Value=ev.y
      Widget_Control, mLocal.wSamp, Set_Value=ev.x
      UValue='wImage'
   END
   ELSE:
ENDCASE

;
; Which Widget is being messed with? 
;
   CASE (UValue) OF


      'wChoose': cw_ProjPos_resize, ev

      'wImage': BEGIN
ddrvalid=-1
      IF (Widget_Info(mLocal.mParent.wOpenFile, /Valid_ID)) THEN begin
         Widget_Control, mLocal.mParent.wOpenFile, Get_UValue=minfo
         ddr=minfo.ddr
ddrsize=size(ddr)
if ddrsize[0] ne 0 then ddrvalid=1
      END

if ddrvalid ne -1 then begin
         ul=ddr.ul
         pixsize=ddr.projdist
         projcode=ddr.projcode

if projcode eq 11 then begin
         Re=ddr.projcoef[0]
         Lon0=ddr.projcoef[4]/1.e6
         Lat0=ddr.projcoef[5]/1.e6

         yx=ls2yx(ev.y, ev.x, ul, pixsize)
         lonlat=lamazinv(yx.x, yx.y, lon0=d2r(lon0), $
         lat0=d2r(lat0),  fe=0., fn=0., r=re)


         Widget_Control, mLocal.wProjY, Set_Value=yx.y
         Widget_Control, mLocal.wProjX, Set_Value=yx.x
 
         Widget_Control, mLocal.wLon, Set_Value=r2d(LonLat.Lon)
         Widget_Control, mLocal.wLat, Set_Value=r2d(LonLat.Lat)

        end 
end
      END 

      ELSE:
   ENDCASE

IF (Widget_Info(ev.top, /Valid_ID)) THEN $
   Widget_Control, ev.top, Set_UValue=mLocal


END


;===============;
; WIDGET RESIZE ;
;===============;
PRO CW_ProjPos_Resize, ev
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
   YSize=mLocal.geoChoose.YSize + mLocal.geoSL.YSize*Map[0] + $
         mLocal.geoXY.YSize*Map[1] + mLocal.geoLL.YSize*Map[2]
   Widget_Control, mLocal.wBase, YSize=YSize

;
; Get position of fields based on which ones are mapped
;
   YPosSL=mLocal.geoChoose.YSize
   YPosXY=mLocal.geoChoose.YSize + mLocal.geoSL.YSize*Map[0]
   YPosLL=mLocal.geoChoose.YSize + mLocal.geoSL.YSize*Map[0] + $
          mLocal.geoXY.YSize*Map[1]

;
; Map only the selected fields
;
   Widget_Control, mLocal.wSL, YOff=YPosSL, Map=Map[0]
   Widget_Control, mLocal.wXY, YOff=YPosXY, Map=Map[1]
   Widget_Control, mLocal.wLL, YOff=YPosLL, Map=Map[2]

END 


;===================;
; WIDGET DEFINITION ;
;===================;
FUNCTION CW_ProjPos, mParent
;PRO CW_ProjPos

   cproj           ;GCTP Utilities
   Font='Courier'


   ;wBase=Widget_Base(Group_Leader=mParent.wBase)
   wBase=Widget_Base(Title='Position', Group_Leader=mParent.wBase)

   asText=['(Samp, Line)', '(Proj X, Proj Y)', '(Lon, Lat)'] 
   Map=[1,1,1]
   wChoose = CW_BGroup(wBase, asText, /NonExclusive, Row=1, Set_Value=Map, $
                    Font=Font, UValue='wChoose')
   geoChoose=Widget_Info(wChoose, /Geometry)
;
; Sample/Line Fields
;
   wSL = Widget_Base(wBase, /Row, Map=Map[0])
   wSamp = CW_Field(wSL, Title='Sample   :', Value=0, XSize=8, $
                    Font=Font, UValue='wSamp')
   wLine = CW_Field(wSL, Title='Line     :', Value=0, XSize=8, $
                    Font=Font, UValue='wLine')
   geoSL=Widget_Info(wSL, /Geo)


;
; ProjX/ProjY Fields
;
   wXY = Widget_Base(wBase, /Row, Map=Map[1])
   wProjX = CW_Field(wXY, Title='Proj_X   :', Value=0, XSize=8, $
                    Font=Font, UValue='wProjX')
   wProjY = CW_Field(wXY, Title='Proj_Y   :', Value=0, XSize=8, $
                 Font=Font, UValue='wProjY')
   geoXY=Widget_Info(wXY, /Geo)


;
; Longitude/Latitude Fields
;
   wLL = Widget_Base(wBase, /Row, Map=Map[2])
   wLon = CW_Field(wLL, Title='Longitude:', Value=0, XSize=8, $
                    Font=Font, UValue='wLon')
   wLat = CW_Field(wLL, Title='Latitude :', Value=0, XSize=8, $
                    Font=Font, UValue='wLat')
   geoLL=Widget_Info(wLL, /Geo)
   
   YSize=geoChoose.YSize + geoSL.YSize*Map[0] + $
           geoXY.YSize*Map[1] + geoLL.YSize*Map[2]

   YPosSL=geoChoose.YSize
   YPosXY=geoChoose.YSize + geoSL.YSize*Map[0]
   YPosLL=geoChoose.YSize + geoSL.YSize*Map[0] + geoXY.YSize*Map[1]


   Widget_Control, wBase, YSize=YSize

   Widget_Control, wSL, YOff=YPosSL
   Widget_Control, wXY, YOff=YPosXY
   Widget_Control, wLL, YOff=YPosLL


   mParent.wPosition=wBase
   mLocal={ mParent:mParent $
          , wBase: wBase $
          , wChoose:wChoose, geoChoose:geoChoose $
          , wSL:wSL, wSamp:wSamp, wLine:wLine, geoSL:geoSL $
          , wXY:wXY, wProjX:wProjX, wProjY:wProjY, geoXY:geoXY $
          , wLL:wLL, wLon:wLon, wLat:wLat, geoLL:geoLL $  
          , Map:Map $
          } 

   Widget_Control, wBase, Map=0
   Widget_Control, wBase, /Realize
   Widget_Control, wBase, Set_UValue=mLocal, Event_Pro='CW_ProJPos_Event'
   XManager, 'cw_projpos', wBase, Event_Handler='cw_projpos_event', /No_Block

Return, wBase
END
