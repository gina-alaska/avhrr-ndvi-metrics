pro draw_plot_raw_interp_smooth, var_sav_file
;this program read variable save file, darw three simple plots.
;use new graphic function to draw plot on x window, then save it in image file such as png file.

var_sav_file='/center/w/jzhu/nps/avhrr/usgs/2012/avhrr-2012-436-695-raw-interp-smooth.sav'

restore, filename=var_sav_file

;set_plot,'ps'
;fileps='/center/w/jzhu/nps/avhrr/usgs/2012/smooth.ps'
;!p.charsize=0.8
;device,/inches,xsize=7,ysize=5,xoffset=0.5,yoffset=1,$
;filename=fileps, /portrait, /color,bits_per_pixel=8
;plot,tmp_smooth, title='!6Smoothed NDVI Time Series', xtitle='Index of 7-day composite',ytitle='NDVI, scaled to [0-200]'
;device,/close

;use ne graphic function to draw plot on X window.


plt1=plot(tmp_ndvi,title='Raw NDVI Time Series', 'black2',name='NDVI', yrange=[0,200], xtitle='Index of 7-day composite', ytitle='NDVI scaled to [0, 200]')

;symb1=symbol(ends.x[0],ends.y[0],'star',/DATA, sym_color='red',sym_size=2,label_string='crossover')

plt2=plot(tmp_ndvi_interp,title='Interpolated NDVI Time Series','black2', yrange=[0,200], xtitle='Index of 7-day composite', ytitle='NDVI scaled to [0, 200]')

;symb2=symbol(ends.x[1],ends.y[1],'triangle',/DATA, sym_color='red',sym_size=2,label_string='threshold')

;leg=legend(target=[plt1,plt2],/AUTO_TEXT_COLOR,POSITION=[ 11, 0.75],/DATA )

plt2=plot(tmp_smooth,title='Smoothed NDVI Time Series','black2', yrange=[0,200], xtitle='Index of 7-day composite', ytitle='NDVI scaled to [0, 200]')


end

