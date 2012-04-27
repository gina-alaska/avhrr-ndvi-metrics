PRO Scheffe, Mu, MSE, n, r

nMu=N_Elements(Mu)

For i = 0, nMu-2 DO BEGIN

  For j =i+1, nMu-1 DO BEGIN

     qstar=abs(Mu[i]-Mu[j])^2/(2*MSE*(r-1)/n)

     print, 'Mu'+strcompress(i+1)+' - Mu'+strcompress(j+1)+' gives F*= ',strcompress(qstar)

  END
END

END

