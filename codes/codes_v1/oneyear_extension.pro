;--- calculate how many points need to be add
;This program do extension of one-year vector which includes ndvi ;values to complete one year vector (365 or 366 days)

pro oneyear_extension,yearv,yearbn,st_num,ed_num,days

;inputs: yearv-- yearly ndvi data,yearly ndvi observation days, ;days--days of the year, return the results of complete year data ;in the same vectors

numofyear=n_elements(yearv)
 
stbn=yearbn[0]
edbn=yearbn[numofyear-1]

stday=strmid(stbn,7,3) 
edday=strmid(edbn,11,3)
year= strmid(stbn,2,4)
prefix=strmid(stbn,0,1) ;combined data less than 10 year


if year mod 4 then begin
days=366
endif else begin
days=365
endelse


st_num=fix( (fix(stday)-1)/7.0 )
ed_num=fix( (days-(fix(edday)+1) )/7.0 )


;----construct the complete vectors for data and bandname

compv=intarr(st_num+numofyear+ed_num)

compbn=strarr(st_num+numofyear+ed_num)

;fill before and after data with 60B for compv, 
;we assume in befor and after periods,land is covered by snow.

compv[0:st_num-1]=60B

compv[st_num:st_num+numofyear-1]=yearv

compv[st_num+numofyear: st_num+numofyear+ed_num-1]=60B

;---fill band names for index from 1 to st_num-1

count=0

for n=st_num-1, 0, -1 do begin
  
d2 = fix(stday) -count*7-1
d1 = fix(stday)-(count+1)*7

d2str=strtrim(string(d2),2 )
d1str=strtrim(string(d1),2 )

if d2 LT 10 then begin
   d2str='00'+d2str
endif else begin
   if d2 LT 100 then begin
     d2str='0'+d2str
   endif
   
endelse  

;-------------      

if d1 LT 10 then begin
   d1str='00'+d1str
endif else begin
   if d1 LT 100 then begin
     d1str='0'+d1str
   endif
   
endelse  

;------

compbn[n]=prefix+'_'+year+'_'+d1str+'-'+d2str


count=count+1

endfor



compbn[st_num:st_num+numofyear-1]=yearbn


;---- fill band name for index from st_num+numofyear to st_num+numofyear+ed_num-1

count=0

for n=st_num+numofyear, st_num+numofyear+ed_num-1 do begin
   
d1 = fix(edday) +count*7 + 1
d2 = fix(edday) +(count+1)*7

d2str=strtrim(string(d2),2 )
d1str=strtrim(string(d1),2 )

if d2 LT 10 then begin
   d2str='00'+d2str
endif else begin
   if d2 LT 100 then begin
     d2str='0'+d2str
   endif
   
endelse  

;-------------      

if d1 LT 10 then begin
   d1str='00'+d1str
endif else begin
   if d1 LT 100 then begin
     d1str='0'+d1str
   endif
   
endelse  

;------

compbn[n]=prefix+'_'+year+'_'+d1str+'-'+d2str

count=count+1

endfor


yearv=compv
yearbn=compbn

return

end

