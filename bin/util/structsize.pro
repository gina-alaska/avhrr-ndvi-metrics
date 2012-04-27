FUNCTION StructSize, structure
;
; This function determines the actual number of bytes taken up
; by the elements of a structure.  Note: a structure's LENGTH
; is padded up to the next 8bytes for a 64-bit machine, 4bytes
; for a 32-bit machine, etc.
;

nnames=n_tags(structure)

ssize=0L

for i = 0, nnames-1 DO BEGIN

  sizeof=size(structure.(i))
  nelem =n_elements(sizeof)

  IF (sizeof[nelem-2] EQ 7) THEN BEGIN             ; If element is string
     ADD = long(total(strlen(structure.(i))))      ; total handles arrays
  END ELSE IF (sizeof[nelem-2] EQ 8) THEN BEGIN    ; If element is structure
     ADD = StructSize(structure.(i))*sizeof[nelem-1] ; handles arrays 
  END ELSE BEGIN 
     ADD = sizeof[nelem-1]*sizeofdt(sizeof[nelem-2])
  END
  ssize = ssize + ADD

end


Return, ssize
END
