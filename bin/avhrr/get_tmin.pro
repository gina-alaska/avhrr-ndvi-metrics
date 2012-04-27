FUNCTION  Get_Tmin, t, nd, clouds, ndmax, ndthresh

NDmid = avg([NDmax, NDthresh])

tidx = where(clouds eq 0 and nd ge ndmid)

Ncoefs = fitedge(nd(tidx), t(tidx), 0, 0.1, DataToFit, Yfit=Tminedge)
Tmin=tminedge(0)

return, Tmin

END


