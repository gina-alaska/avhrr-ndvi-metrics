FUNCTION fmftest, t4, t5, jd, fmr, fmft

ImgSize = Size(t4)

Dim = ImgSize(1)

fmf = t4*0.0d0

coef = [-1.34436d4 , 1.94945d2, -1.05635d0, 2.53361d-3, -2.26786d-6]
dat = [-15,15, 46, 74,  105,135,166,196,227,  258,288,319,349,380]

FOR i = 0, dim-1 DO BEGIN
   FOR j = 0, dim-1 DO BEGIN

      t = t4(j,i)

      CASE 1 OF

         (t le 260.): fmf(j,i) = 0.0d0
         (t ge 305.): fmf(j,i) = 7.8d0
         ELSE: fmf(j,i) = poly(t, coef)

      ENDCASE

   ENDFOR
ENDFOR

tt4 = interpol(fmr,dat,jd)
fmft = (t4-t5) ge (fmf+tt4(0))

RESULT = (t4-t5) - (fmf+tt4(0))

RETURN, RESULT
END

