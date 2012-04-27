;
;  NAME:
;     GET_FILE_INFO
;
;  PURPOSE:
;     This is a GUI for getting information about the AVHRR
;     NDVI time series data used in the metrics codes.
;     It is currently called from Open_File()
;
;  CATEGORY:
;     Application
;
;  CALLING SEQUENCE:
;     ptr=get_file_info(file)
;
;  INPUTS:
;     file -- image file name.  code looks for LAS ddr  with same root
;
;  KEYWORDS:
;
;  OUTPUTS:
;
;  COMMON BLOCKS:
;     None
;
;  LIMITATIONS:
;
;  EXTERNALS:
;

;====================;
; HANDLER DEFINITION ;
;====================;
PRO get_file_info_event, ev

   Widget_Control, ev.id, Get_UValue=UValue
   Widget_Control, ev.top, Get_UValue=mLocal


   CASE (UValue) OF
;
; Compositing Period
;
   'wdComp': BEGIN
      nComp=Widget_Info(mLocal.wdComp, /DropList_Number)
      Comp=Widget_Info(mLocal.wdComp, /DropList_Select)
      IF (Comp EQ nComp-1) THEN BEGIN
         Widget_Control, mLocal.wOther, Sensitive=1
         Widget_Control, mLocal.wdCPType, Sensitive=1
      END ELSE BEGIN
         Widget_Control, mLocal.wOther, Sensitive=0
         Widget_Control, mLocal.wdCPType, Sensitive=0
      END;
   END;wdComp

;
; Compositing Period
;
   'wdDRange': BEGIN
      nDRange=Widget_Info(mLocal.wdDRange, /DropList_Number)
      DRange=Widget_Info(mLocal.wdDRange, /DropList_Select)
      IF (DRange EQ nDRange-1) THEN BEGIN
         Widget_Control, mLocal.wMin, Sensitive=1
         Widget_Control, mLocal.wMax, Sensitive=1
      END ELSE BEGIN
         Widget_Control, mLocal.wMin, Sensitive=0
         Widget_Control, mLocal.wMax, Sensitive=0
      END
   END;wdDRange

;
; Agree to current values
;
   'wOK': BEGIN
       Widget_Control, mLocal.wNS, Get_Value=NS
       Widget_Control, mLocal.wNL, Get_Value=NL
       Widget_Control, mLocal.wNB, Get_Value=NB
       dType=Widget_Info(mLocal.wdDType, /Droplist_Select)

       Comp=Widget_Info(mLocal.wdComp, /DropList_Select)
       Widget_Control, mLocal.wOther, Get_Value=Other
       CompType=Widget_Info(mLocal.wdCPType, /DropList_Select)

       DRange=Widget_Info(mLocal.wdDRange, /DropList_Select)
       Widget_Control, mLocal.wMin, Get_Value=MinVal
       Widget_Control, mLocal.wMax, Get_Value=MaxVal
       Widget_Control, mLocal.wStartYear, Get_Value=StartYear

       Widget_Control, /Destroy, ev.top
       *mLocal.ptr={file:mlocal.file,NS:NS[0], NL:NL[0], NB:NB[0], DT:DType+1, $
                    Other:Other[0],Comp:Comp,CompType:CompType, $
                    DRange:DRange, MinVal:MinVal[0], MaxVal:MaxVal[0], $
                    StartYear:StartYear[0], bpy:-1, ddr:mLocal.ddr}


   END;wOK

   'wCancel': BEGIN
      Widget_Control, /Destroy, ev.top
       *mLocal.ptr={file:'', NS:-1, NL:-1, NB:-1, DT:-1, $
                    Other:-1,Comp:-1,CompType:-1, $
                    DRange:-1, MinVal:-1, MaxVal:-1, StartYear:-1,bpy:-1,  ddr:-1}
   END;wCancel

   ELSE:
   ENDCASE; UValue

   IF (Widget_Info(ev.top, /Valid_ID)) THEN $
        Widget_Control, ev.top, Set_UValue=mLocal


END;get_file_info_event


;===================;
; WIDGET DEFINITION ;
;===================;
FUNCTION get_file_info, file


;
; Get OS and Fontname info
;
   mOSInfo=OsInfo()
   mFont=FontGen()
   Font=mFont.Mono12m
   BoldFont=mFont.Mono12b
   BigFont=mFont.Mono18m
   BigBoldFont=mFont.Mono18b



;
; Look for DDR file and get some file info
;
   fileroot=str_sep(file, '.')
   ddrname=fileroot[0]+'.ddr'
   if (compare(findfile(ddrname) EQ ddrname, [1]))  THEN BEGIN
      ddr=Read_LAS_DDR(ddrname)
      ns = ddr.ns
      nl = ddr.nl
      nb = ddr.nb
      dtflag = ddr.dt-1
      CASE (dtflag) OF
      0: BEGIN
            CompGuess=2
            DRangeGuess=0
            MinGuess=0
            MaxGuess=200
         END
      1: BEGIN
            CompGuess=1
            DRangeGuess=2
            MinGuess=0
            MaxGuess=1023
         END
      ELSE: CompGuess=0
      ENDCASE
   END ELSE BEGIN
      ns=0
      nl=0
      nb=0
      dtflag=0
      CompGuess=0
      MinGuess=0
      MaxGuess=0
      ddr=-1
   END

  ptr = ptr_new(/allocate)

   ttf='';'courier'
