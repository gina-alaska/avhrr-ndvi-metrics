DIR=1
aDIR=['X', 'Y']

file='~/idl/bin/Vegetation/mtf.csv'
;file='~/idl/bin/Vegetation/mtfmir.dat'
m=readtab(file, 8, 30, 0, sep=',')
        CurDev=!D.Name
;set_plot, 'X'
;        Set_Plot, 'PS'

;Device, file='VegPixSize.ps', /landscape

; DO AVHRR Pixel Size Model
   avhrrsize, mss, angle, msa

   fe=1.0
   mult=6
   hires=20.
   scale=50.
   n =128
   n2=n/2
   maxang=62L

   freq  =[-fe/2., -fe/4., -fe/8., 0., -fe/8., -fe/4., -fe/2.]
   f=findgen(n)/n2 -1.
   x=findgen(n)

model=m

   window,0, xs=700, ys=700
!p.multi=[0,2,2]
!p.font=0
;set_plot, 'ps'
;Device, file='pixsize.ps', XOffset=1, YOffset=1, /Inches, /Portrait, YSize=8

FOR iband=1,4 DO BEGIN
   band = iband
   bidx=where(m.data(0,*) EQ band, na)


   mtfx  =fltarr(na,7)
   mtfxfit =fltarr(na,7)

   Ax    =fltarr(na,3)
   Bx    =fltarr(na,3)

   psfx  =fltarr(na,n)
   psfxf =fltarr(na,n) 
   psfxmod=fltarr(na,n)

   mtfxmod =fltarr(na, 7)
   mtfxmodf=fltarr(na, 7)

;model mtf in angle direction      


for f = 2+DIR,6+DIR,2 do begin  ; X DIRECTION
   c=m.data[f,bidx]*0+1
   gfitc = polyfitw(m.data[1,bidx], m.data[f,bidx],c,4,gfit)
   model.data[f,bidx]=gfit
end; f 

; set up full mtf array
   FOR i = 0, na-1 DO $
      mtfx[i,*] = mirror([m.data(2+DIR,bidx[0]+i), m.data(4+DIR,bidx[0]+i),$
                          m.data(6+DIR,bidx[0]+i)], center=1.0, /right)

; set up full modeled mtf array
   FOR i = 0, na-1 DO $
      mtfxmod[i,*] = mirror([model.data(2+DIR,bidx[0]+i), model.data(4+DIR,bidx[0]+i),$
                          model.data(6+DIR,bidx[0]+i)], center=1.0, /right)


   FOR i = 0,na-1 DO BEGIN

      mtfxfit[i,*] = gaussfit(freq, mtfxmod[i,*], coef, nterms=3, est=[1., 0., 0.5])
      ;mtfxfit[i,*] = gaussfit(freq, mtfx[i,*], coef, nterms=3, est=[1., 0., 0.5])
      Ax[i,*] = coef

      psfx[i,*] = exp(-2*(!pi*Ax[i,2]*(x-n2)/(scale))^2)

      psfxf[i,*] = gaussfit(x, psfx[i,*], coef, nterms=3, est=[1., n2, scale/2.])
      Bx[i,*] = coef


;       print, m.data[1,bidx[0]+i], mult*Bx[i,2]


   END; FOR i

w=fltarr(na)+1

pcoef=polyfitw(m.data[1, bidx], hires*mult*Bx[*,2],w, 2,pfit)
xangles=findgen(2*maxang+1)-maxang
pfit=pcoef[0]+pcoef[1]*angle+pcoef[2]*angle*angle
;pfit=pcoef[0]+pcoef[1]*xangles+pcoef[2]*xangles*xangles

bloom=1/cos(d2r(angle))  ;offnadir(xangles, 832, 1.1)
;bloom=1/cos(d2r(xangles))  ;offnadir(xangles, 832, 1.1)
scalefact=min(pfit)/1.1/bloom
;scalefact=min(pfit)/min(mss)

;
; Generate output pixel size plots
;

;   plot, m.data[1,bidx], hires*mult*Bx[*,2]/scalefact, psym=4, $
   plot, m.data[1,bidx], hires*mult*Bx[*,2]/min(pfit)/cos(d2r(m.data[1, bidx]))*1.1, psym=4, $
     xrange=[min(angle), max(angle)],/xstyle,$
     yrange=[0, 7], /ystyle,$
     title='Band '+strcompress(iband), $
     xtitle='Viewer Zenith Angle, (deg)', ytitle='Pixel Size, (km)', /nodata

   ;oplot, la2vz(xangles, altitude=835000), pfit/scalefact   /min(pfit/scalefact)   * 1.1
   oplot, angle, pfit/scalefact   /min(pfit/scalefact)   * 1.1


   oplot, angle, mss, line=1

oplot, la2vz(xangles, altitude=835000),roundstretch(xangles, 835000.)*1.1, line=2 


   plots, [-44,-34], [6,6], line=0
   xyouts, -32, 6, 'VEGETATION w/ MTF' , charsize=.8
   plots, [-44,-34], [5.5,5.5], line=2
   xyouts, -32, 5.5, 'VEGETATION w/o MTF', charsize=.8
   plots, [-44,-34], [5.0,5.0], line=1
   xyouts, -32, 5.0, 'AVHRR w/o MTF' , charsize=.8


end;iband
;device, /close
set_plot, 'x'

;   window,1, xs=700, ys=700

  
;
; Generate MTF plots
;
   set_plot, 'ps'
   Device, file='AngleFit'+aDIR[DIR]+'.ps', XOffset=1, YOffset=1, /Inches, /Portrait, $
         YSize=7, XSize=7 ;, /Encapsulated

   Lines=[0,2,1] 

   FOR iband = 1,4 DO BEGIN
      band=iband
      bidx=where(m.data(0,*) EQ band, na)
      plot, m.data[1, bidx], m.data[2+DIR,bidx], psym=4, $
        xrange=[-maxang, maxang], /xstyle, /nodata, $
        Title='Vegetation Channel'+strcompress(iband)+' '+aDir[DIR], $
        xtitle='Off Nadir Angle, (deg)', $
        ytitle='MTF('+aDir[DIR]+') Relative Value'

 

      FOR f = 2+DIR,6+DIR,2 DO BEGIN
         oplot, m.data[1,bidx], m.data[f,bidx], psym=4
;         gfitc = gfit(m.data[1,bidx], m.data[f,bidx],c,nterms=3, est=[1,0,30])

         c=m.data[f,bidx]*0+1
         gfitc = polyfitw(m.data[1,bidx], m.data[f,bidx],c,2,gfit)
         oplot, m.data[1,bidx], gfit, line =Lines[f/2-1]

      end; FOR f 

      plots, [-40,-30], [.15,.15], line=0
      xyouts, -28, .15, 'fc/8' 
      plots, [-40,-30], [.10,.10], line=2
      xyouts, -28, .10, 'fc/4' 
      plots, [-40,-30], [.05,.05], line=1
      xyouts, -28, .05, 'fc/2' 
   
   end; FOR iband
device, /close
Set_Plot, CurDev

END

