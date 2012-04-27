PRO  Img2Tif, imgname 

;
; This procedure converts a LAS 'img' file to a TIFF 
; image file.  It assumes a ddr exists for the LAS
; file.
;
; USAGE:
;   Img2Tiff, ImgName (no extension)
;

ImgFile=ImgName+'.img'
ImgDDR =ImgName+'.ddr'
TIFFIle=ImgName+'.tif'

ddr=Read_LAS_DDR(ImgDDR)

Img=ImgRead3(ImgFile, ddr.ns, ddr.nl, ddr.nb, dt=ddr.dt)

Write_TIFF, TIFFile, Img[*,*,0]

END

