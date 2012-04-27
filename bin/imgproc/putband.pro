PRO   putband, data, band, chip, chipdim, site

case N_PARAMS() of
   3: begin
        chipdim = 100
        site = 0
      end
   4: site = 0
   else: MESSAGE, 'Wrong number of arguments in PUTBAND'
endcase

data(site*chipdim:(site+1)*chipdim-1, $
     band*chipdim:(band+1)*chipdim-1) = chip

end


