FUNCTION   PIP, aX, aY, aM, aB, Xp, Yp, Xref, Yref

;
;    Point in Polygon.  Used to determine of if the
;    point (Xp, Yp) lies inside the polygon described
;    by the points in (aX, aY) and their associated
;    slopes and intercepts (aM, aB).  The last member
;    of aX and aY should be the same as the first
;    (ie, a closed polygon)
;

N = N_Elements(aX)

CASE (Xp EQ Xref) OF
   0: Mp = (Yp - Yref)/(Xp-Xref)
   1: Mp = 1.0e6                 ; if slope is infinite, give big value
   ELSE:
ENDCASE

Bp = Yp - Mp*Xp

FOR i = 0, N-2 DO BEGIN

   CASE (aM[i] EQ Mp) OF
      0:   X0 = (Bp - aB[i])/(aM[i]-Mp)   
      1:   X0 = 1.0e6
      ELSE:
   ENDCASE

   count = count + Between(X0, aX[i], aX[i+1])*Between(X0, Xp, Xref)

ENDFOR

RETURN, count MOD 2
END 
