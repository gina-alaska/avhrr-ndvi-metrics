;
; This function replaces the last 26 values in the current
; color table with colors defined below
;
;
; 230:    0   0   0  ;BLACK
; 231:  255   0   0  ;RED
; 232:    0 255   0  ;GREEN
; 233:    0   0 255  ;BLUE
; 234:  255 255   0  ;YELLOW
; 235:    0 255 255  ;CYAN
; 236:  255   0 255  ;MAGENTA
; 237:  128   0   0  ;DARK_RED
; 238:    0 128   0  ;DARK_GREEN
; 239:    0   0 128  ;DARK_BLUE
; 240:  128 128   0  ;GOLD
; 241:    0 128 128  ;TEAL
; 242:  128   0 128  ;PURPLE
; 243:  255 128   0  ;ORANGE
; 244:  255   0 128  ;HOTPIN
; 245:    0 255 128  ;MINTGREEN
; 246:  128 255   0  ;NEONGREEN
; 247:    0 128 255  ;SKYBLUE
; 248:  128   0 255  ;VIOLET
; 249:   64  64  64  ;DARKGRAY
; 250:  128 128 128  ;MEDGRAY
; 251:  192 192 192  ;LIGHTGRAY
; 252:  255 255 255  ;WHITE
; 253:  255 255 255  ;WHITE
; 254:  255 255 255  ;WHITE
; 255:  255 255 255  ;WHITE
;

FUNCTION UpdateCT

   CurrentCT=lonarr(256,3)
   tvlct, CurrentCT, /GET
   NewCT=CurrentCT
   
R=[0, 255, 0, 0, 255, 0, $
   255, 128, 0, 0, 128, $
   0, 128, 255, 255, 0, $
   128, 0, 128, 64, 128,$
   192, 255, 255, 255, 255]
   
G=[0, 0, 255, 0, 255,  255, $
   0, 0, 128, 0, 128, $
   128, 0, 128, 0, 255, $
   255, 128, 0, 64, 128, $
   192, 255, 255, 255, 255]

B=[0, 0, 0, 255, 0, 255, $
    255, 0, 0, 128, 0, $
    128, 128, 0, 128, 128, $
    0, 255, 255, 64, 128, $
    192, 255, 255, 255, 255]

NewCT[230:255,0]=R
NewCT[230:255,1]=G
NewCT[230:255,2]=B

  tvlct, NewCT
RETURN, NewCT
END
