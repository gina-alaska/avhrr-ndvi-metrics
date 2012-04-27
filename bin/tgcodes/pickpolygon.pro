PRO   pickpolygon, xloc, yloc, DEVICE=device, DATA=data

on_error, 2
orderin = !order

print, "Push left or middle button to select point..."
print, "Push right button to exit..."

device =  KEYWORD_SET(DEVICE)
data = KEYWORD_SET(DATA)

IF(Data) THEN BEGIN
  x=fltarr(1) 
  y=fltarr(1) 
  !ORDER = 0      ; FOR PLOTS, ALWAYS USE !ORDER = 0
ENDIF ELSE BEGIN
 x=intarr(1) 
 y=intarr(1) 
ENDELSE

!err=0

i = 0


;
; Grab first point
;

CURSOR, x0, y0, /wait, data = data, device=device
wait,1 

x(0) = x0
y(0) = y0

;
; PRINT FIRST POINT
;

IF (!ORDER EQ 1) THEN print, i, x(i), !D.Y_Size - y(i) - 1 $
ELSE print, i, x(i), y(i)

;
; Continue grabbing points.  Don't stop until right button
; is pushed.
;

CURSOR, x0, y0, /wait, data = data, device=device
wait, 1

WHILE !err ne 4 DO BEGIN
   x = [x,x0]
   y = [y,y0]

   i = i+1

;
; PRINT POINT i
;

   IF (!ORDER EQ 1) THEN print, i, x(i), !D.Y_Size - y(i) - 1 $
   ELSE print, i, x(i), y(i)


;
; CONNECT POINTS ON IMAGE
;

   plots, [x(i), x(i-1)], [y(i),y(i-1)], color=rgb(255,255,255), $
       data = data, device=device
;
; GRAB A POINT.  DO I CONTINUE OR END?
;

   CURSOR, x0, y0, /wait, data = data, device=device
   wait, 1

ENDWHILE

x = [x,x(0)]
y = [y,y(0)]

i=i+1

;
; CONNECT LAST AND FIRST POINTS
;
plots, [x(i), x(i-1)], [y(i),y(i-1)], color=rgb(255,255,255), $
       data = data, device=device

;
; REDO MY Y'S IF !ORDER IS 1
;

IF (!ORDER EQ 1) THEN BEGIN
  xloc = x
  yloc = !D.Y_Size - y - 1
ENDIF ELSE BEGIN
  xloc = x
  yloc = y
ENDELSE


!order=orderin

print, ""

END
