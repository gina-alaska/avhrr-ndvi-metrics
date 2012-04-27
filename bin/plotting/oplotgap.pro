PRO OPlotGap, X, Y, XGap, COLOR=Color

;
; This function oplots x and y skipping gaps between x's greater than
;  or equal to XGap
;
nX=n_elements(x)

if(nX GT 1) then BEGIN
xshift=shift(x, -1)
diff=xshift-x
idx=where(diff gt XGap, nidx)


IF NIDX GT 0 THEN BEGIN
   IF (Idx[0] NE 0) THEN idx=[0,idx]
   NIdx=N_Elements(idx)

   IF (Idx[NIdx-1] NE N_Elements(X)-1) THEN $
      Idx=[Idx, N_Elements(X)-1]
   NIdx=N_Elements(idx)

   For i = 0, NIdx-2 DO BEGIN
      Oplot, X[Idx[i]+1:idx[i+1]], Y[Idx[i]+1:Idx[i+1]], Color=Color 
   END
END
END

END
