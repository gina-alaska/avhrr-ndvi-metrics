;this function accept band name vector, and float index, to return exec day

function findday, bandName, dayindex_flt

dayidx1=fix(dayindex_flt)

fract = dayindex_flt mod dayidx1

if fract then begin

dayidx2=dayidx1+1

day1= fix( strmid( bandname(dayidx1),7,3)) 
day2= fix( strmid( bandname(dayidx2),7,3))

x=fix( day1 +fract*(day2-day1) )

  

endif else begin
dayidx2=dayidx1
x=fix( strmid( bandname(dayidx1),7,3) )

endelse

return, x

end