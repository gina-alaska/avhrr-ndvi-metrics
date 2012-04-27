PRO  plotfft, u

n = n_elements(u)
t = 1.

f = findgen(n/2+1)/(n*t)

v = fft(u)

mag = abs(v(0:n/2))
phi = atan(v(0:n/2))

!p.multi=[0,1,2]

plot, f, alog10(mag), YTitle="Log(Magniude)", XTitle="Frequency", $
         /xlog, /xstyle, xrange=[1.,1./(2.*t)]

plot, f, phi/!dtor, YTitle="Phase, Deg", YRange=[-180, 180], /ystyle, $
         XTitle="Frequency", /xlog, xrange=[1., 1./(2.*t)]

!p.multi=0
end
