FUNCTION PadNDVI, NDVI, bpy
;
; For NDVI time series where the final year is not complete,
; this routine pads the final year with data from the first
; year.
;

SizeND=Size(NDVI)
Dim=SizeND[0]
nb = SizeND[Dim]

cb= nb mod bpy

CASE DIM OF
   1: padndvi=[ndvi,ndvi[cb:bpy-1]]
   3: padndvi=[[[ndvi]],[[ndvi[*,*,cb:bpy-1]]]]
   ELSE:
ENDCASE

return, padndvi
end
