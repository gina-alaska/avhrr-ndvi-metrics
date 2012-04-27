
apr = fltarr(5,20)
may = fltarr(5,20)
jun = fltarr(5,20)
jul = fltarr(5,20)
aug = fltarr(5,20)

path="~suarezm/idl/bin/avhrr/clavrdir/"

openr,1, path+"apr.dat"
readf,1, apr
close,1
openr,1, path+"may.dat"
readf,1, may
close,1
openr,1, path+"jun.dat"
readf,1, jun
close,1
openr,1, path+"jul.dat"
readf,1, jul
close,1
openr,1, path+"aug.dat"
readf,1, aug
close,1

label=["RGCT", "RRCT", "C3AT", "FMFT", "TGCT"]
xmin = [0, 0, 0, -8, 200]
xmax = [1, .5, .15, 4, 340]



window,0
plot, apr(0,*)
oplot, may(1,*), line=1
oplot, jun(1,*), line=2
oplot, jul(1,*), line=3
oplot, aug(1,*), line=4

window,1
plot, apr(1,(sort(apr(1,*)))), yrange=[0,.5]
oplot, may(1,sort(may(1,*))), line=1, color=rgb(255,0,0)
oplot, jun(1,sort(jun(1,*))), line=2, color=rgb(0,255,0)
oplot, jul(1,sort(jul(1,*))), line=3, color=rgb(255,255,0)
oplot, aug(1,sort(aug(1,*))), line=4, color=rgb(0,0,255)

window,2
plot,  apr(2,sort(apr(2,*))), yrange=[0,.15]
oplot, may(2,sort(may(2,*))), line=1
oplot, jun(2,sort(jun(2,*))), line=2
oplot, jul(2,sort(jul(2,*))), line=3
oplot, aug(2,sort(aug(2,*))), line=4

window,3
plot,  apr(3,sort(apr(3,*)))
oplot, may(3,sort(may(3,*))), line=1
oplot, jun(3,sort(jun(3,*))), line=2
oplot, jul(3,sort(jul(3,*))), line=3
oplot, aug(3,sort(aug(3,*))), line=4

window,4
plot,  apr(4,sort(apr(4,*))), /ynozero
oplot, may(4,sort(may(4,*))), line=1
oplot, jun(4,sort(jun(4,*))), line=2
oplot, jul(4,sort(jul(4,*))), line=3
oplot, aug(4,sort(aug(4,*))), line=4


end
