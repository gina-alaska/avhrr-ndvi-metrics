FUNCTION Get_NDmin, t, nd, Tland

idx = where(nd gt 0  and  t gt Tland)
ncoefs = fitedge(t(idx), nd(idx), 0, 0.5, DataToFit, Yfit=NDmin)

return, NDmin(0)
END


