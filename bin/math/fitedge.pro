FUNCTION fitedge, XData, YData, Order, Percent, DataToFit, $
                  XBin=xbin, YFit=yfit

;
; This function fits an ORDERth order curve to the PERCENTth
; percentile point of YDATA for XBINS of XDATA.
;


CASE (KEYWORD_SET(XBIN)) OF
  0: XBin = 1.
  1: XBin = xbin
  else:
ENDCASE

Xmin = Floor(Min(XData))
XMax = Ceil(Max(XData))

nXBins = (XMax - XMin)/float(XBin)

TmpDataToFit = fltarr(2, nXBins)

Counter = 0

FOR iX = 0, nXBins - 1 DO BEGIN
  

  XLo = XMin + iX*XBin
  XHi = XMin + (iX + 1)*XBin

  XBinIdx = where(XData ge XLo  and  XData lt XHi, nXIdx)
  IF (nXIdx gt 0) THEN BEGIN

    YBin = YData(XBinIdx)
    TmpDataToFit(0,Counter) = Avg([XLo, XHi])
    TmpDataToFit(1,Counter) = Percentile(YBin, Percent)
    Counter = Counter + 1
  ENDIF

ENDFOR

DataToFit = fltarr(2, Counter)

DataToFit = TmpDataToFit(*, 0:Counter-1)

FitCoef = Poly_fit(DataToFit(0,*), DataToFit(1,*), Order, YFit)

Return, FitCoef
END
