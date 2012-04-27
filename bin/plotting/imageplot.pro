PRO ImagePlot, data, x, y, XMIN=xmin, XMAX=xmax, YMIN=ymin, YMAX=ymax

;
;  This procedure placed the 2D image, DATA, in the plot box defined
;  by X and Y or (X/Y)(MIN/MAX)
;

CASE (KEYWORD_SET(XMIN)) OF 
  1:  xmin = xmin
  0:  BEGIN
        CASE (N_PARAMS() gt 1) OF
          1: xmin = min(x)
          0: MESSAGE, "Must give X or XMIN"
          else:
        ENDCASE
      END
  ELSE:
ENDCASE

CASE (KEYWORD_SET(XMAX)) OF 
  1:  xmax = xmax
  0:  BEGIN
        CASE (N_PARAMS() gt 1) OF
          1: xmax = max(x)
          0: MESSAGE, "Must give X or XMAX"
          else:
        ENDCASE
      END
  ELSE:
ENDCASE

CASE (KEYWORD_SET(YMIN)) OF 
  1:  ymin = ymin
  0:  BEGIN
        CASE (N_PARAMS() gt 1) OF
          1: ymin = min(y)
          0: MESSAGE, "Must give Y or YMIN"
          else:
        ENDCASE
      END
  ELSE:
ENDCASE

CASE (KEYWORD_SET(YMAX)) OF 
  1:  ymax = ymax
  0:  BEGIN
        CASE (N_PARAMS() gt 1) OF
          1: ymax = max(y)
          0: MESSAGE, "Must give Y or YMAX"
          else:
        ENDCASE
      END
  ELSE:
ENDCASE

tmp = fltarr(2)
PLOT, tmp, tmp, /nodata, XRange = [XMin, XMax], YRange=[Ymin, YMax], $
      TickLen = (0 - !P.TickLen), /XStyle, /YStyle

xyDevice = Convert_Coord(!X.CRange, !Y.CRange, /Data, /To_Device)

newData = Congrid(data, $
                 (xyDevice(0, 1) - xyDevice(0,0) + 1), $
                 (xyDevice(1, 1) - xyDevice(1,0) + 1));,  /Interp)

oldOrder = !Order
!Order = 0
TvScl, newData, !X.CRange(0), !Y.CRange(0), /Data
!Order = oldOrder

END
 
