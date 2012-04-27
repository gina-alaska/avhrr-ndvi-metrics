PRO CatList, suffix, catfile

;
; This procedure concatenates files with the same suffix
; into a single file.
;
; Example:  suffix= 'img'
;           catfile= 'sahel10d.img'
;
; Call using:
;
;     catlist, '*.img', 'sahel10d.img'
;
; Note, this will concatenate ALL files ending in .img
;  found in the working directory in to the file sahel10d.img
;

Command= 'ls -1 '+suffix
spawn, command, list

n=n_elements(list)
for i = 0, n-1 DO BEGIN
   command=' cat '+list[i]+' >> '+catfile
   spawn, command
END
END
