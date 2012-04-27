PRO CalcMetrics_event, ev

Widget_Control, ev.id, Get_UValue=UValue
Widget_Control, ev.top, Get_UValue=mLocal

print, UValue
CASE (UValue) OF

   'wButton0': BEGIN
         Print, 'w0 pushed'
i = 0
         Widget_Control, mLocal.wField(i), SET_VALUE=0
         END
   'wButton1': BEGIN
         Print, 'w1 pushed'
i=1
         Widget_Control, mLocal.wField(i), SET_VALUE=1
         END
   'wButton2': BEGIN
         Print, 'w2 pushed'
i=2
         Widget_Control, mLocal.wField(i), SET_VALUE=2
         END
   else:
endcase

Widget_Control, ev.top, Set_UValue=mLocal
END

;========================
; WIDGET DEFINITION
;========================

FUNCTION CalcMetrics, mParent
;PRO CalcMetrics


wBase = Widget_Base(Title="Calculate Metrics", /Column, $
                    Group_Leader=mParent.wBase)

aButText = ['Time of SOS       ', $
            'NDVI at SOS       ', $
            'Time of EOS       ', $
            'NDVI at EOS       ', $
            'Rate of Greenup   ', $
            'Rate of Senescence', $
            'Integrated NDVI   ',$
            'Time of Max NDVI  ', $
            'Maximum NDVI      ', $
            'Range of NDVI     ', $
            'Length of Season  ']

naButText = n_Elements(aButText)
wButField = lonarr(naButText)
wButton = lonarr(naButText)
wField = lonarr(naButText)

for i = 0,naButText-1  DO BEGIN

wButField(i) = Widget_Base(wBase, /Row)
;wButton(i) = Widget_Button(wButField(i), Value=aButText(i), uvalue='wButton'+strtrim(i,2))
wField(i) = CW_Field(wButField(i), title=aButText(i))

end

Widget_Control, wBase, /Realize

;mParent=-1L
mParent.wCalcMetrics = wBase
mLocal = {mParent: mParent, $
          wBase: wBase, $
          wButton:wButton, wField:wField $
         }

Widget_Control, wBase, Set_UValue=mLocal, Event_Pro='CalcMetrics_event'
XManager, 'calcmetrics', wBase, Event_Handler='calcmetrics_event', /No_Block

Return, wBase

END
