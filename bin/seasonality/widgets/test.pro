PRO test

wBase=Widget_Base(Title='TEST')
   @symbols_bm
   Symbols_BM=[ [[none_bm]], [[cross_bm]],[[asterisk_bm]], [[point_bm]], [[diamond_bm]], $
            [[triangle_bm]], [[square_bm]], [[x_bm]] ]
;symbols_bm=['a','b','c','d','e','f','g','h']
tf='-adobe-courier-medium-r-normal--12-120-75-75-m-70-iso8859-1'
x=cw_select(wbase,value=symbols_bm, start=3, title='Symbols', font=tf)

Widget_Control, wbase, /Realize
end

