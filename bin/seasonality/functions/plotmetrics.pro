PRO PlotMetrics, mMetrics, WindowNum

wSet, WindowNum
OldMulti = !P.Multi

!P.Multi=[0,2,2]

Bar_Plot, mMetrics.TotalNDVI, Title="Total NDVI"

!P.Multi=OldMulti

END
