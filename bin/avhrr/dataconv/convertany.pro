FUNCTION ConvertAny, Scaled, BAND = Band, DATATYPE = DataType, $
         REF=Ref, RAD=Rad



;
;  which data type is it
;
CASE (DataType) OF

   0: BEGIN
         CASE (Band) OF 
            0:  BEGIN
                  IF (REF) THEN Actual = b2ref(Scaled)
                  IF (RAD) THEN Actual = b2rad(Scaled)
                END
            1:  BEGIN 
                  IF (REF) THEN Actual = b2ref(Scaled)
                  IF (RAD) THEN Actual = b2rad(Scaled)
                END
            2:  Actual = b2k(Scaled)
            3:  Actual = b2k(Scaled)
            4:  Actual = b2k(Scaled)
            5:  Actual = b2nd(Scaled)
            6:  Actual = b2satz(Scaled)
            7:  Actual = b2solz(Scaled)
            8:  Actual = b2relaz(Scaled)
            ELSE: Actual = Scaled*1.0
         ENDCASE
      END
   1: BEGIN
         CASE (Band) OF 
            0:  BEGIN
                  IF (REF) THEN Actual = i2ref(Scaled)
                  IF (RAD) THEN Actual = i2rad(Scaled)
                END
            1:  BEGIN
                  IF (REF) THEN Actual = i2ref(Scaled)
                  IF (RAD) THEN Actual = i2rad(Scaled)
                END
            2:  Actual = i2k(Scaled)
            3:  Actual = i2k(Scaled)
            4:  Actual = i2k(Scaled)
            5:  Actual = i2nd(Scaled)
            6:  Actual = i2satz(Scaled)
            7:  Actual = i2solz(Scaled)
            8:  Actual = i2relaz(Scaled)
            ELSE: Actual = Scaled*1.0
         ENDCASE
      END

   2: BEGIN
         Actual = Scaled*1.
      END

   3: BEGIN
         Actual = Scaled*1.
      END
   ELSE: MESSAGE, "DATA TYPES: 0=BYTE, 1=I*2, 2=I*4, 3=R*4"
ENDCASE


RETURN, Actual
END
