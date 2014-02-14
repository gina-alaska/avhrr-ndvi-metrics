;jzhu, 9/8/2011, this progranm read a pair of files (ndvi and ndvi_bq), and stack, subset, return two file describers
 
pro read_ndvi, t_fn, d_fn, c_fn, ul, lr, rt_ndvi_fid,rt_bq_fid, rt_cldm_fid

;inputs:
;t_fn (file name of a *ndvi.tif file, d_fn (file name of a *_bq.tif), c_fn (file name of *_cldm.tif) 
;ul (uper left coordinate in unit of meter),
;lf (lower right coorinate in unit of meter).
;output: rt_fid,rt_bq_fid, rt_cldm_fid


;---subseting the file
;ul=[-160.0, 62.0]  ; [lon,lat] of upper left
;lr=[-146.0, 56.0]  ; [lon,lat] of lower right

;--- check t_fid, found map unit of t_fid is meters, so we define ul and lr in meters

;ul=[-206833.75D, 1303877.50D]
;lr=[ 424916.25D,  856877.50D]


if !version.os_family EQ 'Windows' then begin
sign='\'
endif else begin
sign='/'
endelse


;---- initial batch mode

p =strpos(t_fn,sign,/reverse_search)

wrkdir=strmid(t_fn,0,p+1)

;start_batch, wrkdir+'b_log',b_unit

;----test only 

;file_ndvi ='MT3RG_2010_106-112_250m_composite_ndvi.tif'
;file_bq   ='MT3RG_2010_106-112_250m_composite_ndvi_bq.tif'

;---open file ndvi data file, t_fn

envi_open_data_file,t_fn,r_fid=t_fid


if (t_fid EQ -1) then begin

  rt_ndvi_fid=-1
  return

endif

envi_file_query,t_fid,dims=t_dims,nb=t_nb,ns=t_ns,nl=t_nl,data_type=data_dt

;---subset
if (size(ul))(0) EQ 0 and (size(lr))(0) EQ 0 then begin ; do not do subset

tsubset_fid=t_fid

endif else begin   ; do subset

;----- subseting the file
subset,t_fid,ul,lr,wrkdir,tsubset_fid ;after exectuate this sunroutine, return file id of subset_image which is stored in memory

endelse

;---output the file

envi_file_query, tsubset_fid, DIMS=DIMS, NB=NB, NL=NL, NS=NS

pos = lindgen(nb)

;---- envi_get_data just can get one band each time, so use loop to get all bands
;image=intarr(NS, NL, NB)

image=envi_get_data(fid=tsubset_fid, dims=dims, pos=pos )

;---output image_ndvi and image_bq into two files

data_type=data_dt  ; byte type

map_info=envi_get_map_info(fid=tsubset_fid)

;--- output image_ndvi
out_ndvi_name = wrkdir+'good_ndvi'+strtrim(string(tsubset_fid),2)

envi_write_envi_file, image, data_type=data_type, $
descrip = 'good_ndvi', $
map_info = map_info,out_name=out_ndvi_name, $
nl=nl, ns=ns, nb=1, r_fid=rt_ndvi_fid


;---open file ndvi data quanlity file, d_fn

ENVI_OPEN_FILE,d_fn,R_FID=d_fid

if (d_fid EQ -1) then begin

  rt_bq_fid=-1
  
  return

endif
  
  
envi_file_query,d_fid,dims=d_dims,nb=d_nb,ns=d_ns,nl=d_nl,data_type=data_dd

;---subset 
if (size(ul))(0) EQ 0 and (size(lr))(0) EQ 0 then begin ; do not do subset
dsubset_fid=d_fid
endif else begin   ; do subset
subset,d_fid,ul,lr,wrkdir,dsubset_fid ;after exectuate this sunroutine, return file id of subset_image which is stored in memory
endelse

;----output qa file

envi_file_query, dsubset_fid, DIMS=DIMS, NB=NB, NL=NL, NS=NS

pos = lindgen(nb)

;---- envi_get_data just can get one band each time, so use loop to get all bands
;image=intarr(NS, NL, NB)

image=envi_get_data(fid=dsubset_fid, dims=dims, pos=pos)

out_bq_name=wrkdir+'good_bq'+strtrim(string(dsubset_fid),2)

envi_write_envi_file, image, data_type=data_type_dd, $
descrip = 'good_bq', $
map_info = map_info,out_name=out_bq_name, $
nl=nl, ns=ns, nb=1, r_fid=rt_bq_fid

;---open file cld mask file, c_fn

ENVI_OPEN_FILE,c_fn,R_FID=c_fid

if (c_fid EQ -1) then begin

  rt_cldm_fid=-1
  
  return
  
endif  
  

envi_file_query,c_fid,dims=c_dims,nb=c_nb,ns=c_ns,nl=c_nl,data_type=data_dc


;---determine if doing subset

if (size(ul))(0) EQ 0 and (size(lr))(0) EQ 0 then begin ; do not do subset

csubset_fid=c_fid
endif else begin   ; do subset

;----- subseting the file
subset,c_fid,ul,lr,wrkdir,csubset_fid ;after exectuate this sunroutine, return file id of subset_image which is stored in memory

endelse

;---- output cld mask file

envi_file_query, csubset_fid, DIMS=DIMS, NB=NB, NL=NL, NS=NS

pos = lindgen(nb)

;---- envi_get_data just can get one band each time, so use loop to get all bands
;image=intarr(NS, NL, NB)

image=envi_get_data(fid=csubset_fid, dims=dims, pos=pos )

;---output image_ndvi and image_bq into two files


map_info=envi_get_map_info(fid=tsubset_fid)

;--- output image_ndvi

out_cldm_name = wrkdir+'good_cldm'+strtrim(string(csubset_fid),2)

envi_write_envi_file, image, data_type=data_dc, $
descrip = 'good_cldm', $
map_info = map_info,out_name=out_cldm_name, $
nl=nl, ns=ns, nb=1, r_fid=rt_cldm_fid


;---free memory and also delete temperary files, layer_* and subset_*

image=0

envi_file_mng,id=t_fid,/remove
envi_file_mng,id=d_fid,/remove
envi_file_mng,id=c_fid,/remove

return

end






