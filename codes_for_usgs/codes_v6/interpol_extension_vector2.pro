;This program process a vector, it get rid of no-sense point such as -2000 (80), intepolate with adjunct points
;This program do not call oneyear_extension, that means do not interpolate jan,nov,and dec into feb to oct data series
;do interpolate, interpolate threshold, if all time series are threshold values, means this pixel is not vegitation, perhaps water, do not calcualte metrics of this pixel
;threshold is fill value, do not do interpolate, snowcld=60, need interpolate, for points with 81-100, need interpolate
;jzhu, 8/10/2011, this program interpol a three-year-data-vector. 

pro interpol_extension_vector2, v, v_bname, threshold,snowcld,v_interp,v_bname_interp

;input: v--- input vector, v_bname--band name, return data stored in v_interp, threshold--- get rid of those points with value below threshold, then interpol
;       v_bname----band names of elements of vector
;output: v_interp---- result vector, v_bname_interp --- result of band names

;----- interpol into a complete year, 52 bands/year, so three year will be 52*3 bands

;-- located start and end idx for three years,

;---- for 7day per period, it has 52 period per year, before calcualte, interpol beginning and ending missing periods with 60B (assuming
;they are coved by snow)

;---------bf-yr
idx=where( strmid(v_bname,0,1) EQ 0,cnt)
bf_year_bn=v_bname(idx)
bf_year =v(idx)
numofbfyr=n_elements(bf_year)
;---------mid-yr
idx = where(  strmid(v_bname,0,1) EQ 1, cnt)
mid_year_bn=v_bname(idx)
mid_year=v(idx)
numofmidyr=n_elements(mid_year)
;---------af-yr
idx=where(strmid(v_bname,0,1) EQ 2,cnt)
af_year_bn=v_bname(idx)
af_year=v(idx)
numofafyr=n_elements(af_year)

;-----decide how many points need intepolate before mid_year and after mid_year

yearbn=mid_year_bn
stbn=yearbn[0]
edbn=yearbn[numofmidyr-1]
stday=strmid(stbn,7,3)
edday=strmid(edbn,11,3)
year= strmid(stbn,2,4)
prefix=strmid(stbn,0,1) ;combined data less than 10 year

if year mod 4 then begin
day=366
endif else begin
days=365
endelse


st_num=fix( (fix(stday)-1)/7.0 )
ed_num=fix( (days-(fix(edday)+1) )/7.0 )

stv=bytarr(st_num)

edv=bytarr(ed_num)

;----construct vx--x axis values, comvpx--compv axis values

vx=[indgen(numofbfyr),indgen(numofmidyr)+numofbfyr+st_num, $
    indgen(numofafyr)+numofbyr+st_num+numofmidyr+ed_num]

numofcompv=numofbfyr+st_num+numofmidyr+ed_num+numofafyr


compvx=indgen(numofcompv)

idx=where(mid_year NE threshold,cnt)

if float(cnt)/float(numofmidyr) LT ratio then begin

compv=bytarr(numofcompv)+threshold

endif else begin



;----interpol

compv=interpol(v,vx,compvx)

endelse


;---construct bname of st_num and ed_num


;------ get band names for st_num

count=0
stbns=strarr(st_num)

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

stbns[n]=prefix+'_'+year+'_'+d1str+'-'+d2str


count=count+1

endfor

;----get band name for ed_num

count=0
edbns=strarr(ed_num)

for n=0, ed_num-1 do begin
   
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

edbns[n]=prefix+'_'+year+'_'+d1str+'-'+d2str

count=count+1

endfor

;-----compbn

compbn=[bf_year_bn,stbns,mid_year_bn,edbns,af_year_bn]


v_interp=compv  ; processed vector to v

v_bname_interp=vcompbn

return

end
