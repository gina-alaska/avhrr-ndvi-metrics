
fe = 1.
;mtf = [0.,.48, .82, .93, 1., .93, .82, .48, 0.]
;freq=[-fe, -fe/2, -fe/4, -fe/8, 0., fe/8, fe/4, fe/2, fe]
mtf = [.48, .82, .93, 1., .93, .82, .48]
freq=[-fe/2, -fe/4, -fe/8, 0., fe/8, fe/4, fe/2]

n=1024
n2=n/2
sigma=100


;
; Frequency Calculations
;
gfit=gaussfit(freq,mtf,A, nterms=3, estimates=[1., 0., 0.5])
;A[0]=1.0
;A[1]=0.0
;A[2]= 0.39894228

x = findgen(n)/(n2)-1
z = (x-A[1])/A[2]
y = A[0]*exp(-z^2/2)

z2 = (x-A[1])/A[2]*sigma
y2 = A[0]*exp(-z2^2/2)

xspread=x*32
z3 = (xspread[n/4:n-n/4-1]-A[1])/A[2];*sigma
y3 = A[0]*exp(-z3^2/2)


;
; Frequency Domain Plot
;
!P.Multi=[0,1,2]
window,0, XSize=600, YSize=1000
plot, x,y, /xstyle, Title="Frequency Domain"
oplot, freq, mtf, psym=4, color=rgb(255,0,0)
oplot, freq, gfit, psym=4, color=rgb(0,255,0)
oplot, x,y2, color=rgb(0,0,255)
oplot, x[n/4:n-n/4-1], y3, color=rgb(255,0,0)

;
; Spatial Calculations
;
ynew = [y[n/2-1:n-n/4-1], y[n/4:n/2-2]]
psf = float(fft(ynew, 1))/(n/2)

ynew2 = [y2[n/2-1:n-1], y2[0:n/2-2]]
psf2 = float(fft(ynew2, 1))*sigma*A[0]/(n/2)

ynew3= [y3[n2/2:n2-n2/4-1], y2[n2/4:n/2-1]]
psf3 = float(fft(ynew3, 1))*A[0]/(n2*2)*sigma


;
; Spatial Domain Plot
;
plot, findgen(n2)+n2/2, [psf[n2/2-1:n2-1], psf[0:n2/2-2]],  /xstyle, Title="Spatial Domain", xrange=[0, 1024], yrange=[-.2,1]
;plot, [psf[n/2-1:n-1], psf[0:n/2-2]],  /xstyle, Title="Spatial Domain"
oplot, [psf2[n/2-1:n-1], psf2[0:n/2-2]], color=rgb(0,0,255)
oplot, findgen(n2)+n2/2,[psf3[n2/2-1:n2-1], psf3[0:n2/2-2]], $
       color=rgb(255,0,0)

!p.multi=[0,1,1]

END
