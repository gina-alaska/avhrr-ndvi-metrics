pro oneyear_data_layer_subset_good_ver9, flist_ndvi, flist_bq, ul_lon,ul_lat,lr_lon,lr_lat

;This routine open one year files defined in file lists, stack these file, subset, and fill bad data with -2000

;inputs: flist_ndvi_yyyy----file list for one year *ndvi.tif,
;        flist_bq_yyyy -----file list fro one year *nvdi_bq.tif
;        ul-----upper left coordinate in unit of degree in geographic coordinates,WGS84
;        lr-----lower right cordinate in unit of degree in geographic coordinates,WGS84
;        data_ver_flg------, 0-old version data,1-new version data
;jzhu, 9/8/2011, subset and stack one-year ndvi and quality flag data respectively, that means we get two stacked one-year data files.


;test
;ul in deg, minute, secons= 173d 0' 0.00"W, 72d 0' 0.00"N
;lr in deg, minute, second= 127d59'56.82"W, 54d 0' 0.07"N
;if do not want subsize the data, just input 0,0,0,0 for ul_lon,ul_lat,lr_lon,lr_lat, respectively.
;wrkdir='/home/jiang/nps/cesu/modis_ndvi_250m/wrkdir/'

;flist_ndvi='/mnt/jzhu_scratch/EMODIS-NDVI-DATA/wrk/ver_new_201107/2008/flist_ndvi'
;flist_bq = '/mnt/jzhu_scratch/EMODIS-NDVI-DATA/wrk/ver_new_201107/2008/flist_bq'

;flist_ndvi='/raid/scratch/cesu/eMODIS/ver_old/2008/flist_ndvi'
;flist_bq='/raid/scratch/cesu/eMODIS/ver_old/2008/flist_bq'

;flist_ndvi='/home/jiang/nps/cesu/modis_ndvi_250m/wrkdir/2010/2010_flist_ndvi'
;flist_bq = '/home/jiang/nps/cesu/modis_ndvi_250m/wrkdir/2010/2010_flist_bq'
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


openr,u1,flist_ndvi,/get_lun

openr,u2,flist_bq ,/get_lun



flist=strarr(420) ; 42/year, 10 years
flistbq=strarr(420);

tmp=' '
j=0L
while not EOF(u1) do begin
readf,u1,tmp

flist(j)=tmp

j=j+1
endwhile

tmp=' '
j=0L
while not EOF(u2) do begin
readf,u2,tmp

flistbq(j)=tmp

j=j+1
endwhile

close,u1
close,u2

flist =flist[where(flist NE '')]
flistbq=flistbq[where(flistbq NE '')]

;---- get the number of files

num=(size(flist))(1)

;---- get workdir and year from mid-year file

p =strpos(flist(1),sign,/reverse_search)

len=strlen(flist(1))

wrkdir=strmid(flist(1),0,p+1)

filen =strmid(flist(1),p+1,len-p)
;-----use file header to determine the 

p1=strpos(filen,'MT3RG_')
if p1 EQ 0 then begin ; old version data
data_ver_flg=0 
endif else begin
data_ver_flg=1
endelse
;-----------------------

if data_ver_flg EQ 0 then begin

year=strmid(filen,6,4)   ;MT3RG_2008_141-147_250m_composite_ndvi.tif

endif else begin

year=strmid(filen,13,4)  ;AK_eMTH_NDVI.2008.036-042.QKM.VI_NDVI.005.2011202142526.tif

endelse

;---- define a struc to save info of each file

;p={flists,fn:'abc',sn:0,dims:lonarr(5),bn:0L}

;x=create_struct(name=flist,fn,'abc',fid,0L,dims,lonarr(5),bn,0L)

x={flist,fn:'abc',bname:'abc',fid:0L,dims:lonarr(5),pos:0L}

flista=replicate(x,num) ;save ndvi data files

flistq=replicate(x,num) ; save ndvi_bq data files

;---- go through one year ndvi and ndvi_bq data files

for j=0L, num-1 do begin

fn_ndvi = strtrim(flist(j),2)

;---- for old data name

if data_ver_flg EQ 0 then begin
str1='composite_ndvi'
str2='composite_ndvi_bq'
p1=strpos(fn_ndvi,sign,/reverse_search)
tmpbname= strmid(fn_ndvi,p1+7,12)   ; for old data, its name looks like:MT3RG_2008_253-259_250m_composite_ndvi.tif

