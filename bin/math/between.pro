FUNCTION   Between, x, x1, x2

;jzhu, 9/1/2011, found x may has more than 6 valid digital,like 19.00000045,adjust x into 3 valid digital.

x = round(x*1.0E3)/1.0E3

SizeX = Size(X)


CASE(SizeX[0] GT 0) OF
   0: BEGIN
      CASE (X1 EQ X2) OF
         1:  print, "BETWEEN: WARNING:  X1 EQUALS X2"
         ELSE:
      ENDCASE

      CASE (x1 GE x2) OF
         0: btwn= x1 LE x AND x LE x2
         1: btwn= x1 GE x AND x GE x2
        ELSE:
      ENDCASE
   END

   1: BEGIN
      Btwn=Make_Array(Size=SizeX)
      Same = where(x1 eq x2, n) 

      CASE (n GT 0) OF
         1:  print, "BETWEEN: WARNING:  X1 EQUALS X2", n, " TIMES"
         ELSE:
      ENDCASE

      BtwnIdx=where( (X1 LE X AND X LE X2) OR (X1 GE X AND X GE X2), n)
      if(n ge 1) then $
      Btwn[BtwnIdx]=1 
   END
   ELSE:
ENDCASE


Return, Btwn
END

