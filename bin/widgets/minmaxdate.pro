PRO MinMaxDate_event, event

END

PRO MinMaxDate

FieldWidth=6

wBase = Widget_Base(Title="Date Range", /column, $
                    Group_Leader=mParent.wBase)

wFMinDate = CW_Field(wBase, Title="Start Date",$
                     XSize=FieldWidth)
wFMaxDate = CW_Field(wBase, Title="  End Date",$
                     XSize=FieldWidth)

wBDone = Widget_Button(wBase, Value="Done")


Widget_Control, wBase, /Realize

XManager, 'MinMaxDate', wBase, No_Block=No_Block

END
