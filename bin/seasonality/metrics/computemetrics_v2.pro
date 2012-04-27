FUNCTION ComputeMetrics_v2, NDVI,v2, wl, bpy, CurrentBand;dt
;jzhu, 2011/5/5, modiy this function, just decide start and end of green, do not calculate the metrics
; this program comes from computMetrics.pro, add a input parameter, v2, which is the un-smoothed vector
; calculation of on and end of green uses ndvi(smoothed vector), other metrics are calculated 
; by using v2 (un-smoothed vector)


   nSize=Size(NDVI)
   Time=Make_Array(Size=nSize)
   Time1=findgen(nSize[nSize[0]])

   CASE(nSize[0]) OF
      1: Time=Time1
      2: FOR i=0, nSize[1]-1 DO Time[i]=Time1
      3: BEGIN
         FOR i=0, nSize[1]-1 DO BEGIN
            FOR j=0, nSize[2]-1 DO BEGIN
               Time[i,j,*]=Time1
            END
         END
      END;3
      ELSE:
   ENDCASE

;
; Calculate Forward/Backward moving average
;
   fma=GetForwardMA(ndvi, wl[0])
   bma=GetBackwardMA(ndvi, wl[1])

;
; Get crossover points (potential starts/ends)
;
   Starts=GetCrossOver2(Time, NDVI, Time, FMA, /Down) ;down means ref line from down to cross the data line, ref line is raw data line, data line is moving averge data line
   Ends=GetCrossOver2(Time, NDVI, Time, BMA, /Up)    ; up means ref line from up to cross the data line
;
; Determine start/end of season
;
   SOS=GetSOS2(Starts, NDVI, Time, bpy, FMA)
   EOS=GetEOS2(Ends, NDVI, Time, bpy, SOS)


;
; Generate structures for Start/End of season
;
   Start_End = {SOST:SOS.SOST, $
                SOSN:SOS.SOSN, $
                EOST:EOS.EOST, $
                EOSN:EOS.EOSN, $
                FwdMA:FMA, $
                BkwdMA:BMA $
               }


;PRINT, 'COMPUTEMETRICS:NY:',ny
;   ny=n_elements(eos.eost)
   SOST = Start_End.SOST
   SOSN = Start_End.SOSN
   EOST = Start_End.EOST
   EOSN = Start_End.EOSN
   
;jzhu, 5/10/2011, if no start point or no end point, do not calcualte metrics
   
 if sost LE 0 or eost LT 0 then begin
  
  mMetrics={SOST: -1, SOSN:-1,EOST:-1,EOSN:-1}
  
 return, mMetrics
  
 endif



;jzhu, comment out following lines

   MaxND=GetMaxNDVI(v2, Time, Start_End,bpy)
   TotalNDVI=GetTotNDVI(v2, Time, Start_End,bpy);,
;      GrowingSeasonT=GST, GrowingSeasonN=GSN, GrowingSeasonB=GSB)

;MJS 7/30/98 Need to write this

;jzhu, 5/10/2011, do not calcylate NDVItoDate
;  NDVItoDate=GetNDVItoDate(NDVI, Time, Start_End, bpy, CurrentBand)


   Slope=GetSlope(Start_End, MaxND, bpy)
   Range=GetRange(Start_End, MaxND, bpy)


;IF(N_ELEMENTS(GST LE 0)) THEN GST=-1L
;IF(N_ELEMENTS(GSN LE 0)) THEN GSN=-1L
;IF(N_ELEMENTS(GSB LE 0)) THEN GSB=-1L

mMetrics = {SOST:SOST, $
            SOSN:SOSN, $
            EOST:EOST, $
            EOSN:EOSN, $
            FwdMA: Start_End.FwdMA, $
            BkwdMA: Start_End.BkwdMA, $
            SlopeUp: Slope.SlopeUp, $
            SlopeDown: Slope.SlopeDown, $
            TotalNDVI: TotalNDVI.TotalNDVI, $
            GrowingN:TotalNDVI.GSN, $
            GrowingT:TotalNDVI.GST, $
            GrowingB:TotalNDVI.GSB, $
            MaxT: MaxND.MaxT, $
            MaxN: MaxND.MaxN, $
            RangeT: Range.RangeT, $
            RangeN: Range.RangeN $
            }
 

;jzhu, 5/5/10, do not calucalte ndvitoDate
;            
;            NDVItoDate: NDVItoDate.NDVItoDate, $
;                        NowT: NDVItoDate.NowT, $
;            NowN: NDVItoDate.NowN $
;           }


;   mMetrics = getall(ndvi, Time, start_end, ny, bpy)
;die

return, mMetrics

END
