file = "us_05151946_oklahoma.img"

data = imgread(file, 512,512,10,/i2,/order)
datau = avhrrunscale(data, /i2, /ref)
jd = file2jul(file, year=1996)
;clavr, datau, clouds, jd

NSeg = 32

SegDim = 512/NSeg 

NDAvg = fltarr(NSeg,NSeg)
NDStD = fltarr(NSeg,NSeg)
T4Avg = fltarr(NSeg,NSeg)
T4StD = fltarr(NSeg,NSeg)


FOR iLine = 0, NSeg-1 DO BEGIN

   FOR iSamp = 0, NSeg-1 DO BEGIN

      x0 = iSamp*SegDim
      y0 = iLine*SegDim

      Chip = imgparse(datau, x0, y0, SegDim, SegDim)

      NDChip = getband(Chip, 5)
      T4Chip = getband(Chip, 3)
      
      NDAvg(iSamp,iLine) = AVG(NDChip)
      NDStD(iSamp,iLine) = StDev(NDChip)
      T4Avg(iSamp,iLine) = Avg(T4Chip)
      T4StD(iSamp,iLine) = StDev(T4Chip)

   ENDFOR

ENDFOR

END 
