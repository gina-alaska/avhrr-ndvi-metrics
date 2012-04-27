FUNCTION GetCrossOver, Xref, Yref, XData, YData,  UP=up, DOWN=down, ALL=ALL

   nData = n_Elements(XRef)

   XPts=fltarr(nData-1)
   YPts=fltarr(nData-1)
   CPts=fltarr(nData-1)

if(not keyword_set(up)) then up=0
if(not keyword_set(down)) then down=0
if(not keyword_set(ALL)) then ALL=0

IF (ALL EQ 1) THEN BEGIN
   UP=1 
   DOWN=1
END

   iCount=0

   FOR i = 0L, nData-2 DO BEGIN


      RSlope = float(YRef[i+1]-YRef[i])/(XRef[i+1]-XRef[i])
      DSlope = float(YData[i+1]-YData[i])/(XData[i+1]-XData[i])

      RInt = YRef[i]-RSlope*XRef[i]
      DInt = YData[i]-DSlope*XData[i]

      XStar = (RInt-DInt)/(DSlope-RSlope)
      
      BetweenD=Between(XStar, XData[i], XData[i+1])
      BetweenR=Between(XStar, XRef[i], XRef[i+1])

      If(BetweenD AND BetweenR) Then PtSC=1 ELSE PtSC=0

      IF (PtSC gt 0 AND ((DSlope lt RSlope and DOWN) OR (DSlope gt RSlope and UP))) THEN BEGIN
         XPts[iCount]=XStar
         YPts[iCount]=DSlope*XStar + DInt
         CPts[iCount]=PtSC
      iCount = iCount+1

      END
  
   END

   NPts=N_Elements(where(YPts NE 0))

   CASE (NPts GT 0) OF
      0:Cross={X:0., Y:0., C:0., N:Npts}
      1:Cross={X:Xpts[0:NPts-1], Y:YPts[0:NPts-1], C:CPts[0:NPts-1], N:NPts}
      ELSE:
   ENDCASE


RETURN, Cross
END
