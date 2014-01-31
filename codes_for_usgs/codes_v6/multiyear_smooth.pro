;This program do smooth for a multiyear_layer_stack file and output to a ne file named multiyear_layer_stack_smooth
;It interpol several times of no observation 7-day, so the total bands increase, and band names also increase
 
pro multiyear_smooth, filen

;input: filen---multiple-year file, ready to smooth, output file name is filen+'_metrics'
;output: file name - filen+'_smoothed'
;
;---- initial envi, 
;test input parameters

filen = '/home/jiang/nps/cesu/modis_ndvi_250m/wrkdir/multiyear_layer_stack_1'

p =strpos(filen,'/',/reverse_search)

len=strlen(filen)

wrkdir=strmid(filen,0,p+1)

filebasen=strmid(filen,p+1,len-p)

year=strmid(filen, len-4,4)


fileoutn=wrkdir+filebasen+'_smoothed'

start_batch, wrkdir+'b_log',b_unit




flg=0;  0----successs, 1--- not sucess


envi_open_file,filen,r_fid=rt_fid


if rt_fid EQ 0 then begin 

flg=1  ; 0---success, 1--- not success

return  ; 

endif

envi_file_query,rt_fid,dims=dims,nb=nb,ns=ns,nl=nl,fname=fn,bnames=bnames

;---- read each slice to process

threshold=-2000;  for point with value below threshold, get rid of them

;----j=ns, i=nl, k=nb

for i=0l, nl-1 do begin  ; every line

data=envi_get_slice(/BIL,fid=rt_fid,line=i)

for j=0l, ns-1 do begin

;---- one spectrum process

print, ' process sample:'+strtrim(string(j),2), ', line:'+strtrim(string(i),2)


;if j EQ 781 then begin

;print,'pause'

;endif


tmp=transpose(data(j,*) ) ; band vector

;---- get rid of no-sense points, 

interpol_vector,tmp,bnames,threshold,tmp_interp,tmp_bname_interp

user_smooth, tmp_interp, tmp_smooth


if i EQ 0l and j EQ 0l then begin
 
nb_out =n_elements(tmp_smooth)

data_out=intarr(ns,nl,nb_out)

bnames_out=tmp_bname_interp

endif

data_out(j,i,*)=tmp_smooth


endfor  ; sample loop

endfor  ; line loop

;-----output smoothed data_out


map_info=envi_get_map_info(fid=rt_fid)

fileout=wrkdir+filebasen+'_smoothed'

ENVI_WRITE_ENVI_FILE,data_out,out_name= fileout,map_info=map_info,bnames=bnames_out,$
                     ns=ns,nl=nl,nb=nb_out
                     

;---- exit batch mode

ENVI_BATCH_EXIT


print,'finishing smooth multiyear layer-stack-good data ...'




return

end

