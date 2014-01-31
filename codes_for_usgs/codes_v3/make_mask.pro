forward_function envi_get_roi_ids

pro make_mask

compile_opt idl2
envi,/restore_base_save_files
envi_batch_init,log_file='f:\working\batch.log',batch_lun=batch_lun


file=dialog_pickfile(title='choose file ..(*.img)',/read)
printf,batch_lun,'Begin Processing at' +systime()
envi_open_file,file,r_fid=fid
if (fid eq -1 ) then begin
envi_batch_exit
return
endif
envi_file_query,fid,ns=ns,nl=nl,nb=nb
dims=[-1,0,ns-1,0,nl-1]
pos=lindgen(nb)
;**************************************
;open evfs ,the test_evf has only one layer,baodi.shp
evf_fname='F:\test_.evf'
evf_id = envi_evf_open(evf_fname)
;
; Get the vector information
;
envi_evf_info, evf_id, num_recs=num_recs, $
data_type=data_type, projection=projection, $
layer_name=layer_name
;
; Print information about each record
;
print, 'Number of Records: ',num_recs
for i=0,num_recs-1 do begin
record = envi_evf_read_record(evf_id, i)
print, 'Number of nodes in Record ' + $
strtrim(i+1,2) + ': ', n_elements(record[0,*])

;fid refer to what?the orgin evfs or the img file
ENVI_CONVERT_FILE_COORDINATES,fid,record[0,*],record[1,*],xmap,ymap,/TO_MAP
;ENVI_CONVERT_FILE_COORDINATES,evf_id,record[0,*],record[1,*],

roi_id = ENVI_CREATE_ROI(ns=ns, nl=nl, $
color=4, name='evfs')
ENVI_DEFINE_ROI, roi_id, /polygon, $
xpts=reform(XMAP), ypts=reform(YMAP)
roi_ids = envi_get_roi_ids()
envi_save_rois, 'f:\working\test.roi', roi_ids
if (roi_ids[0] eq -1) then return
;
; Set the necessary variables
;
out_name = 'f:\working\baodi_mask_2'
class_values = lindgen(n_elements(roi_ids))+1
;
; Call the doit
;
envi_doit, 'envi_roi_to_image_doit', $
fid=fid, roi_ids=roi_ids, out_name=out_name, $
class_values=class_values

endfor

;
; Close the EVF file
;
envi_evf_close, evf_id
;**************************************

envi_batch_exit

END