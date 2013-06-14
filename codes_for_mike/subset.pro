pro SUBSET, fid, ul,lr,wrkdir,subset_fid
;file with fid to be subset
;ul=[lon,lat] of upper left
;lr=[lon,lat] of lower right, ul and lr define the map coordinates to subset

;envi, /restore_base_save_files
;envi_batch_init,log_file='batch.txt'

; define the image to be opened
;img_file='F:\IMAGE\NDVI-HDF\try\NDVI_2008_03_02.img'
;envi_open_file,img_file,r_fid=fid
;if (fid eq -1) then begin
;envi_batch_exit
;return
;endif

;XMap=[ul[1],lr[1]]       
;YMap=[ul[0],lr[0]]

;---- convert lon, lat coordinate into map coorinate of projection of fid

iproj=envi_proj_create(/geographic)

oproj=envi_get_projection(fid=fid)

ix=[ul[0],lr[0] ]
iy=[ul[1],lr[1] ]

envi_convert_projection_coordinates,ix,iy,iproj,oxmap,oymap,oproj

;ul[0]=oxmap(0)
;ul[1]=oymap(0)
;lr(0)=oxmap(1)
;lr(1)=oymap(1)


;--------- convert xmap, ymap into ul

ENVI_CONVERT_FILE_COORDINATES, FID,x0,y0 ,oxmap(0),oymap(0)

ENVI_CONVERT_FILE_COORDINATES, FID, x1,y1,oxmap(1),oymap(1)


XF=round([x0,x1] )
YF=round([y0,y1] )

dims_sub=[-1L,xf(0),xf(1),yf(0),yf(1)]

envi_file_query, fid, DIMS=DIMS, NB=NB, NL=NL, NS=NS

pos = lindgen(nb)

rfact=[1,1] ;must keep [1,1], otherwise, subset image does not match orginal image

out_name=wrkdir+'subset_'+strtrim(string(fid),2)

envi_doit,'resize_doit',dims=dims_sub,fid=fid,out_name=out_name,pos=pos,rfact=rfact,interp=0,r_fid=subset_fid

;---- envi_get_data just can get one band each time, so use loop to get all bands
;image=intarr(NS, NL, NB)
;FOR i=0, NB-1 DO BEGIN
;image[*,*,i]= envi_get_data(fid=fid, dims=dims, pos=pos[i])
;endfor

;-----make sure xf and yf are in the range of ns and nl

;if xf[1] GT ns-1 then xf[1]=ns-1
;if yf[1] GT nl-1 then yf[1]=nl-1

;imagen= image[XF[0]:XF[1],YF[0]:YF[1],*]

;nl2=YF[1]-YF[0]+1
;ns2=XF[1]-XF[0]+1

;---- subsize will make the map_info change, UL map and geo will change

;map_info=envi_get_map_info(fid=fid)

;out_name=wrkdir+'subset_'+strtrim(string(fid),2)

;envi_write_envi_file, imagen, data_type=2, $
;descrip = 'subset_image', $
;map_info = map_info, out_name=out_name,$
;nl=nl2, ns=ns2, nb=nb, r_fid=subset_fid
;---free memory 
;image=0
;imagen=0





return

end