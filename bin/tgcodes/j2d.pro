FUNCTION	j2d,str, year, offset

;
; do the time stuff (julian date, time of day from file names)
;
; str    -  the string containing the date to be extracted
; year   -  the 4 digit year to use (default = 1994)
; offset -  the number of characters into the filename
;           at which to start reading (default = 2)
;

case N_PARAMS() of
  1: begin 
        year = 1994 
        offset = 2
     end
  2: offset = 2
  3: offset = offset
  else: MESSAGE, 'Wrong number of arguments in J2D'
endcase 


mon  = strmid (str, offset  , 2)
day  = strmid (str, offset+2, 2)
hour = strmid (str, offset+4, 2)
min  = strmid (str, offset+6, 2)

day1 = julday (1, 1, year)

jday = julday (mon, day, year) - day1
frac = hour/24. + min/1440.
jday = jday + frac



return,jday
end
