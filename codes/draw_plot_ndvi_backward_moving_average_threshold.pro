pro draw_plot_ndvi_backward_moving_average_threshold, var_sav_file
;this program read variable save file wjich includes ndvi,fma,bma,start,end, darw ndvi+crossover+threshold mark for SOS or EOS.
;This use IDL graphic function to draw plot on window system, then save them as some kind of image file such as png file.

var_sav_file='/center/w/jzhu/nps/avhrr/usgs/2012/avhrr-2012-436-695-sos-eos.sav'

restore, filename=var_sav_file

;set_plot,'ps'

;fileps='/center/w/jzhu/nps/avhrr/usgs/2012/sos.ps'
;!p.charsize=0.8

;device,/inches,xsize=7,ysize=5,xoffset=0.5,yoffset=1,$
;filename=fileps, /portrait, /color,bits_per_pixel=8

num=n_elements(ndvi)

x=findgen(num)

;plot,ndvi, title='!6 Determination of Start of Season (SOS)', xtitle='Index of 7-day composite',ytitle='NDVI, scaled to [0-1]'

plt1=plot(x,ndvi,title='Determination of day of End of Season (EOS)', 'r2',name='NDVI', xtitle='Index of 7-day composite', ytitle='NDVI scaled to [0, 1]')

symb1=symbol(ends.x[0],ends.y[0],'star',/DATA, sym_color='red',sym_size=2,label_string='crossover')

plt2=plot(x,bma,'b--2',/OVERPLOT,name='Bwd Moving Avg')

symb2=symbol(ends.x[1],ends.y[1],'triangle',/DATA, sym_color='red',sym_size=2,label_string='threshold')


leg=legend(target=[plt1,plt2],/AUTO_TEXT_COLOR,POSITION=[ 11, 0.75],/DATA )


;device,/close

;write_png, filename,tvrd()

end

