FUNCTION GetCrossOver3, Xref, Yref, XData, YData,  UP=up, DOWN=down, ALL=ALL
;
; Find crossover points between NDVI (ref) and movingaverage (data)
;
; DOWN=moving average crossing going down (SOS)
; UP  =moving average crossing going up (EOS)
;


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

             Intersect, XRef[i], YRef[i], XRef[i+1], YRef[i+1], $
                        XData[i], YData[i], XData[i+1], YData[i+1], $
                        XIntPts, YIntPts, IntPtsC

             IF( IntPtsC EQ 1 and $
               ( (YRef[i]   GE YData[i])   AND  UP    AND $       ; EOS
                 (YRef[i+1] LE YData[i+1]) AND  UP  )  OR $
               ( (YRef[i]   LE YData[i])   AND DOWN   AND $       ; SOS
                 (YRef[i+1] GE YData[i+1]) AND DOWN)) THEN BEGIN
     
                 Xpts[iCount] = XIntPts
                 Ypts[iCount] = YIntPts
                 Cpts[iCount] = IntPtsC
                 iCount=iCount+1
             END

         END

         NPts=N_Elements(where(CPts NE 0))

         CASE (NPts GT 0) OF
            0:Cross={X:0., Y:0., C:0., N:Npts}
            1:Cross={X:Xpts[0:NPts-1], Y:YPts[0:NPts-1], $
                     C:CPts[0:NPts-1], N:NPts}
            ELSE:
         ENDCASE

      END;1
      2: BEGIN
      END;2

      3: BEGIN

         CurIdx= intarr(nSize[1], nSize[2])

         FOR i = 0L, nSize[3]-2 DO BEGIN

;print, "****GETCROSSOVER3****",i

             M_Intersect, XRef[*,*,i], YRef[*,*,i], $
                        XRef[*,*,i+1], YRef[*,*,i+1], $
                        XData[*,*,i], YData[*,*,i], $
                        XData[*,*,i+1], YData[*,*,i+1], $
                        XIntPts, YIntPts, IntPtsC

             CrossIdx=where( IntPtsC GE 1 and $
;             CrossIdx=where( 1 and $
               ( (YRef[*,*,i]   GE YData[*,*,i]  ) AND  UP    AND $   ; EOS
                 (YRef[*,*,i+1] LT YData[*,*,i+1]) AND  UP  )  OR $   
               ( (YRef[*,*,i]   LE YData[*,*,i]  ) AND DOWN   AND $   ; SOS
                 (YRef[*,*,i+1] GT YData[*,*,i+1]) AND DOWN ) ,ncri)
    
                              
;rx1=XRef[*,*,i] & ry1=YRef[*,*,i]
;rx2=XRef[*,*,i+1] & ry2=YRef[*,*,i+1]
;r=slopeint(rx1,ry1,rx2,ry2)

;dx1=XData[*,*,i] & ry1=YData[*,*,i]
;dx2=XData[*,*,i+1] & ry2=YData[*,*,i+1]
;d=slopeint(dx1,dy1,dx2,dy2)

;             CrossIdx=where( 1 and $
;               ( (ry1 GE dy1) AND  UP    AND $   ; EOS
;                 (ry2 LT dy2) AND  UP  )  OR $   
;               ( (ry1 LE dy1) AND DOWN   AND $   ; SOS
;                 (ry2 GT dy2) AND DOWN ) ,ncri)

            if (ncri gt 0) then begin
               
;               XStar=-(s1.b[crossidx]-s2.b[crossidx])/(s1.m[crossidx]-s2.m[crossidx])
;               YStar=s1.m[crossidx]*XStar + s1.b[crossidx]

               RealIdx=CurIdx[CrossIdx]*nSize[1]*nSize[2] + CrossIdx

;               XPts[RealIdx]=XStar
;               YPts[RealIdx]=YStar
;               XPts[RealIdx]=XStar[CrossIdx]
;               YPts[RealIdx]=DSlope[CrossIdx]*XStar[CrossIdx] + DInt[CrossIdx]
               XPts[RealIdx]=XIntPts[CrossIdx]
               YPts[RealIdx]=YIntPts[CrossIdx]
               CPts[RealIdx]=1
               
               CurIdx[CrossIdx]=CurIdx[CrossIdx]+1
 
            END
;if i EQ 4 then  die
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
