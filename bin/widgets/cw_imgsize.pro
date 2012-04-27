;  NAME:NDLER DEFINITION ;
;     CW_ImgSize
;
;  PURPOSE:
;     CW_ImgSize generates fields for Number of Samples, Lines, Bands, 
;     a CW_Select droplist for data type and optionally a CW_Select
;     droplist for time-series dekadal/biweekly
;     
;
;  CATEGORY:
;     Compound Widgets
;
;  CALLING SEQUENCE:
;     Widget = CW_ImgSize(Parent)
;
;  INPUTS:
;     Parent:  The ID of the calling Widget
;
;  KEYWORDS:
;     UVALUE: User Value
;
;  OUTPUTS:
;     The ID of the created Widget
;
;  COMMON BLOCKS:
;     None
;  LIMITATIONS:
;====================;
; HANDLER DEFINITION ;
;====================;
;PRO CW_ImgSize_EVENT, ev
;
;END; CW_ImgSize_EVENT
;====================;
; GET VALUE          ;
;====================;

;====================;
; SET VALUE          ;
;====================;

;====================;
; WIDGET DEFINITION  ;
;====================;

FUNCTION CW_ImgSize, Parent, TIMESERIES=TIMESERIES
;mFont=fontgen()
;font=mfont.mono12m
font=''
wBase=Widget_Base(Parent, /Row);, $
;                  Func_Get_Value='CW_ImgSize_GET_VALUE', $
;                  Pro_Set_Value='CW_ImgSize_SET_VALUE') 


wSamp = CW_Field(wBase, Title='Samples', Value=ns, /Integer, XSize=6,font=font)
wLine = CW_Field(wBase, Title='Lines', Value=nl, /Integer, XSize=6,font=font)
wBand = CW_Field(wBase, Title='Bands', Value=ns, /Integer, XSize=6,font=font)
asText=['Byte', 'Integer', 'Long', 'Real']
wDT   = CW_Select(wBase, Value=asText, start=0, Title='Data',font=font)

IF (KEYWORD_SET(TIMESERIES)) THEN BEGIN
   asText=['Bi-Weekly', 'Dekadal', 'Weekly', 'Daily']
   wBPY=CW_Select(wBase, Value=asText, Start=0, Title=' ',font=font)
END


END; CW_ImgSize

