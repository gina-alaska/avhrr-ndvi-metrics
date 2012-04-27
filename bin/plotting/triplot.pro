PRO triplot, data, LABEL=label, XMIN=xmin, XMAX=xmax

DataSize = Size(data)
NCol = DataSize(1)
NRow = DataSize(2)

;
; If LABEL keyword is not set, set them to blank strings
;
IF ( KEYWORD_SET(label)) THEN $
   label = label $
ELSE BEGIN
   label = strarr(NCol)
   for Col = 0, NCol-1 DO BEGIN
      label(Col) = ""
   ENDFOR
ENDELSE

;
; If XMIN keyword is not set, set it to min of each column
;
IF (KEYWORD_SET(xmin)) THEN $
   xmin = xmin $
ELSE BEGIN
   xmin = fltarr(NCol)
   for Col = 0, NCol-1 DO BEGIN
      xmin(Col) = min(data(col))
   ENDFOR
ENDELSE

;
; If XMAX keyword is not set, set it to max of each column
;
IF (KEYWORD_SET(xmax)) THEN $
   xmax = xmax $
ELSE BEGIN
   xmax = fltarr(NCol)
   for Col = 0, NCol-1 DO BEGIN
      xmax(Col) = max(data(col))
   ENDFOR
ENDELSE

!P.Multi = [0, NCol-1, NCol-1]

 A = FINDGEN(32) * (!PI*2/32.)
USERSYM, COS(A)*.5, SIN(A)*.5;, /FILL

for Row = 0, NCol-2 DO BEGIN

   for Col = 1, NCol-1 DO BEGIN

      IF (Col GT Row) THEN BEGIN
      
         plot, data(Col,*), data(Row, *), psym=8, $
               xtitle=label(Col),  ytitle=label(Row), $
               xrange=[xmin(col),xmax(col)], $
               yrange=[xmin(row),xmax(row)]

      ENDIF ELSE noplot
   ENDFOR
ENDFOR

END

