PRO Bonferroni, Mu, MSE, n

nMu=N_Elements(Mu)

For i = 0, nMu-2 DO BEGIN

  For j =i+1, nMu-1 DO BEGIN

     qstar=abs(Mu[i]-Mu[j])/sqrt(2*MSE/n)

     print, 'Mu'+strcompress(i+1)+' - Mu'+strcompress(j+1)+' gives t*= ',strcompress(qstar)

  END
END

END

