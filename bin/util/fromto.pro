FUNCTION FromTo, InData, StartMap, EndMap, FILL=FILL, FIRSTBAND=FirstBand, $
         LASTBAND=LastBand, FIRSTLOC=FirstLoc, LASTLOC=LastLoc, LastIdx=LastIdx
;
;  NAME:
;     FromTo
;
;  PURPOSE:
;     This will generate an output array of InData((*,*),StartMap:EndMap)
;     Where StartMap and EndMap are the maps of indices into InData.
;     The result can have different numbers of elements in the first 
;     dimensions.  The remaining data points are filled with the value
;     given by the FILL keyword (default=-1)
;
;  CATEGORY:
;     Data Handling Utility
;
;  CALLING SEQUENCE:
;
;  INPUTS:
;     InData- 2d or 3d array
;     StartMap- Array of 1 less dimension than InData containing the
;             starting indices
;     ENDMap- Array of 1 less dimension than InData containing the
;             ending indices
;
;  KEYWORDS:
;     FILL- value to use for unfilled points (default=-1)
;
;  OUTPUTS:
;     OutData- Output array of same first dimension(s) as inData, but
;             last dimension only as big as necessary
;
;  COMMON BLOCKS:
;     NONE
;
;  LIMITATIONS:
;     Can only handle 2D & 3D InData
;

   


;
; Get some sizes
;
;   MapNotNull = where(EndMap ge 0 and StartMap ge 0, nMapNotNull)
;MJS 11/12/98
   MapNotNull = where(EndMap ge 0 and StartMap ge 0 and $
                       EndMap gt StartMap, nMapNotNull)
   inSize=Size(InData)

   outSize=InSize
if (nMapNotNull GT 0) THEN $
   outSize[inSize[0]]=Max(EndMap[MapNotNull]-StartMap[MapNotNull])+1+$
      KEYWORD_SET(FIRSTBAND)+KEYWORD_SET(LASTBAND) $
ELSE OutSize=InSize
;
; Check KEYWORDS
;
   IF(N_Elements(FILL) EQ 0) THEN FILL=-1
   
;
; Initialize some Arrays
;
   OutData=Make_Array(Size=outSize)+FILL
   Index=lindgen(inSize[inSize[0]+2]/inSize[inSize[0]])  ; index 0~ns*nl-1
   nIdx=N_Elements(Index)
   CurIdx=Make_Array(Size=Size(StartMap))
   IF(N_Elements(FIRSTBAND) EQ 0) THEN $
      FIRSTBAND=Make_Array(Size=Size(StartMap))+FILL $
   ELSE BEGIN
;      OutData[CurIdx]=FirstBand
      OutData[*,*,0]=FirstBand
      CurIdx=CurIdx+1
   END

   IF(N_Elements(LASTBAND) EQ 0) THEN BEGIN
      LASTBAND=Make_Array(Size=Size(StartMap))+FILL 
      NoLastBand=1
   END ELSE NoLastBand=0


;
; Start loop on bands
;
   FOR i = 0, inSize[inSize[0]]-1 DO BEGIN

;
; Specify 2D or 3D array
;
      CASE (inSize[0]) OF
        2: inTmp=InData[*,i]
        3: inTmp=InData[*,*,i]
        ELSE:
      ENDCASE

;
; Find where index is between start and end
;
if(N_elements(FIRSTLOC) GT 0 and N_ELements(LastLoc) GT 0) THEN BEGIN
;      inIdx = where(StartMap LE i AND i LE EndMap AND $
;                    (StartMap NE FIRSTLOC AND EndMap NE LASTLOC) , nInIdx)
      inIdx = where(FIRSTLOC LT i AND i LT LASTLOC, nInIdx)
END ELSE $
      inIdx = where(StartMap LE i AND i LE EndMap , nInIdx)


;
; Extract to output and update current z-index
;
      IF (nInIdx GT 0) THEN BEGIN

         OutIdx=CurIdx[inIdx]*nIdx + inIdx
         OutData[OutIdx]=InTmp[inIdx]

         CurIdx[InIdx]=CurIdx[InIdx] +1

      END;IF
   END;FOR

   IF(NOT  NoLastBand) THEN BEGIN
      OutIdx=CurIdx*nIdx + Index
      OutData[OutIdx]=LastBand
   ENDIF

LastIdx=CurIdx-1
Return, OutData
END
