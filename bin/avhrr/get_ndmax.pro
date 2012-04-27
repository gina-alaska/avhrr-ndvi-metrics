FUNCTION  Get_NDmax, t, nd, clouds



TofNDmax = avg(t(where(nd eq max(nd(where(nd ne 1))))))

ndidx = where(nd gt 0 and t ge TofNDmax-3 and t le TofNDmax+3 $
              and clouds eq 0 $
              and nd lt 1, nndidx)

if(nndidx gt 0) THEN $
   NDmax = percentile(nd(ndidx), 99.9) $
ELSE BEGIN
   NDmax = 1.0 
   print, "ERROR in GET_NDMAX"
ENDELSE  

return, NDmax

END

