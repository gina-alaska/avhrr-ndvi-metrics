FUNCTION  BIL2BSQ, BIL

;
; This function converts from band interleaved (BIL) to band 
;  sequential (BSQ) formats
;

   bilSize=Size(BIL)
   nb=bilSize[1]
   ns=bilSize[2]
   nl=bilSize[3]
   dt=bilSize[4]

   BSQ=Make_Array(Dim=[ns,nl,nb], TYPE=dt)

   FOR i = 0, nb-1 DO BSQ[*,*,i]=BIL[i,*,*]

Return, BSQ
END
   


