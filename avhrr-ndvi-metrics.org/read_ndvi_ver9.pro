;jzhu, 9/8/2011, this progranm read a pair of files (ndvi and ndvi_bq), and stack, subset, return two file describers
 
pro read_ndvi_ver9, t_fn, d_fn, ul, lr, rt_fid,rt_bq_fid

;inputs:
;t_fn (file name of a *ndvi.tif file, d_fn (file name of a *ndvi_bq.tif)
;ul (uper left coordinate in unit of meter),
;lf (lower right coorinate in unit of meter).
;output: rt_fid,rt_bq_fid


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


if (t_fid NE -1) then begin

envi_file_query,t_fid,dims=t_dims,nb=t_nb,ns=t_ns,nl=t_nl,data_type=data_dt

endif else begin


return

endelse

;---open file ndvi data quanlity file, d_fn

ENVI_OPEN_FILE,d_fn,R_FID=d_fid

if (d_fid NE -1) then begin

envi_file_query,d_fid,dims=d_dims,nb=d_nb,ns=d_ns,nl=d_nl,data_type=data_dd

endif else begin

return

endelse

;---layer stack the two data and output the data into a out_file

file_id=[t_fid,d_fid]

  nb = t_nb + d_nb
  fid = lonarr(nb)
  pos = lonarr(nb)
  dims = lonarr(5,nb)
  ;
  for i=0L,t_nb-1 do begin
    fid[i] = t_fid
    pos[i] = i
    dims[*,i] = [-1,0,t_ns-1,0,t_nl-1]
  endfor
  ;
  for i=t_nb,nb-1 do begin
    fid[i] = d_fid
    pos[i] = i-t_nb
    dims[*,i] = [-1,0,d_ns-1,0,d_nl-1]
  endfor
  ;
  ; Set the output projection and
  ; pixel size from the TM file. Save
  ; the result to disk and use floating
  ; point output data.
  ;
  out_proj = envi_get_projection(fid=t_fid, $
    pixel_size=out_ps)

  tmp_layer_file = 'layer_'+strtrim(string(t_fid),2)

  out_name = wrkdir+tmp_layer_file

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
    fid=fid, pos=pos, dims=dims, $
    out_dt=out_dt, out_name=out_name, $
    interp=2, out_ps=out_ps, $
    out_proj=out_proj, r_fid=layer_fid
  ;


;---determine if doing subset

if (size(ul))(0) EQ 0 and (size(lr))(0) EQ 0 then begin ; do not do subset

subset_fid=layer_fid

endif else begin   ; do subset

;----- subseting the file

subset,layer_fid,ul,lr,wrkdir,subset_fid ;after exectuate this sunroutine, return file id of subset_image which is stored in memory

endelse

;---- fill snow,cloud,bad, and negative reflectance pixels with -4000

envi_file_query, subset_fid, DIMS=DIMS, NB=NB, NL=NL, NS=NS

pos = lindgen(nb)

;---- envi_get_data just can get one band each time, so use loop to get all bands
image=intarr(NS, NL, NB)
FOR i=0, NB-1 DO BEGIN
image[*,*,i]= envi_get_data(fid=subset_fid, dims=dims, pos=pos[i])
endfor

image_ndvi=image(*,*,0)

image_bq=byte( image(*,*,1) )

image_ndvi=byte((image_ndvi/100)+100) ; convert -10,000 to 10,000b into 0b to 200b

;---output image_ndvi and image_bq into two files

data_type=1  ; byte type
map_info=envi_get_map_info(fid=subset_fid)

;--- output image_ndvi
out_ndvi_name = wrkdir+'good_ndvi'+strtrim(string(layer_fid),2)

envi_write_envi_file, image_ndvi, data_type=data_type, $
descrip = 'good_ndvi', $
map_info = map_info,out_name=out_ndvi_name, $
nl=nl, ns=ns, nb=1, r_fid=good_fid

out_bq_name=wrkdir+'good_bq'+strtrim(string(layer_fid),2)

envi_write_envi_file, image_bq, data_type=data_type, $
descrip = 'good_bq', $
map_info = map_info,out_name=out_bq_name, $
nl=nl, ns=ns, nb=1, r_fid=good_bq_fid


;---return image with file id of good_fid,subsized, and only have good ndvi values

rt_fid=good_fid

rt_bq_fid=good_bq_fid

;---free memory and also delete temperary files, layer_* and subset_*

image=0
image_ndvi=0
image_bq=0


;---close two file-ids

envi_file_mng, id=layer_fid, /remove,/delete
envi_file_mng, id=subset_fid,/remove,/delete
envi_file_mng,id=t_fid,/remove
envi_file_mng,id=d_fid,/remove


return

end