;
; Define widget
;
   wBase = widget_base(/column,title='FILE INFORMATION')
   wLabel = widget_label(wBase,value=file)
   wBaseFrame = widget_base(wBase,/frame,/col)


;
; File Dimension Parameters
;
   wBaseFD=Widget_Base(wBaseFrame,/Row)
   wNS=CW_Field(wBaseFD, Title=' Samples:', Value=ns, /Integer, $
                XSize=6, Font=BigFont)
   wNL=CW_Field(wBaseFD, Title='   Lines:', Value=nl, /Integer, $
                XSize=6, Font=BigFont)
   wNB=CW_Field(wBaseFD, Title='   Bands:', Value=nb, /Integer, $
                XSize=6, Font=BigFont)

;
; Data Type DropList
;
   asText=['Byte', 'Integer', 'Long', 'Float']
   wLabel = Widget_Label(wBaseFD, value='  Data Type:',Font=BigFont)
   wdDtype=Widget_DropList(wBaseFD, Value=asText, UValue='wdDType', $
                Font=BigFont)
   Widget_Control, wdDtype, Set_DropList=dtflag

;
; Compositing Period DropList
;
   wBaseCP=Widget_Base(wBaseFrame, /Row)
   asText=['Weekly       ( 7-day x 52/yr)', $
           'Dekadal      (10-day x 36/yr)', $
           'Bi-weekly    (14-day x 26/yr)', $
           'Semi-monthly (15-day x 24/yr)', $
           'Other...']
   wLabel=Widget_Label(wBaseCP, Value='Compositing Period:', Font=BigFont)
   wdComp=Widget_DropList(wBaseCP, Value=asText, UValue='wdComp',Font=BigFont)
   Widget_Control, wdComp, Set_DropList=CompGuess
   wOther=CW_Field(wBaseCP, Title='Other:', /Integer,XSize=4, Font=BigFont )
   Widget_Control, wOther, Sensitive=0
   asText=['Days', 'Bands/yr']
   wdCPType=Widget_DropList(wBaseCP, Value=asText, UValue='wdCPType',$
                Font=BigFont)
   Widget_Control, wdCPType, Sensitive=0

;
; Data Range DropList
;
   wBaseDR=Widget_Base(wBaseFrame, /Row)
   asText=['0 to 200', '0 to 255', '0 to 1023', '-1000 to 1000', 'Other...']
   wLabel=Widget_Label(wBaseDR, Value='Data Range:', Font=BigFont)
   wdDRange=Widget_DropList(wBaseDR, Value=asText, UValue='wdDRange', $
                Font=BigFont)
   Widget_Control, wdDRange, Set_DropList=DRangeGuess
   wMin=CW_Field(wBaseDR, Title='Min:', /Integer,XSize=5, $
                Font=BigFont, Value=0 )
   wMax=CW_Field(wBaseDR, Title='Max:', /Integer,XSize=5, $
                Font=BigFont, Value=0 )
   Widget_Control, wMin, Sensitive=0
   Widget_Control, wMax, Sensitive=0
;   Widget_Control, wMin, Set_Value=MinGuess
;   Widget_Control, wMax, Set_Value=MaxGuess

;
; Starting year
;
   wStartYear=CW_Field(wBaseDR, Title='Starting Year', Value=0, $
          /Integer, XSize=5,  Font=BigFont)


;
; OK or Cancel?
;
   wOkCancel=Widget_Base(wBase,/Row,/Base_Align_Center)
   mGeo=Widget_Info(wBase, /Geometry)

   wOK = widget_button(wOkCancel,value='OK',UValue='wOK', XSize=mGeo.XSize/2)
   wCancel = widget_button(wOkCancel,value='Cancel',UValue='wCancel', $
                XSize=mGeo.XSize/2)
   exit=0
   mLocal={ wBase:wBase $
       , wNS:wNS $
       , wNL:wNL $
       , wNB:wNB $
       , wdDType:wdDType $
       , wdComp:wdComp $
       , wOther:wOther $
       , wdCPType:wdCPType $
       , wdDRange:wdDRange $
       , wMin:wMin $
       , wMax:wMax $
       , wStartYear:wStartYear $
       , wOK:wOK $
       , wCancel:wCancel $
       , ptr:ptr $
       , ddr:ddr $
       , file:file $
       }

   Widget_Control,/Realize,wBase,tlb_set_xoffset=30,tlb_set_yoffset=30
   Widget_Control, wBase, Set_UValue=mLocal, Event_Pro='get_file_info_event'

  XManager,'get_file_info',wBase,event_handler='get_file_info_event'

;return, mLocal
return, *ptr
END;get_file_info
