FUNCTION ComputeMetrics_by1yr, NDVI, ndvi_raw, bq, bn, wl, bpy, CurrentBand, DaysPerBand;dt
;for modis ndvi 7-days data, DaysperBand=7
;jzhu, 9/21/2011, this program modified from computemetrics.pro,
;it inputs three-year ndvi time series abd rerlated band anme vectors,wl,bpy,currentband, and daysperband 
;ndvi is smoothed data, ndvi_raw is interpolated data

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
;
; Get crossover points (potential starts/ends)
;
Starts = GetCrossOver_percentage_extremeslope(Time, NDVI, Time, FMA, bq, bpy, /Down)
Ends   = GetCrossOver_percentage_extremeslope(Time, NDVI, Time, BMA, bq, bpy, /Up)
;
; Determine start/end of season
;

SOS=GetSOS(Starts, NDVI,bq,Time, bpy, FMA)     ;find the possible sos among the crossovers which is the most close to 20% up threshold point, guarentee possib sos > threshold,
                                                     ;and this possible sos must be good point. 
                                                                                         
EOS=GetEOS(Ends, NDVI, bq, Time,bpy,SOS,bma) ; find last 20% point, get the possibx which is the nearest to the last 20% point, compare the possibx and the last 20%point,
                                                   ; pick the smaller point in the possibx and 20% point as possib point, then gurrantee this point is good point.    
; Generate structures for Start/End of season

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

;version 5, uses ndvi, not ndvi_rqw to calculate maximum ndvi day
   MaxND=GetMaxNDVI(NDVI, Time, Start_End,bpy)             ;dayindex and related maximun ndvi value


   TotalNDVI=GetTotNDVI(NDVI, Time, Start_End,bpy,DaysperBand) ; ndvi*day (it is a ndvi curve minus baseline ), 
                                                               ; baseline( start to end) vector,
                                                               ; ndvi vector (start to end),
                                                               ; time vector (start to end).
                                                               ; GrowingSeasonT=GST, GrowingSeasonN=GSN, GrowingSeasonB=GSB)

;MJS 7/30/98 Need to write this
   NDVItoDate=GetNDVItoDate(NDVI, Time, Start_End, bpy, DaysPerBand, CurrentBand) ; ndvi*day, nowT (dayindex),nowN

   Slope=GetSlope(Start_End, MaxND, bpy, DaysPerBand) ;slope = ndvi/day   
   
   Range=GetRange(Start_End, MaxND, bpy, DaysPerBand) ;range.ranget = day, range.rangeN = ndvi


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
            SlopeDown:  Slope.SlopeDown, $
            TotalNDVI: TotalNDVI.TotalNDVI, $
            GrowingN:TotalNDVI.GSN, $
            GrowingT:TotalNDVI.GST, $
            GrowingB:TotalNDVI.GSB, $
            MaxT: MaxND.MaxT, $
            MaxN: MaxND.MaxN, $
            RangeT: Range.RangeT, $
            RangeN: Range.RangeN, $
            NDVItoDate: NDVItoDate.NDVItoDate, $
            NowT: NDVItoDate.NowT, $
            NowN: NDVItoDate.NowN $
           }


;   mMetrics = getall(ndvi, Time, start_end, ny, bpy)
;die
return, mMetrics
END
