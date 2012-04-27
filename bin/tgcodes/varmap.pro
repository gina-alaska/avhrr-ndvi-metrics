;PRO   varmap

imgdim=94
chipdim=5
vardim = imgdim-(chipdim-1)

nvarimg = fltarr(vardim,vardim)
tvarimg = fltarr(vardim,vardim)

readone, "/sg1/sab1/rogness/work/tgreg/tg94reg/tg03182221reg.img",c,1,imgdim
;readone, "/sg1/sab1/rogness/work/tgreg/tg94reg/tg02152158reg.img",c,1,imgdim
;readone, "/sg1/sab1/rogness/work/tgreg/tg94reg/tg06202315reg.img",c,1,imgdim
;readone, "/sg1/sab1/rogness/work/atmo/nb94/nb03142311.img",c,1,imgdim

t4=getchip(c,0,3,imgdim)
t5=getchip(c,0,4,imgdim)
ndvi=getchip(c,0,5,imgdim)
t=tavhrr(t4,t5,4)

for i = 0, vardim-1  do begin
  for j = 0, vardim-1 do begin
    nchip = imgcopy(ndvi, i,j,chipdim, chipdim)
    nvarimg(i,j) = (stdev(nchip))
    tchip = imgcopy(t, i,j,chipdim, chipdim)
    tvarimg(i,j) = (stdev(tchip))
  endfor
endfor

window, 2, xs=vardim, ys=vardim, xp=1200, yp=900, title='ND'
tvscl, nvarimg
window, 3, xs=vardim, ys=vardim, xp=1200, yp=770, title='T'
tvscl, tvarimg

end
