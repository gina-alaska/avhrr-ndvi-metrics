PRO   readlist, listfile,nim,  path,  imgname

;=== READ FILE CONTAINING LIST OF IMAGES
;   nim             ; number of images
;   path            ; path to image files
;   files...        ; image file list
;
; see READLIST2 if you want to read in imgdim and classimg
;
 
openr,1, listfile
 
readf,1,nim

path = strarr(1)
readf,1,path
 
imgname=strarr(nim)
readf,1,imgname
 
close,1

end
