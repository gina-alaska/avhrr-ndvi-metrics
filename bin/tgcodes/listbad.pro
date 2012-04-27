;=== LISTBAD ================================
;  This procedure takes in a complete list of
;  single site images and separates good from
;  bad based on
;    1.)  Look angle
;    2.)  Zeroed data
;============================================

openw, BADFILES, "tg96.badlist", /GET_LUN
openw, GOODFILES, "tg96.goodlist", /GET_LUN


readlist, "tg96.masterlist", nim, path, imgname

for i = 0, nim-1 do begin

   databyte=imgread(path(0)+imgname(i), 100, 1200)
   data = avhrrunscale(databyte, /byte, /ref)
 
   satzenang = getband(data, 6)

   if(min(abs(satzenang) gt 57)) then begin
     printf, BADFILES, imgname(i) 
     flag = 'BAD'
   endif else begin
     printf, GOODFILES, imgname(i)
     flag = 'GOOD'
   endelse 


print, i, '   ',imgname(i), '   ',flag
  
endfor 

endloop:




FREE_LUN, BADFILES
FREE_LUN, GOODFILES
end
