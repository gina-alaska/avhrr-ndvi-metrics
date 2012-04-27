PRO PlotImgWithBox, data, xser, yser, xmin,xmax,ymin,ymax
  imageplot, alog(data+1), xser, yser
  oplot, [xmin,xmin],[ymin,ymax], line = 0, color = rgb(255,200,0)
  oplot, [xmax,xmax],[ymin,ymax], line = 0, color = rgb(255,200,0)
  oplot, [xmin,xmax],[ymin,ymin], line = 0, color = rgb(255,200,0)
  oplot, [xmin,xmax],[ymax,ymax], line = 0, color = rgb(255,200,0)
end



PRO PlotDataWithBox, data1, data2, xmin, xmax, ymin,ymax, $
       xrange = xrange, yrange = yrange

  plot, data1, data2, psym=3, yrange = yrange, $
        xrange=xrange, /xstyle,/ystyle
  oplot, [xmin,xmin],[ymin,ymax], line = 0, color = rgb(255,200,0)
  oplot, [xmax,xmax],[ymin,ymax], line = 0, color = rgb(255,200,0)
  oplot, [xmin,xmax],[ymin,ymin], line = 0, color = rgb(255,200,0)
  oplot, [xmin,xmax],[ymax,ymax], line = 0, color = rgb(255,200,0)
end
  



PRO adjustminmax

minmax = "okminmax.dat"
list = "cloudlist"

readlist, list, nim, path, file

openr, 1, minmax
mmdata = fltarr(4, nim)
readf,1,mmdata
close,1

openw, LUN, minmax+".upd",/GET_LUN



for i = 0, nim-1  DO BEGIN
  print, "READING :", file(i)

  filepath = path(0)+file(i)

  data = imgread3(filepath, 512,512,11, /i2)
  datau = avhrrunscale(data, /i2, /ref)

  NDmax = mmdata(0,i)
  NDmin = mmdata(1,i)
  Tmax = mmdata(2,i)
  Tmin = mmdata(3,i)

  
  t4 = datau(*,*,3)
  t5 = datau(*,*,4)
  nd = datau(*,*,5)
  cl = datau(*,*,10)
  t = tavhrr(t4, t5, 4)

  tmp = Get_Tmax(t, nd, cl, Tmin, NDmin, WarmCurve)
  uidx = uniqpair(t, nd)

  clidx = where(cl eq 0)
  uclidx = uniqpair(t(clidx), nd(clidx))

  histo = myhist2d(t, nd, xser, yser, $
        bin1 = 1, bin2 = 0.02, min1 = 270, min2 = -0.4,$
        max1 = 350, max2 = 0.8)

  window,1
  plotdatawithbox, t(uidx), nd(uidx), tmin, tmax, ndmin, ndmax,$
    xrange = [270,350], yrange=[-.4, .8]
  oplot, t(clidx(uclidx)), nd(clidx(uclidx)), psym=3, color=rgb(255,200, 0)

  window,0
  plotimgwithbox, histo, xser, yser, tmin, tmax, ndmin, ndmax
  oplot, WarmCurve(0,*), WarmCurve(1,*), line=0,color=rgb(255,200,0)
  contour, alog(histo+1), xser, yser, color=rgb(255,0,0), /noerase, $
           xrange=[270, 350], yrange=[-0.4, 0.8], xstyle=5, ystyle=5

  !err =0

  while !err ne 4 DO BEGIN

  
    if(!err ne 4) THEN BEGIN
      print, "Select point"
      print, "Left Button : x , Middle Button : y , Right Button : exit"
  
      cursor, x, y, /wait
      wait = 1

      CASE !err OF
        0: !err = 4
        1: BEGIN
             mindiff = abs(x-tmin)
             maxdiff = abs(x-tmax)
        
             tmin = tmin*(maxdiff lt mindiff) + x*(maxdiff ge mindiff) 
             tmax = tmax*(maxdiff ge mindiff) + x*(maxdiff lt mindiff) 
  ;      tmp = Get_Tmax(t, nd, cl, Tmin, NDmin, WarmCurve)

             wset,1
             plotdatawithbox, t(uidx), nd(uidx), tmin, tmax, ndmin, ndmax,$
                xrange = [270,350], yrange=[-.4, .8]
             oplot, t(clidx(uclidx)), nd(clidx(uclidx)), psym=3, $
                color=rgb(255,200, 0)

             wset,0
             plotimgwithbox, histo, xser, yser, tmin, tmax, ndmin, ndmax
             oplot, WarmCurve(0,*), WarmCurve(1,*), line=0,color=rgb(255,200,0)
            contour, alog(histo+1), xser, yser, color=rgb(255,0,0), /noerase, $
               xrange=[270, 350], yrange=[-0.4, 0.8], xstyle=5, ystyle=5
           END
        2: BEGIN
             mindiff = abs(y-tmin)
             maxdiff = abs(y-tmax)
        
             ndmin = ndmin*(maxdiff lt mindiff) + y*(maxdiff ge mindiff) 
             ndmax = ndmax*(maxdiff ge mindiff) + y*(maxdiff lt mindiff) 
  ;      tmp = Get_Tmax(t, nd, cl, Tmin, NDmin, WarmCurve)

             wset,1
             plotdatawithbox, t(uidx), nd(uidx), tmin, tmax, ndmin, ndmax,$
               xrange = [270,350], yrange=[-.4, .8]
             oplot, t(clidx(uclidx)), nd(clidx(uclidx)), psym=3, $
               color=rgb(255,200, 0)

             wset,0
             plotimgwithbox, histo, xser, yser, tmin, tmax, ndmin, ndmax
             oplot, WarmCurve(0,*), WarmCurve(1,*), line=0,color=rgb(255,200,0)
             contour, alog(histo+1), xser, yser, color=rgb(255,0,0), /noerase, $
               xrange=[270, 350], yrange=[-0.4, 0.8], xstyle=5, ystyle=5

           END
        else:
      ENDCASE

    endif
  endwhile

print, " TMax = ", TMax
print, " TMin = ", TMin
print, " NDMax = ", NDMax
print, " NDMin = ", NDMin

printf,LUN, file(i), "   ",NDmax, NDmin, Tmax, Tmin

endfor

FREE_LUN, LUN
END
