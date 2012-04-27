;===   PROGRAM - GETCLASSES   ==============================
; This program gets the class numbers and number of pixels
; in those classes from the n_classes most popular classes
; of the class image, tmc.  It sorts them according to 
; number of elements from high to low
;=========================================================== 


PRO   getclasses, tmc, n_classes, classes, n_inclasses


nonzero_n = intarr(256)
class_i = intarr(265)

classes = intarr(n_classes)

i = 0

for j=0,255 do begin
   class = where(tmc eq j,n)
   if(n gt 0) then begin
      nonzero_n(i) = n 
      class_i(i) = j
      i = i+1
   endif
endfor
tmpn = nonzero_n(reverse(sort(nonzero_n)))
tmpc = class_i(reverse(sort(nonzero_n)))

classes = tmpc(0:n_classes-1)
n_inclasses = tmpn(0:n_classes-1)

end

