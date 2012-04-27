PRO procsites, listfile

openr, LUN, listfile, /GET_LUN

readf, LUN, nim
path=""
readf, LUN, path
filename=strarr(nim)
readf, LUN, filename
FREE_LUN, LUN

jd = fltarr(nim)

keepTG = ""
for IIdx = 0, nim-1 do begin
   jd = j2d(filename(IIdx), 1996, 3)
   print, jd, filename(IIdx)
   readlac95, filename(IIdx), c, 1
   print, "Keep Tallgrass? (y/n/x)"
   read, keepTG
   case 1 of
      (keepTG eq 'y'): begin
                         tg = extsite(c, 0)
                         showsite, tg, 2
    outfile = "tg96"+strmid(filename(IIdx),3,8)+".img"
                         imgwrite,tg, outfile
                         print, "Tallgrass site kept"
                       end
      (keepTG eq 'x'): goto, endloop
      else: print, "Tallgrass site dumped
   endcase
endfor
endloop:

end
