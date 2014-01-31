pro avhrr_stack_oneyear_data, fn_flist_ndvi, fn_flist_bq, fn_flist_cldm, ul_lon,ul_lat,lr_lon,lr_lat

;This routine open one year files defined in file lists, stack these files, subset, and fill bad data with -2000

;inputs: flist_ndvi_yyyy----file list for one year *_ndvi.tif,
;        flist_bq_yyyy -----file list fro one year *_bq.tif
;        flist_cldmask_yyyy ------- file list for one year *_cldmask.tif 
;        ul-----upper left coordinate in unit of degree in geographic coordinates,WGS84
;        lr-----lower right cordinate in unit of degree in geographic coordinates,WGS84
;        data_ver_flg------, 0-old version data,1-new version data
;jzhu, 9/8/2011, subset and stack one-year ndvi and quality flag data respectively, that means we get two stacked one-year data files.


;test
;ul in deg, minute, secons= 173d 0' 0.00"W, 72d 0' 0.00"N
;lr in deg, minute, second= 127d59'56.82"W, 54d 0' 0.07"N
;if do not want subsize the data, just input 0,0,0,0 for ul_lon,ul_lat,lr_lon,lr_lat, respectively.

;ul_lon=0
;ul_lat=0
;lr_lon=0
;lr_lat=0
;fn_flist_ndvi='/center/w/jzhu/nps/avhrr/usgs/2005/2005_flist_ndvi'
;fn_flist_bq='/center/w/jzhu/nps/avhrr/usgs/2005/2005_flist_qa'
;fn_flist_cldm='/center/w/jzhu/nps/avhrr/usgs/2005/2005_flist_cldmask'



;ul=[-173.0d,72.0d]
;lr=[-127.999116667d,54.000019444d]

;set path and start envi
;ENVI, /RESTORE_BASE_SAVE_FILES
;PREF_SET, 'IDL_PATH', '<IDL_DEFAULT>:+~/nps/cesu/modis_ndvi_250m/bin', /COMMIT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;initial envi batch mode

start_batch


if ul_lon EQ 0 and ul_lat EQ 0 and lr_lon EQ 0 and lr_lat EQ 0 then begin
ul=0
lr=0
endif else begin
ul=[ul_lon,ul_lat]
lr=[lr_lon,lr_lat]
endelse

if !version.os_family EQ 'Windows' then begin
sign='\'
endif else begin
sign='/'
endelse

;---- read these two lists into flist and flist_bq


openr,u1,fn_flist_ndvi,/get_lun

openr,u2,fn_flist_bq ,/get_lun

openr,u3,fn_flist_cldm ,/get_lun


flistndvi=strarr(28) ; 28/year
flistbq  =strarr(28);
flistcldm =strarr(28)


tmp=' '
j=0L
while not EOF(u1) do begin
readf,u1,tmp

flistndvi(j)=tmp

j=j+1
endwhile

tmp=' '
j=0L
while not EOF(u2) do begin
readf,u2,tmp

flistbq(j)=tmp

j=j+1
endwhile

tmp=' '
j=0L
while not EOF(u3) do begin
readf,u3,tmp
flistcldm(j)=tmp
j=j+1
endwhile

close,u1
close,u2
close,u3

flistndvi =flistndvi[where(flistndvi NE '')]

flistbq=flistbq[where(flistbq NE '')]

flistcldm=flistcldm[where(flistcldm NE '')]

;---- get the number of files

num=(size(flistndvi))(1)

;---- get workdir and year from mid-year file

p =strpos(flistndvi(0),sign,/reverse_search)

len=strlen(flistndvi(0))

wrkdir=strmid(flistndvi(0),0,p+1)

filen =strmid(flistndvi(0),p+1,len-p)

tmpyear=strmid(filen,6,2) ; year in xx format

if fix(tmpyear) GE 89 then begin
  
 year=string(fix(tmpyear)+1900, '(I4)')
endif else begin
 year=string(fix(tmpyear)+2000, '(I4)')
endelse


;---- define a struc to save info of each file

;p={flists,fn:'abc',sn:0,dims:lonarr(5),bn:0L}

;x=create_struct(name=flist,fn,'abc',fid,0L,dims,lonarr(5),bn,0L)

x={flist,fn:'abc',bname:'abc',fid:0L,dims:lonarr(5),pos:0L}

flist_ndvi=replicate(x,num) ;save ndvi data files

flist_bq=replicate(x,num) ; save  bq data files

flist_cldm =replicate(x,num) ; save cldmask data files

;---- go through one year ndvi and bq data files

;---- for new data name
str1='_ndvi.tif'
str2='_qa.tif'
str3='_cldmask.tif'

for j=0L, num-1 do begin

fn_ndvi = strtrim(flistndvi(j),2)

;--- get the band name
p1=strpos(fn_ndvi,sign,/reverse_search)
len=strlen(fn_ndvi)
tmpfilename = strmid(flistndvi(j),p1+1,len-p1)

tmpyear=strmid(tmpfilename,6,2) ; year in xx format

if fix(tmpyear) GE 89 then begin
  
  tmpyear=string(fix(tmpyear)+1900, '(I4)')
endif else begin
  tmpyear=string(fix(tmpyear)+2000, '(I4)')
endelse
    

tmpday= strmid(tmpfilename,9,6)   ;file name format is: n14_ak95_168174_ndvi.tif

tmpbname=tmpyear+'_'+tmpday

p=strpos(fn_ndvi,str1)

