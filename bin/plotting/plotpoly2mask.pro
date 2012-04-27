FUNCTION PlotPoly2Mask, data1, data2

;
;  This function allows the user to select a polygon from the
;  plot of DATA2 vs DATA1 and generate a mask of the bounded
;  plot data into the image data space.
;


DataSize = Size(Data1)
XDim = DataSize(1)
YDim = DataSize(2)

!order=0
pickpolygon, xloc, yloc, /data
!order=1
print, "DONE WITH PICK POLYGON"


minx = min(xloc)
miny = min(yloc)
maxx = max(xloc)
maxy = max(yloc)

n = n_elements(xloc)

refx = 1.5*maxx
refy = 1.5*maxy



minboxidx = where( data1 ge minx  AND  data1 le maxx AND $
                   data2 ge miny  AND  data2 le maxy, nminboxidx)

uniqidx = uniqpair(data1(minboxidx), data2(minboxidx))
nUniqIdx = n_elements(uniqidx)


ROIplot = intarr(nUniqIdx)
msk = bytarr(XDim,YDim)

for iuniq = 0, nUniqIdx-1 DO BEGIN
   data1tmp = data1(minboxidx(uniqidx(iuniq)))
   data2tmp = data2(minboxidx(uniqidx(iuniq)))

if (iuniq mod 100 EQ 0) then print, "IUNIQ = ",IUNIQ

      scount = 0
      for is = 1, n-1 do begin

         intersect, xloc(is-1), yloc(is-1), xloc(is), yloc(is), $
                    data1tmp, data2tmp, refx,refy, XintPts, YIntPts, IntPtsC

         scount = scount + (IntPtsC mod 2)

      endfor

      ROIplot(iuniq) = scount mod 2
      
      if(scount mod 2) then BEGIN
         mskidx = where(data1 eq data1tmp  AND  data2 eq data2tmp)
         msk(mskidx) = 1
      endif      
      

endfor


RETURN, msk

end
