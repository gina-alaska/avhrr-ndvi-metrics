FUNCTION dms2deg,dms, mm, ss

CASE N_PARAMS() OF

   1: BEGIN
        d=dms[0]
        m=dms[1]
        s=dms[2]
      END
   2: BEGIN
        d=dms
        m=mm
        s=0
      END
   3: BEGIN
        d=dms
        m=mm
        s=ss
      END
   ELSE:
ENDCASE

RETURN, d/abs(d)*(abs(d) + m/60. + s/3600.)
END