endif else begin
;---- for new data name

str1='.VI_NDVI.'
str2='.VI_QUAL.'
p1=strpos(fn_ndvi,sign,/reverse_search)
tmpbname= strmid(fn_ndvi,p1+14,12)  ; for new data, its name looks like:eMTH_NDVI.2008.029-035.QKM.VI_NDVI.005.2011202084157.tif

endelse

p=strpos(fn_ndvi,str1)

len=strlen(fn_ndvi)

file_hdr=strmid(fn_ndvi,0,p)

file_end =strmid(fn_ndvi,p+strlen(str1),len-1-strlen(str1) )

fn_bq=file_hdr+str2+file_end

idx =where(flistbq EQ fn_bq,cnt)

if cnt EQ 1 then begin

;---- read ndvi and bq to cut off no-sense points

print, 'process the '+string(j)+' th file: ' +fn_ndvi

;if j EQ 38 then begin
;print,'check 38th file'
;endif

read_ndvi_ver9, fn_ndvi,fn_bq,ul,lr,rt_fid,rt_bq_fid

if rt_fid EQ -1 or rt_bq_fid EQ -1 then begin

return

endif

;------- save info fo each subseted ndvi file --------------
envi_file_query,rt_fid,dims=dims,nb=nb,fname=fn,data_type=data_dt

;p1=strpos(fn_ndvi,sign,/reverse_search)
;tmpbname= strmid(fn_ndvi,p1+11,12)  ; for new data, its name looks like:eMTH_NDVI.2008.029-035.QKM.VI_NDVI.005.2011202084157.tif
;tmpbname= strmid(fn_ndvi,p1+7,12)   ; for old data, its name looks like:MT3RG_2008_253-259_250m_composite_ndvi.tif

flista[j].fn=fn_ndvi+'.good'
flista[j].bname=tmpbname
flista[j].fid=rt_fid
flista[j].dims=dims
flista[j].pos=0  ; note, each subset data has only one band, which is 0, so you can use this to indicate

;-------save info of each subset ndvi_bq file------------
envi_file_query,rt_bq_fid,dims=dims,nb=nb,fname=fn,data_type=data_bq_dt

;p1=strpos(fn_bq,sign,/reverse_search)
;tmpbname= strmid(fn_bq,p1+11,12)
;tmpbname= strmid(fn_ndvi,p1+7,12)   ; for old data, its name looks like:MT3RG_2008_253-259_250m_composite_ndvi.tif

flistq[j].fn=fn_bq+'.good'
flistq[j].bname=tmpbname
flistq[j].fid=rt_bq_fid
flistq[j].dims=dims
flistq[j].pos=0  ; note, each subset data has only one band, which is 0, so you can use this to indicate

endif   ; have ndvi and ndvi_bq pair files


endfor

;---- layer stacking ndvi and ndvi_bq together ------------------

flista=[flista,flistq]  ; stacking total 42*2 files, first half are ndvi files, second half are bq files


; Set the output projection and
  ; pixel size from the TM file. Save
  ; the result to disk and use floating
  ; point output data.
  ;

  ;fist file id is flist[0].fid

  out_proj = envi_get_projection(fid = flista[0].fid, $
    pixel_size=out_ps)

  out_name = wrkdir+year+'_oneyear_layer_subset_good'

  out_dt = data_dt

  ;
  ; Call the layer stacking routine. Do not
  ; set the exclusive keyword allow for an
  ; inclusive result. Use cubic convolution
  ; for the interpolation method.
  ;
 ; envi_doit, 'envi_layer_stacking_doit', $
 ;   fid=fid, pos=pos, dims=dims, $
 ;   out_dt=out_dt, out_name=out_name, $
 ;   interp=2, out_ps=out_ps, $
 ;   out_proj=out_proj, r_fid=r_fid
  ;

 envi_doit, 'envi_layer_stacking_doit', $
    fid=flista.fid, pos=flista.pos, dims=flista.dims,/EXCLUSIVE, $
    out_dt=out_dt, out_name=out_name,out_bname=flista.bname, $
    interp=2, out_ps=out_ps, $
    out_proj=out_proj, r_fid=tot_layer_fid


;---- delete good_* files

num=(size(flista))(1)

for j=0L,num-1 do begin

envi_file_mng,id=flista[j].fid,/remove,/delete

endfor



print,'finishing ndvi and ndvi_bq layer stacking, subset...'

envi_batch_exit

return

end
