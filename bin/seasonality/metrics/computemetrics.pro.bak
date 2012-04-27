FUNCTION ComputeMetrics, NDVI,  wl, bpy, CurrentBand;dt

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
   Starts=GetCrossOver2(Time, NDVI, Time, FMA, /Down)
   Ends=GetCrossOver2(Time, NDVI, Time, BMA, /Up)
;die
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

   MaxND=GetMaxNDVI(NDVI, Time, Start_End,bpy)
   TotalNDVI=GetTotNDVI(NDVI, Time, Start_End,bpy);,
;      GrowingSeasonT=GST, GrowingSeasonN=GSN, GrowingSeasonB=GSB)

;MJS 7/30/98 Need to write this
   NDVItoDate=GetNDVItoDate(NDVI, Time, Start_End, bpy, CurrentBand)

   Slope=GetSlope(Start_End, MaxND)
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
            SlopeUp: Slope.SlopeUp*100, $
            SlopeDown:  Slope.SlopeDown*100, $
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
