FUNCTION GetCrossOver2, Xref, Yref, XData, YData, bpy, UP=up, DOWN=down, ALL=ALL
   
   
   mxidx = where( Yref EQ max(Yref) ) 
   mxidxst=mxidx(0)
   mxidxed=mxidx(n_elements(mxidx)-1)
   
   nSize = Size(XRef)
   nDim=nSize[0]
   oSize=nSize
   oSize[nDim]=nSize[nDim]/2
   XPts=Make_Array(Size=oSize)
   YPts=Make_Array(Size=oSize)
   CPts=Make_Array(Size=oSize)

   if(not keyword_set(up)) then up=0
   if(not keyword_set(down)) then down=0
   if(not keyword_set(ALL)) then ALL=0

   IF (ALL EQ 1) THEN BEGIN
      UP=1 
      DOWN=1
   END

   iCount=0
   
   CASE nDim OF

      1: BEGIN

         FOR i = 0L, nSize[nDim]-2 DO BEGIN


            RSlope = float(YRef[i+1]-YRef[i])/(XRef[i+1]-XRef[i])
            DSlope = float(YData[i+1]-YData[i])/(XData[i+1]-XData[i])
            SlopeDiff=DSlope-RSlope
            IF (SlopeDiff EQ 0) THEN SlopeDiff=1.e-6

            RInt = YRef[i]-RSlope*XRef[i]
            DInt = YData[i]-DSlope*XData[i]


            XStar = (RInt-DInt)/SlopeDiff
      
            BetweenD=Between(XStar, XData[i], XData[i+1])
            BetweenR=Between(XStar, XRef[i], XRef[i+1])
      ;jzhu, 9/14/2011, modify the condition,
      ;if down and xstart must be less than idx of maximun ndvi or half pf bpy, 
      ;if up and xstar must be greater then idx of maximun ndvi or half of bpy
      
      ;      If(BetweenD AND BetweenR) Then PtSC=1 ELSE PtSC=0
      
      
       
      if ( (BetweenD AND BetweenR) and (Xstar LT min([mxidxst,0.5*bpy])) and DOWN ) or $
         ( (BetweenD AND BetweenR) and (Xstar GT max([mxidxed,0.5*bpy])) and UP   ) then PtSC=1 ELSE PtSC=0 
             
             
             
      
      
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
            ;1:Cross={X:Xpts[0:NPts-1], Y:YPts[0:NPts-1], C:-1, N:NPts}
            1:Cross={X:Xpts[0:NPts-1], Y:YPts[0:NPts-1], C:CPts[0:NPts-1], N:NPts}
            ELSE:
         ENDCASE

      END;1
      2: BEGIN
      END;2

      3: BEGIN
         ;Index = lindgen(nSize[1]*nSize[2])
         CurIdx= intarr(nSize[1], nSize[2])
         ;RealIdx = CurIdx*nSize[1]*nSize[2] + Index

         FOR i = 0L, nSize[3]-2 DO BEGIN
            RSlope = float(YRef[*,*,i+1]-YRef[*,*,i])/(XRef[*,*,i+1]-XRef[*,*,i])
            DSlope = float(YData[*,*,i+1]-YData[*,*,i])/(XData[*,*,i+1]-XData[*,*,i])
            SlopeDiff=DSlope-RSlope
            z=where(SlopeDiff EQ 0, nz)
            IF(nz gt 0) THEN SlopeDiff[z]=1.0e-6
            RInt = YRef[*,*,i]-RSlope*XRef[*,*,i]
            DInt = YData[*,*,i]-DSlope*XData[*,*,i]

            XStar = (RInt-DInt)/SlopeDiff

            BetweenD=Between(XStar, XData[*,*,i], XData[*,*,i+1])
            BetweenR=Between(XStar, XRef[*,*,i], XRef[*,*,i+1])
      
;            If(BetweenD AND BetweenR) Then PtSC=1 ELSE PtSC=0
      
            CIdx = where(BetweenD and BetweenR, nci) ; on [0:ns*nl]


CrossIdx=where(BetweenD and BetweenR  AND $
               ((DSlope lt RSlope and DOWN) OR $
                (DSlope gt RSlope and UP)), ncri) 

               
                              
if (ncri gt 0) then begin

            RealIdx=CurIdx[CrossIdx]*nSize[1]*nSize[2] + CrossIdx

               XPts[RealIdx]=XStar[CrossIdx]
               YPts[RealIdx]=DSlope[CrossIdx]*XStar[CrossIdx] + DInt[CrossIdx]
               CPts[RealIdx]=1
               
               CurIdx[CrossIdx]=CurIdx[CrossIdx]+1
 
            END
         END; FOR

MaxZ=Max(CurIdx)
Xpts=Temporary(Xpts[*,*,0:MaxZ-1])
Ypts=Temporary(Ypts[*,*,0:MaxZ-1])
Cpts=Temporary(Cpts[*,*,0:MaxZ-1])

Zero=where(Xpts[*,*,1:MaxZ-1] EQ 0)
Xpts[nSize[1]*nSize[2]+Zero] = -1
Ypts[nSize[1]*nSize[2]+Zero] = -1
Cpts[nSize[1]*nSize[2]+Zero] = -1

;print, MaxZ
;showimg, rebin(curidx, 256, 256), Down


            Cross={X:Xpts, Y:Ypts, C:Cpts, N:MaxZ}

      END;3

      ELSE:
   ENDCASE 



undefine, xpts
undefine, ypts

RETURN, Cross
END
