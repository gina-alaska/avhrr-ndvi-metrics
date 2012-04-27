PRO Animate, File, NS, NL, NB, DT, ASSOC=ASSOC

OpenR, LUN, File, /Get_LUN

CASE KEYWORD_SET(ASSOC) OF
   0: BEGIN
      CASE DT OF
         1: Data=bytarr(NS, NL, NB)
         2: Data=intarr(NS, NL, NB)
         3: Data=lonarr(NS, NL, NB)
         4: Data=fltarr(NS, NL, NB)
         ELSE:
      ENDCASE
      load, file, data
   END
   1: BEGIN
      CASE DT OF
         1: Data=Assoc(LUN, bytarr(NS, NL))
         2: Data=Assoc(LUN, intarr(NS, NL))
         3: Data=Assoc(LUN, lonarr(NS, NL))
         4: Data=Assoc(LUN, fltarr(NS, NL))
         ELSE:
      ENDCASE
   END
   ELSE:
ENDCASE

XInterAnimate, Set=[NS, NL, NB], /ShowLoad

;FOR i=0, NB-1 DO XInterAnimate, Frame=i, /ORDER, $
;   Image=scale(Data[*,*,i], min=-200, max=1000, xmin=0, xmax=255, /clip)

FOR i=0, NB-1 DO XInterAnimate, Frame=i, Image=bytscl(Data[i]), /ORDER
XInterAnimate, /Keep_Pixmaps

END
   
