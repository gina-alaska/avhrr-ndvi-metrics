PRO clavr2, datau, clouds, jd, TFILE=tfile



Tmax = 299.0

;Tmax = [285,   285,285,287,  290,292,299,  299,292,290,  287,285,285,  285]
;Tmax = [285,   285,285,287,  290,297,307,  307,292,290,  287,285,285,  285]
Tmax = [285,   285,285,287,  295,298,305,  307,297,290,  287,285,285,  285]
dat = [-15,15, 46, 74,  105,135,166,196,227,  258,288,319,349,380]

ttop = interpol(tmax, dat, jd)
print, "TLand = ", ttop(0)

Dim = 512L

   clavr, datau, clouds, jd, TFILE=tfile

   ImgSize = Size(datau)

   CASE (ImgSize(0)) OF
      2:  T4 = getband(datau, 3)
      3:  T4 = datau(*,*,3)
      ELSE:
   ENDCASE

   BadIdx = where((clouds[*,*,2] eq 1 and clouds[*,*,0] eq 1) or $
                  (clouds[*,*,1] eq 1 and clouds[*,*,0] eq 1) or $
                  (clouds[*,*,1] eq 1 and clouds[*,*,2] eq 1 and $
                   clouds[*,*,0] eq 2))

   BadMask = Mask(clouds[*,*,0], BadIdx, /Show)

   WarmIdx = where(T4 ge Ttop(0))

   WarmMask = Mask(T4, WarmIdx, /Hide)

   BadMask = BadMask*WarmMask

   B1Mask = Clouds[*,*,1]*BadMask
   NDMask = Clouds[*,*,2]*BadMask

   CldMask = B1Mask + NDMask + clouds[*,*,3]*WarmMask + $
;   CldMask = B1Mask + NDMask + clouds[*,*,3] + $
             clouds[*,*,4] + clouds[*,*,5] 


   clouds[*,*,0] = CldMask
   clouds[*,*,1] = B1Mask
   clouds[*,*,2] = NDMask

END
