FUNCTION GenVegPSF, Band, LookAngle, HiPixSize, LoPixSize, KerSizeX, KerSizeY, ALTITUDE=altitude, $
    XCENTER=XCenter, YCENTER=YCenter

;
; Read supplied MTF data
;
      file='/edcsnw54/home/suarezm/idl/bin/Vegetation/mtf.dat'
      file='C:\RSI\IDL50\myidldir\vegetation\mtf.dat'
      file='C:\RSI\IDL50\myidldir\vegetation\mtf.csv'
      file='/edcsnw54/home/suarezm/idl/bin/Vegetation/mtf.csv'
      m=readtab(file, 8, 30, 0, sep=',')

;      print, "Modeling Band:"+strcompress(band)

      if(N_elements(Altitude) eq 0) Then Altitude = 832000. ;VEGETATION altitude
      IF(N_Elements(XCenter) EQ 0) THEN XCenter=0.0
      IF(N_Elements(YCenter) EQ 0) THEN YCenter=0.0

      fe=1.0
      hires=20.
      HiLoScale=float(LoPixSize)/HiPixSize
      RoundScaleX=RoundStretch(LookAngle, Altitude)
      RoundScaleY=RoundStretch(LookAngle, Altitude, /Y)
      ScaleX=HiLoScale*RoundScaleX
      ScaleY=HiLoScale*RoundScaleY

      nX =KerSizeX
      n2X=nX/2

      nY =KerSizeY
      n2Y=nY/2

      freq  =[-fe/2., -fe/4., -fe/8., 0., -fe/8., -fe/4., -fe/2.]

      fx=findgen(nX)/n2X -1.
      x=findgen(nX)

      fy=findgen(nY)/n2Y -1.
      y=findgen(nY)

      bidx=where(m.data(0,*) EQ band, na)


;      mtfx  =fltarr(na,7)
      mtfxfit =fltarr(na,7)


      psfx  =fltarr(na,nX)
      psfxf =fltarr(na,nX)

      mtfxmod =fltarr(na, 7)
      mtfxmodf=fltarr(na, 7)

;
; Set up mtf for LookAngle equivalent to line in mtf table
;
      mtfatangle=fltarr(8)
      mtfatangle[0] = band
      mtfatangle[1] = LookAngle


;
; Model mtf in angle direction
;
      FOR f = 2,7 do begin
         weight=m.data[f,bidx]*0+1
         angc = polyfitw(m.data[1,bidx], m.data[f,bidx],weight,2,angfit)
         mtfatangle[f] = angc[0]+angc[1]*LookAngle+angc[2]*LookAngle^2
      END; FOR f


;
; Set up modeled mtf array
;
      mtfxmod = mirror([mtfatangle[2], mtfatangle[4], mtfatangle[6]], $
                       center=1.0, /right)
      mtfymod = mirror([mtfatangle[3], mtfatangle[5], mtfatangle[7]], $
                       center=1.0, /right)


;
; Fit angle-modeled mtf with Gaussian
;
      mtfxfit = gaussfit(freq, mtfxmod, coef, nterms=3, est=[1., 0., 0.5])
      Ax = coef

      mtfyfit = gaussfit(freq, mtfymod, coef, nterms=3, est=[1., 0., 0.5])
      Ay = coef


;
; Transform MTF to stretched PSF
;
      psfx = exp(-2*(!pi*Ax[2]*(X-n2X-XCenter)/(ScaleX))^2)
      psfy = exp(-2*(!pi*Ay[2]*(Y-n2Y-YCenter)/(ScaleY))^2)



;
; Fit PSF with Gaussian
;
      psfxf = gaussfit(x, psfx, coef, nterms=3, est=[1., n2X, ScaleX/2.])
      Bx = coef

      psfyf = gaussfit(y, psfy, coef, nterms=3, est=[1., n2Y, ScaleY/2.])
      By = coef

      psf2d = double(psfx) # double(psfy)
      
      IntPSF=total(double(psf2d))

;      psf2d = round_to(psf2d/IntPSF, 1.e-6)

      psf2d=psf2d/IntPSF
      RETURN, psf2d

END

