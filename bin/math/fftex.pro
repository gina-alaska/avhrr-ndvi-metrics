;PRO fftex, af,peakfreqs
n=n_elements(af)
t=1.0

n21 = n/2 +1

f=findgen(n)
if n mod 2 eq 0 then dec = 2
if n mod 2 ne 0 then dec = 1

f(n21) = n21 - n + findgen(n21-dec) ; the -1 might need to be -2
f = f/(n*t)

psd=abs(fft(af))
phi=atan(fft(af))

!p.multi=[0,1,2]
;plot,  f, abs(fft(y)), /ylog
plot,  shift(f, -n21), shift(psd,-n21);, /ylog, /xstyle
plot,  shift(f, -n21), shift(phi/!dtor,-n21);, /ylog, /xstyle
!p.multi=0

;SORT OUT FREQUENCIES BASED ON MAGNITUDE OF PEAKS
peakfreqs = abs(f(uniq(abs(f), reverse(sort(psd)))))
end
