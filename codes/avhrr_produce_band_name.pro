function avhrr_produce_band_name, num,year
;num---number of bands, year--what year of band name you want to produce
;format of bname is:1-yyyy.ddd-ddd

bname=strarr(num)

year1= strtrim(string(year),2)

mon=1
day=1
i=0  ; initial value 

for mon=1, 12 do begin

for day=1, 21, 10 do begin

;---convert yyyymmdd into 1-yyyy.ddd-ddd

mon1 = strtrim( string(mon),2 )
if mon LT 10 then begin
 mon1='0' + mon1
endif


day1= strtrim( string(day),2 )

if day LT 10 then begin
 day1='0' + day1
endif

datetime_str = year1 +'-'+mon1+'-'+day1 +' 00:00:00.00' 

day_array = date_conv(datetime_str,'V')
; day_aray is 5-elements array
;               date[0] = year (eg. 1987)
;               date[1] = day of year (1 to 366)
;               date[2] = hour
;               date[3] = minute
;               date[4] = secondhas format

days=fix(day_array[1])

days9=days+9

if  days LT 10 then begin
   days1='00'+strtrim(string(days),2)
endif else begin
  if days GE 10 and days LT 100 then begin
    days1='0' +strtrim(string(days),2)
  endif else begin
    days1=  strtrim(string(days),2)
  endelse
endelse
    
;---- get days91    
    
 if  days9 LT 10 then begin
   days91='00'+strtrim(string(days9),2)
endif else begin
  if days9 GE 10 and days9 LT 100 then begin
    days91='0' +strtrim(string(days9),2)
  endif else begin
    days91=  strtrim(string(days9),2)
  endelse
endelse    

;--- '1-yyyy.ddd-ddd' format

  
 bname(i) = '1-'+year1+'.'+days1+'_'+days91
 i=i+1 

endfor

endfor

return, bname

end