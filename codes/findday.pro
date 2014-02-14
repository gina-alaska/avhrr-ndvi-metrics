;this function accept band name vector, and float index, to return exec day

function findday, bandName, dayindex_flt

dayidx1=fix(dayindex_flt)

if dayidx1 EQ 0 then begin
   
   fract=dayindex_flt
   
endif else begin      

   fract = dayindex_flt mod dayidx1
endelse

if fract then begin

dayidx2=dayidx1+1

day1st = fix( strmid( bandname(dayidx1),5,3))

day1ed = fix( strmid( bandname(dayidx1),8,3))
 
day1 =0.5*(day1st+day1ed)
 
 
day2st= fix( strmid( bandname(dayidx2),5,3))

day2ed= fix( strmid( bandname(dayidx2),8,3))

day2=0.5*(day2st+day2ed)


x=fix( round( day1 +fract*(day2-day1) ) )


endif else begin
  
dayidx2=dayidx1

dayst1 = fix( strmid( bandname(dayidx1),5,3) )

dayed1 = fix( strmid( bandname(dayidx1),8,3) )

x=fix( round( 0.5*(dayst1+dayed1) ) )


endelse

return, x

end
