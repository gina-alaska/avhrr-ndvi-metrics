FUNCTION  Max3D, InData, ZLOCATION=ZLocation

; NAME
;   Max3D
;
; PURPOSE
;   This function returns the Z-dimension maxima for a 3D array
;   resulting in a 2D array
;

      inSize=Size(InData)

; Initialize starting values and Location

      OutData=Make_Array(Dimension=[inSize[1], inSize[2]])
      OutData=InData[*,*,0]

      ZLocation=lonarr(inSize[1], inSize[2])

; Use > in z loop to find maxima

      For i = 0L, inSize[inSize[0]]-1 DO BEGIN
         Index=where(OutData LT InData[*,*,i], nIndex)
         OutData=OutData>InData[*,*,i]
         IF (nIndex GT 0) THEN ZLocation[Index] = i
      END; For i
      



Return, OutData
END
