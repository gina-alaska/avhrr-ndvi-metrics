FUNCTION MakeCube, data, mInfo, mSmoothParam

mSmoothParam.pp=0.3
mSmoothParam.ps=1L
mSmoothParam.swin=26
mSmoothParam.rwin=5
mSmoothParam.cwin=5
mSmoothParam.pwght=1.5
mSmoothParam.swght=0.5
mSmoothParam.vwght=0.05

mLocal = {file:mInfo.file, ns:minfo.ns, nl:minfo.nl, nb:minfo.nb, dt:minfo.dt, $
          mSmoothParam:mSmoothParam}

Smoothed = data*0

for i = 0, minfo.nl-1 DO BEGIN

   for j = 0, minfo.ns-1 DO BEGIN

      imgwrite, data(j,i,*)+50b, "/tmp/Smoother/pixel"

      ismth_data=Call_Smoother(mLocal,j,i)
      Smoothed(j,i,*) =ismth_data-50b 
   END
print, "Completed line:", i
END

return, Smoothed
END
