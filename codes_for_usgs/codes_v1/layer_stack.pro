pro layer_stack, flistn, outfilen
;This program do layer_stack for files in the file list
;inputs: flist which includes file names to be layer_stacking, outfilen---file name of layer_stacked file

if !version.os_family EQ 'Windows' then begin
sign='\'
endif else begin
sign='/'
endelse

;wrkdir='/home/jiang/scratch/EMODIS-NDVI-DATA/wrk/ver_old/2008'

;------- test

flistn='/home/jiang/scratch/EMODIS-NDVI-DATA/wrk/ver_old/2008/2008_oneyear_flist'

outfilen='/home/jiang/nps/cesu/modis_ndvi_250m/wrkdir/2008_multiyear_layer_stack'

;------------------------------------------------

p =strpos(flistn,sign,/reverse_search)

len=strlen(flistn)

wrkdir=strmid(flistn,0,p+1)

year=strmid(flistn,p+1,4)


outfilen=wrkdir+year+'_multiyear_layer_stack'


start_batch, wrkdir+'b_log',b_unit


 ;---- read file name from file list

openr,u1,flistn,/get_LUN

;---
flist=strarr(20) ;  20 years
tmp=' '
j=0L
while not EOF(u1) do begin
readf,u1,tmp

flist(j)=tmp
j=j+1
endwhile

;---
flist =flist[where(flist NE '')]

;---- get the number of files

num=(size(flist))(1)

;---- get workdir and year

;p =strpos(flist(0),'/',/reverse_search)
;len=strlen(flist(0))
;wrkdir=strmid(flist(0),0,p+1)
;filen =strmid(flist(0),p+1,len-p)
;len1=strlen(filen)
;year=strmid(filen,len1-4,4)




;------ define struc array to store file ids

;x={flist,fn:'abc',bname:'abc',fid:0L,dims:lonarr(5),pos:0L}
;flista=replicate(x,num)

;fid_lst=lonarr(num)
;nb_lst=lonarr(um)
;dim_lst=lonarr(5)
;fname_lst=strarr(num)

fid_lst=lonarr(num)
nb_lst=lonarr(num)


for j=0l,num-1 do begin
;------ read the fid and layer

ENVI_OPEN_FILE,flist(j),R_FID=rt_fid,/no_realize,/NO_INTERACTIVE_QUERY

envi_file_query,rt_fid,dims=dims,nb=nb,fname=fn,bnames=bnames,data_type=data_dt

fid_lst(j)=rt_fid

nb_lst(j)=nb



endfor

;---- get tot_nb, re go over the loop to get the banme, pos,and other parameters

tot_nb=total(nb_lst)
tot_fid=lonarr(tot_nb)
tot_pos=lonarr(tot_nb)
tot_bname=strarr(tot_nb)
tot_dims=lonarr(5,tot_nb)

for j=0l, num-1 do begin

envi_file_query,fid_lst(j),dims=dims,nb=nb,fname=fn,bnames=bnames,data_type=data_dt

if j EQ 0L then begin
nb_prev=nb_lst(j)
endif else begin
nb_prev=nb_lst(j-1)
endelse

for i=0l, nb -1 do begin
tot_fid[j*nb_prev+i]=fid_lst[j]
tot_pos[j*nb_prev+i]=i
tot_bname[j*nb_prev+i]=strtrim(string(j),2 ) +'_'+ bnames[i]
tot_dims[*, j*nb_prev+i]=dims

endfor

endfor




;---- layer stacking------------------

  ; Set the output projection and
  ; pixel size from the first file. Save
  ; the result to disk and use integer
  ; point output data.
  ;

out_proj = envi_get_projection(fid=fid_lst[0], $
    pixel_size=out_ps, units=out_units )

  ;out_name = wrkdir+'layer_stack'

  out_name=outfilen

  out_dt = data_dt  ; integer
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
    fid=tot_fid, pos=tot_pos, dims=tot_dims,/EXCLUSIVE, $
    out_dt=out_dt, out_name=out_name,out_bname=tot_bname, $
    interp=2, out_ps=out_ps, $
    out_proj=out_proj, r_fid=tot_layer_fid


;---- delete good_* files


for j=0L,num-1 do begin

envi_file_mng,id=fid_lst,/remove

endfor


print,'finishing data layer stacking, output file: ' +outfilen


envi_batch_exit

return


end
