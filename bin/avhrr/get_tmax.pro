FUNCTION  Get_Tmax, t, nd, clouds, tmin, ndmin, WarmCurve 

TofNDmax = min(t(where(nd eq max(nd(where(nd ne 1))))))

TmaxIdx = where(nd gt 0 and clouds eq 0 and t gt TofNDmax)

TMaxDataToFit = WarmEdge(t(TmaxIdx), nd(TmaxIdx),99.5)

n = n_elements(TMaxDataToFit(0,*))
w = fltarr(n)+1.0
Tcoefs = PolyFitW(TMaxDataToFit(0,*), TMaxDataToFit(1,*), W,2, TmaxFit)

WarmCurve = fltarr(2,n_elements(TmaxFit))
WarmCurve(0,*) = TMaxDataToFit(0,*)
WarmCurve(1,*) = TmaxFit

tmpcoefs = tcoefs
tmpcoefs(0) = tcoefs(0)-ndmin
Tmax = quadratic(tmpcoefs, /negroot)

return, Tmax

END
