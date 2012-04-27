PRO BoxPlot, Data, Title=TITLE, PS=PS,IQR=IQR

CurDev=!D.Name
IF(KEYWORD_SET(TITLE) EQ 0) then Title=''
IF(KEYWORD_SET(PS) NE 0) then BEGIN
   Set_Plot, 'PS'
   Device, File=PS 
END
IF(KEYWORD_SET(IQR) NE 0) THEN BEGIN
data(0,*)=data(2,*)-1.5*(data[3,*]-data[1,*])
data(4,*)=data(2,*)+1.5*(data[3,*]-data[1,*])
END



dSize=size(Data)
if dsize[0] EQ 2 then nseries=dsize[dsize[0]] else nseries=1

dmax=max(Data)
dmin=min(Data)
print, data

plot, data, /nodata, XRange=[0,nseries+1], YRange=[floor(dmin), ceil(dmax)],$
      Title=Title


for i=1,nseries do begin
   imin=data[0,i-1]
   q25=data[1,i-1]
   mid=data[2,i-1]
   q75=data[3,i-1]
   imax=data[4,i-1]

;   oplot, intarr(5)+i, data[*,i-1]

   plots, [i-.25, i+.25, i+.25, i-.25, i-.25], [q25,q25,q75,q75,q25],line=0
   plots, [i-.25, i+.25], [mid, mid]
   plots, [i-.25/2, i+.25/2], [imin, imin]
   plots, [i-.25/2, i+.25/2], [imax, imax]
   plots, [i,i], [imax,q75]
   plots, [i,i], [imin,q25]

end

Set_Plot, CurDev
end

