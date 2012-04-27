FUNCTION ApplyPSF, kernel, imagename, band, NSIn, NLIn, DTIn, PixSpaceX, PixSpaceY, subddr, $
         UPDATE=UPDATE, BANDTOMODEL=BandToModel, LOOKANGLE=LookAngle, HIPIXSIZE=HiPixSize, $
         LOPIXSIZE=LoPixSize

; Check Keywords
   IF(N_ELEMENTS(UPDATE) EQ 0) THEN UpDate=0
   IF(N_ELEMENTS(BANDTOMODEL) EQ 0) THEN BANDTOMODEL=0
   IF(N_ELEMENTS(LOOKANGLE) EQ 0) THEN LOOKANGLE=0
   IF(N_ELEMENTS(HIPIXSIZE) EQ 0) THEN HIPIXSIZE=20
   IF(N_ELEMENTS(LOPIXSIZE) EQ 0) THEN LOPIXSIZE=1000



KerSize=Size(kernel)
nX = KerSize[1]
nY = KerSize[2]

xinc=PixSpaceX
yinc=PixSpaceY

image=bandread(imagename, band, nsin, nlin, dt=dtin)



ns = round((nsin-nX)/xinc)
nl = round((nlin-nY)/yinc)
print, "NS:"+strcompress(ns), "  NL:"+strcompress(nl)

subddr=ddrspace(1)
subddr.ns=ns
subddr.nl=nl
subddr.dt=dtin

subimage = fltarr(ns,nl)
t0=systime(1)
;wProgress=CW_Progress(Value=0, ysize=10)

for il = 0L, nl-1 DO BEGIN
   YMin=Il*Yinc
   YMax=Il*Yinc+nY-1
   YOffset=YMin-fix(Ymin)
   for is = 0L, ns-1 DO BEGIN
      XMin=is*Xinc
      XMax=is*Xinc+nX-1
      XOffset=XMin-fix(Xmin)
      CASE (KEYWORD_SET(Update)) OF
         1: kernel=GenVegPSF(BandToModel, LookAngle,HiPixSize,LoPixSize,KerSize[1], XCenter=XOffset, YCenter=Yoffset)
         ELSE:
      ENDCASE
      Win = image[XMin:XMax, YMin:YMax]
;      Win = image[is*xinc:is*xinc+n-1, il*yinc:il*yinc+n-1]
      subimage[is,il]=total(kernel*float(win))

   ENDFOR
;print, il*yinc, il*yinc+n-1
if il mod 10 eq 0 then print, "Processed Line:",il
percent=float(il)/(nl-1)
;if (il mod 10 eq 0 or il EQ nl-1) and Widget_Info(wProgress, /Realized) then $
;    Widget_Control, wProgress, Set_Value=percent
ENDFOR
;Widget_Control, wProgress, /Destroy
;print, "Elapsed Time:", Systime(1)-t0

;print, "MIN:",min(subimage)
;print, "MAX:",max(subimage)

case(dtin) of
1: Return, byte(round_to(subimage,1))
2: Return, fix(round_to(subimage,1))
3: Return, long(round_to(subimage,1))
4: Return, subimage
else:
ENDCASE


END
