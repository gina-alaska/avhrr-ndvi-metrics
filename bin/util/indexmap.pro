FUNCTION  IndexMap, InData, Map

;
; NAME
;   IndexMap
;
; PURPOSE
;   This function grabs the InData specified by a Map of indicies.
;   It is useful for getting data from the X/Y plane of a cube using
;   a map of Z locations.
;

      inSize=Size(InData)
      mapSize=Size(Map)
     nMap=N_Elements(Map)

     Index=lindgen(nMap)

     OutData=Make_Array(Size=mapSize, $
                        Type=inSize[inSize[0]+1]) 
     RealMap=Map*nMap + Index

     OutData=InData[RealMap]

Return, OutData
END
