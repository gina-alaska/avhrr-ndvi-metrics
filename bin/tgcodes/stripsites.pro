;===   STRIPSITES   ================================
;  This little code reads in the AVHRR 7-site scenes
;  and strips out the tallgrass and Niobrara sites
;===================================================

PRO stripsites, filelist

openr, LUN, filelist, /GET_LUN

readf,LUN, nim
path=""
readf, LUN, path
filename=strarr(nim)
readf, LUN, filename
FREE_LUN, LUN

dim = 100
nbands = 10
nsites = 7
nsites = 6

jd = fltarr(nim)
;nim = 1
for IIdx = 0, nim-1  do begin
   jd = j2d(filename(IIdx),1996, 3)

   tgoutfile = "./tg96/tg96"+strmid(filename(IIdx),3,8)+".img"
   nboutfile = "./nb96/nb96"+strmid(filename(IIdx),3,8)+".img"

   print, "READING: ", filename(IIdx)
 siteimg = imgread(path+filename(IIdx), nsites*dim,nbands*dim, nbands, /order)

;   siteimg = imgread(filename(IIdx), 700,1000, 10, /order)

   print, "EXTRACTING TALLGRASS"
   tg = bytarr(dim, dim*(nbands+2))
   tg(*, 0:dim*nbands-1) = imgcopy(siteimg, 0, 0, dim, dim*nbands)

   print, "EXTRACTING NIOBRARA"
   nb = bytarr(dim, dim*(nbands+2))
   nb(*, 0:dim*nbands-1) = imgcopy(siteimg, dim, 0, dim, dim*nbands) 
                                                    ;REMEMBER THAT IN ORIGINAL
                                                    ;DATA, NIOBRARA IS SECOND 
                                                    ;COLUMN, NOT THIRD

   print, "WRITING: ", tgoutfile
   imgwrite, tg, tgoutfile
   ;showsite, tg, 10

   print, "WRITING: ", nboutfile
   imgwrite, nb, nboutfile
   ;showsite, nb, 12

;readone, nboutfile, d,1,100
;print, "Press return to continue:"
;cont = ""
;read, cont

endfor
end
