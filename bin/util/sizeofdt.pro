FUNCTION SizeOfDT, dt
;
; This function returns the size of a given data type in bytes
;
;    1: Byte => 1
;    2: Int => 2
;    3: Long => 4
;    4: Float => 4
;    5: Double => 8
;    6: Complex Float => 8
;    7: String => 1?
;    8: Structure => 1?
;    9: Complex Double => 16
;   10: Pointer => ?
;   11: Object Reference => ?
;

CASE DT OF

   1: s = 1
   2: s = 2
   3: s = 4
   4: s = 4
   5: s = 8
   6: s = 8
   7: s = 1
   8: s = 1
   9: s = 16
   else: BEGIN
      print, "SIZEOFDT: INVALID DATA TYPE"
      s = -1
   END

ENDCASE

Return, s
END