tmpfilehdr=strmid(fn_ndvi,0,p)

fn_bq=tmpfilehdr+str2

fn_cldm =tmpfilehdr+str3

idx2 =where(flistbq EQ fn_bq,cnt2)

idx3=where(flistcldm EQ fn_cldm,cnt3)

if cnt2 EQ 1 or cnt3 EQ 0 then begin

;---- read ndvi and bq to cut off no-sense points

print, 'process the '+string(j)+' th file: ' +fn_ndvi

;if j EQ 38 then begin
;print,'check 38th file'
;endif

read_ndvi, fn_ndvi,fn_bq, fn_cldm, ul,lr,rt_ndvi_fid,rt_bq_fid, rt_cldm_fid

if rt_ndvi_fid EQ -1 or rt_bq_fid EQ -1 or rt_cldm_fid EQ -1 then begin

return

endif

;------- save info for each subseted ndvi file --------------
envi_file_query,rt_ndvi_fid,dims=dims,nb=nb,fname=fn,data_type=ndvi_dt

;p1=strpos(fn_ndvi,sign,/reverse_search)
;tmpbname= strmid(fn_ndvi,p1+11,12)  ; for new data, its name looks like:eMTH_NDVI.2008.029-035.QKM.VI_NDVI.005.2011202084157.tif
;tmpbname= strmid(fn_ndvi,p1+7,12)   ; for old data, its name looks like:MT3RG_2008_253-259_250m_composite_ndvi.tif

flist_ndvi[j].fn=fn_ndvi +'.good'
flist_ndvi[j].bname=tmpbname
flist_ndvi[j].fid=rt_ndvi_fid
flist_ndvi[j].dims=dims
flist_ndvi[j].pos=0  ; note, each subset data has only one band, which is 0, so you can use this to indicate

;-------save info of each subset bq file------------
envi_file_query,rt_bq_fid,dims=dims,nb=nb,fname=fn,data_type= bq_dt

;p1=strpos(fn_bq,sign,/reverse_search)
;tmpbname= strmid(fn_bq,p1+11,12)
;tmpbname= strmid(fn_ndvi,p1+7,12)   ; for old data, its name looks like:MT3RG_2008_253-259_250m_composite_ndvi.tif

flist_bq[j].fn=fn_bq +'.good'
flist_bq[j].bname=tmpbname
flist_bq[j].fid=rt_bq_fid
flist_bq[j].dims=dims
flist_bq[j].pos=0  ; note, each subset data has only one band, which is 0, so you can use this to indicate

;-------save info of each subset cldmask file------------
envi_file_query,rt_cldm_fid,dims=dims,nb=nb,fname=fn,data_type=cldm_dt

;p1=strpos(fn_bq,sign,/reverse_search)
;tmpbname= strmid(fn_bq,p1+11,12)
;tmpbname= strmid(fn_ndvi,p1+7,12)   ; for old data, its name looks like:MT3RG_2008_253-259_250m_composite_ndvi.tif

flist_cldm[j].fn=fn_cldm +'.good'
flist_cldm[j].bname=tmpbname
flist_cldm[j].fid=rt_cldm_fid
flist_cldm[j].dims=dims
flist_cldm[j].pos=0  ; note, each subset data has only one band, which is 0, so you can use this to indicate


endif   ; have ndvi,bq, and cldm files


endfor

;---- layer stack for ndvi, bq, and cldm, respectively.


  out_proj = envi_get_projection(fid = flist_ndvi[0].fid, $
    pixel_size=out_ps)


;---write ndvi stacked file
out_dt = ndvi_dt
out_name = wrkdir+year+'_stacked_ndvi'
 
 envi_doit, 'envi_layer_stacking_doit', $
    fid=flist_ndvi.fid, pos=flist_ndvi.pos, dims=flist_ndvi.dims,/EXCLUSIVE, $
    out_dt=out_dt, out_name=out_name,out_bname=flist_ndvi.bname, $
    interp=2, out_ps=out_ps, $
    out_proj=out_proj, r_fid=tot_ndvi_fid

;--------write bq stacked file
out_dt = bq_dt
out_name = wrkdir+year+'_stacked_bq'
envi_doit, 'envi_layer_stacking_doit', $
    fid=flist_bq.fid, pos=flist_bq.pos, dims=flist_bq.dims,/EXCLUSIVE, $
    out_dt=out_dt, out_name=out_name,out_bname=flist_bq.bname, $
    interp=2, out_ps=out_ps, $
    out_proj=out_proj, r_fid=tot_bq_fid
    
;----write cldm stacked file

out_dt = cldm_dt
out_name = wrkdir+year+'_stacked_cldm'
envi_doit, 'envi_layer_stacking_doit', $
    fid=flist_cldm.fid, pos=flist_cldm.pos, dims=flist_cldm.dims,/EXCLUSIVE, $
    out_dt=out_dt, out_name=out_name,out_bname=flist_cldm.bname, $
    interp=2, out_ps=out_ps, $
    out_proj=out_proj, r_fid=tot_cldm_fid
    



;---- delete good_* files

num=(size(flist_ndvi))(1)

for j=0L,num-1 do begin

envi_file_mng,id=flist_ndvi[j].fid,/remove,/delete

envi_file_mng,id=flist_bq[j].fid,/remove,/delete

envi_file_mng,id=flist_cldm[j].fid,/remove,/delete


endfor



print,'finishing ndvi, bq, and cldm layer stacking and subset, respectively.'

envi_batch_exit

return

end
