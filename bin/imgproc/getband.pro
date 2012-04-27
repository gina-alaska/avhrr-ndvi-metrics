FUNCTION   getband, data, band, chipdim, site, ORDER=ORDER

ImgSize = Size(data)
NSamps = ImgSize(1)

case N_PARAMS() of
   2: begin
        chipdim = NSamps
        site = 0
      end
   3: site = 0
   else: MESSAGE, 'Wrong number of arguments in GETBAND'
endcase

rotidx = 0
if(KEYWORD_SET(ORDER)) then begin
   rotidx = 7
endif


return, rotate(imgcopy(data, site*chipdim, band*chipdim, chipdim, chipdim), $
               rotidx)
end


