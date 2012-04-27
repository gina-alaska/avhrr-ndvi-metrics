FUNCTION ReadCT, FILE, numColors=numcolors, Columns=Columns
;
; This function reads set of NUMCOLORS RGB color triplets from FILE
;
; DATE: 4/18/99
;

   IF(N_Elements(numColors) EQ 0) THEN numColors=256
   IF(N_Elements(Columns) EQ 0) THEN Columns=4

   OpenR, LUN, FILE, /GET_LUN
   ct=lonarr(numColors,Columns)
   tmp=lonarr(Columns)

   for i=0, numcolors-1 DO BEGIN
      ReadF, LUN, tmp
      CT[i,*]=tmp
   ENDFOR
   Free_LUN, LUN

   IF (Columns EQ 4) THEN CT=CT[*,1:3]

   TVLCT, CT

Return, CT
END
