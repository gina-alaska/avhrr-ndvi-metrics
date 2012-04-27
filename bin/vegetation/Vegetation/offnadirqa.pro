   infile='LastJudgement'
   infile='/edcsnw54/home/suarezm/data/spot/tg960721/spot0721ref'

   ddrin=Read_LAS_DDR(infile+'.ddr')
   NSIn=ddrin.ns
   NLIn=ddrin.nl
   NBIn=ddrin.nb
   DTIn=ddrin.dt

   ;imgin=ImgRead(infile+'.img', NSIn, NLIn, NBIn)

   PixSpaceX=1000.
   PixSpaceY=1000.
   LoPixSize=1000.
   HiPixSize=20.
   KerSize=96

mina=0
maxa=50
da=2

na=(maxa-mina)/da + 1

   numsamp=lonarr(3, na)
   std=fltarr(3, na)
   mean=fltarr(3, na)
   angle=fltarr(na)

   FOR UseBand =3, 1, -1 DO BEGIN

      ModelBand=UseBand+1

      FOR i = 0, na-1 DO BEGIN
         LookAngle= mina+ i*da
         Angle(i)=LookAngle
print, "Band:",UseBand, "  Angle:",LookAngle     
         Altitude=832000.
         RoundScaleX=1./cos(d2r(LookAngle));RoundStretch(LookAngle, Altitude)
         RoundScaleY=1.;RoundStretch(LookAngle, Altitude, /Y)
         PixSpaceX2 = Round_To(PixSpaceX/HiPixSize * RoundScaleX, .01)
         PixSpaceY2 = Round_To(PixSpaceY/HiPixSize * RoundScaleY, .01)

         psf=GenVegPSF(ModelBand, LookAngle, HiPixSize, LoPixSize, KerSize)
;print, LookAngle, PixSpaceX2, PixSpaceY2

         img=ApplyPSF(psf, infile+'.img', UseBand-1, NSIn,NLIn, DTIn, PixSpaceX2, PixSpaceY2, subddr $
             ,/UpDate, BandToModel=ModelBand, LookAngle=Lookangle, HiPix=HiPixSize, LoPix=LoPixSize $
             )

         IF i EQ 0 THEN BEGIN
            img0=img
            NS0=subddr.ns
            NL0=subddr.nl
         END; IF i

         imgres=congrid(img, NS0, NL0, Cubic=-0.5)
         numsamp(UseBand-1, i) = subddr.ns
         std(UseBand-1, i) = stdev(float(img0)-float(imgres))
         mean(UseBand-1, i) = avg(float(img0)-float(imgres))

      END; FOR i

   END; FOR ModelBand


;window,1

curplot=!d.name
Set_Plot, 'PS'

Device,file='Updated.ps', /Color, bits=8;,xoffset=1, yoffset=1, /inch

loadct, 12
!p.multi=[0,1,2]

plot, std(2,*), /NoData, Title='Deviation', XTitle='Look Angle, (deg)', YTitle='Brightess Deviation & NSamples',$
  yrange=[min(std),max(std)], color=0;rgb(255,255,255)
oplot, std(2,*), color=12*16;rgb(255,0,0)
oplot, std(1,*), color=6*16;rgb(0,255,0)
oplot, std(0,*), color=2*16;rgb(0,0,255)
oplot, numsamp(2,*), psym=4, color=12*16;rgb(255,0,0), psym=4
oplot, numsamp(1,*), psym=5, color=6*16;rgb(0,255,0), psym=5
oplot, numsamp(0,*), psym=6, color=2*16;rgb(0,0,255), psym=6


;window,0
plot, mean(0,*), Title='Mean Offset', XTitle='Look Angle, (deg)', YTitle='Mean Brightness Offset', $
  YRange=[min(mean), max(mean)], color=0;rgb(255,255,255)
oplot, mean(2,*), color=12*16;rgb(255,0,0)
oplot, mean(1,*), color=6*16;rgb(0,255,0)
oplot, mean(0,*), color=2*16;rgb(0,0,255)
device, /close

set_plot, curplot
!p.multi=[0,0,0]
END
