FUNCTION  Trap3D, InData, FILL=Fill, NOFILL=NoFill, LASTMAP=LastMap, $
          STARTX=StartX, STARTY=StartY, ENDX=EndX, ENDY=EndY
;
; This function performs a trapezoid rule integration in the z
; direction of a 3D array
;

      inSize=Size(inData)
      InDataTMP=InData

      if (N_Elements(FILL) GT 0) THEN BEGIN
         FillIdx=where(InDataTMP EQ FILL, nFillIdx)
         IF nFillIdx GT 0 THEN  InDataTMP[FillIdx] = 0
      END

      CASE (inSize[0]) OF
         2: BEGIN

            FirstIn=InDataTMP[*,0]
            IF(N_Elements(LASTMAP) LE 0) THEN $
               LASTMAP=lonarr(inSize[1])+inSize[2]-1

            LastIn=IndexMap(InDataTMP, LastMap)

         END;2
         3: BEGIN
   
            FirstIn=InDataTMP[*,*,0]
   
            IF(N_Elements(LASTMAP) LE 0) THEN $
               LASTMAP=lonarr(inSize[1], inSize[2])+inSize[3]-1
   
            LastIn=IndexMap(InDataTMP, LastMap)
   
         END;3
         ELSE:
      ENDCASE

      
      InnerInt= -(FirstIn + LastIn)/2 + Total(InDataTMP, inSize[0])

      IF(N_Elements(STARTX) NE 0 AND N_ELements(STARTY) NE 0) THEN $
         OuterIntStart= (StartY+FirstIn)*(ceil(StartX)-StartX)/2. $
      ELSE $
         OuterIntStart=0

      IF(N_Elements(ENDX) NE 0 AND N_ELements(ENDY) NE 0) THEN $
         OuterIntEnd= (EndY+LastIn)*(EndX-floor(EndX))/2. $
      ELSE $
         OuterIntEnd=0

RETURN, InnerInt + OuterIntStart + OuterIntEnd
END
