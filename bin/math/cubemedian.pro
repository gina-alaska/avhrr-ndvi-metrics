FUNCTION CubeMedian, data, MASK=MASK

on_error, 2
s=size(data)

ns=s[1]
nl=s[2]

s[3]=1
med=Make_Array(Size=s)

for i=0, ns-1 DO BEGIN
   for j=0, nl-1 DO BEGIN

      IF (N_Elements(MASK) NE 0) THEN BEGIN    ;IF Mask is set
         valid=where(data[i,j,*] NE MASK, nv)  ;grab valid points
         if (nv EQ 0) then valid = 0
      END ELSE valid=where(data[i,j,*] EQ data[i,j,*]) ;IF no mask, use all 

      med[i,j]=median(data[i,j,valid])

   endfor
endfor

return, med
end
