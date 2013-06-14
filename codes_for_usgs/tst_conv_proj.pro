;test projection conversion

pro tst_conv_proj

filen = '/mnt/jzhu_scratch/nps-cesu/avhrr/ak_nd_1982'


filen2='/hub/tub/nps-cesu/ndvi_metrics/2001_oneyear_layer_subset_good_metrics_ver16m1_3'

;---make sure the program can work in both windows and linux.

if !version.OS_FAMILY EQ 'Windows' then begin

sign='\'

endif else begin
sign='/'

endelse

;----1. produces output metrics file name

p =strpos(filen,sign,/reverse_search)

len=strlen(filen)

wrkdir=strmid(filen,0,p+1)

filebasen=strmid(filen,p+1,len-p)

year=strmid(filebasen,6,4)

;----define output file name 

filen_out=wrkdir+filebasen+'_tst_conv_proj'

;openw,unit_metrics,fileout_metrics,/get_lun

start_batch, wrkdir+'b_log',b_unit

;---setup a flag to inducate this program work successful. flg=0, successful, flg=1, not successful

flg=0;  0----successs, 1--- not sucess

;---2. open the input files

envi_open_file,filen,/NO_REALIZE,r_fid=rt_fid


if rt_fid EQ -1 then begin

flg=1  ; 0---success, 1--- not success

return  ;

endif

; read in filen2
envi_open_file,filen2,/NO_REALIZE,r_fid=rt_fid2


if rt_fid EQ -1 then begin

flg=1  ; 0---success, 1--- not success

return  ;

endif




;---open the input file
;envi_open_file,filen_sm,/NO_REALIZE,r_fid=rt_fid_sm
;if rt_fid_sm EQ -1 then begin
;flg=1  ; 0---success, 1--- not success
;return 
;endif


;---3. get the information of the input file

envi_file_query, rt_fid,data_type=data_type, xstart=xstart,ystart=ystart,$
                 interleave=interleave,dims=dims,ns=ns,nl=nl,nb=nb,bnames=bnames

pos=lindgen(nb)

map_info=envi_get_map_info(fid=rt_fid)

;----- get map infor from filen2

envi_file_query, rt_fid2,data_type=data_type2, xstart=xstart2,ystart=ystart2,$
                 interleave=interleave2,dims=dims2,ns=ns2,nl=nl2,nb=nb2,bnames=bnames2

pos2=lindgen(nb2)

map_info2=envi_get_map_info(fid=rt_fid2)

o_proj2=envi_get_projection(fid=rt_fid2)


envi_convert_file_map_projection,fid=rt_fid,pos=pos,dims=dims,o_proj=o_proj2, o_pixel_size=[5600,5600],out_name=filen_out, warp_method=0,resampling=1,background=0



ENVI_BATCH_EXIT

return

end
