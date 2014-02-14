FUNCTION  GetNDVIToDate, NDVI, Time, Start_End, bpy, DaysPerBand, CurrentBand;, $
;           GROWINGSEASONN=GrowingSeasonN, GROWINGSEASONT=GrowingSeasonT, $ 
;           GROWINGSEASONB=GrowingSeasonB
;           
;           jzhu,8/9/2011,This program calculates total ndvi integration (ndvi*day) from start of season to currentband, 
;           the currentband is the dayindex of interesting day.  
   FILL=-1.0
   nSize=Size(NDVI)
   sSize=Size(Start_End.SOST)
   IF (nSize[0] EQ sSize[0]) THEN $
   ny=sSize[sSize[0]] $
   ELSE ny=1
   
   ;DaysPerBand=365./bpy

   

   CASE (nSize[0]) OF


   1: BEGIN
      NowT=findgen(ny)*bpy + CurrentBand
;            + (Start_End.SOST[0] GT CurrentBand)*bpy

      NowN=NDVI[NowT] 
      SeasonLength=float(floor(NowT)-ceil(Start_End.SOST)) 
      a=where(SeasonLength EQ 0, na)

   IF (na gt 0) THEN SeasonLength[a] = -1.0e-6
      icount=0
      NDVItoDate=fltarr(ny)+FILL

      b=where(start_end.sost lt 0, nb)
      if(nb gt 0) then SeasonLength[b] = FILL


      FOR i = 0, ny-1 DO BEGIN
         IF (SeasonLength[i] GT 0 AND SeasonLength[i] LT bpy) THEN BEGIN

            XSeg=[Time[ceil(Start_End.SOST[i]):floor(NowT[i])]]

            NDVILine=[ NDVI[ceil(Start_End.SOST[i]):floor(NowT[i])]]

            If(XSeg[0] NE Start_End.SOST[i]) THEN BEGIN
               XSeg=[Start_End.SOST[i], [XSeg]]
               NDVILine=[Start_End.SOSN[i], [NDVILine]]
            END

            If(XSeg[N_Elements(XSeg)-1] NE NowT[i]) THEN BEGIN
               XSeg=[[XSeg], NowT[i]]
               NDVILine=[[NDVILine], NowN[i]]
            END


            BaseLine=XSeg*0+Start_End.SOSN[i]

            XSeg=XSeg(Uniq(XSeg))
            NDVILine=NDVILine(sort(XSeg))
            BaseLine=BaseLine(sort(XSeg))
   
         
            IntNDVI=Int_Tabulated(XSeg, NDVILine,/sort)
            IntBase=Int_Tabulated(XSeg, BaseLine,/sort)
            NDVItoDate[i]=(IntNDVI-IntBase)*DaysPerBand


            if (icount EQ 0) THEN BEGIN
               GSN=NDVILine
               GST=XSeg
               GSB=BaseLine
            END ELSE BEGIN
               GSN=[GSN, NDVILine]
               GST=[GST, XSeg]
               GSB=[GSB, BaseLine]
            END
            icount=icount+1
         
         END ELSE NDVItoDate[i]=FILL
      END; FOR i
      NDVItoDate={NDVItoDate:NDVItoDate $
         , NowT:NowT, NowN:NowN}
;die
   END; CASE 1 

   2: BEGIN
   END; CASE 2 

   3: BEGIN
      NDVItoDate=Make_Array(Size=Size(Start_End.SOST))+FILL
      NowT=Make_Array(Size=Size(Start_End.SOST))
      NowN=Make_Array(Size=Size(Start_End.SOST))
   ;   NowT=longen(sSize[1], sSize[2],ny)/(sSize[1]*sSize[2])*bpy + CurrentBand
   ;   NowN=NDVI[NowT] 



      FOR i = 0, ny-1 DO BEGIN
         NowT[*,*,i]=i*bpy +CurrentBand
         NowN[*,*,i]=IndexMap(NDVI, NowT[*,*,i])
   SeasonLength=float(floor(NowT)-ceil(Start_End.SOST)) 
   a=where(SeasonLength EQ 0, na)
   IF (na gt 0) THEN SeasonLength[a] = -1.0e-6
         xlastidx=0
         nlastidx=0
         XSeg=FromTo(Time,  ceil(Start_End.SOST[*,*,i]), $
                           floor(NowT[*,*,i]), LastIdx=XLastIdx)

         NDVILine=FromTo(NDVI, ceil(Start_End.SOST[*,*,i]), $
                              floor(NowT[*,*,i]), LastIdx=NLastIdx) 

         BaseLine=XSeg*0+Start_End.SOSN[*,*,i]

         IntNDVI=Trap3D(NDVILine, fill=-1, LastMap=NLastIdx, $
                        StartX=Start_End.SOST[*,*,i], StartY=Start_End.SOSN[*,*,i], $
                        EndX=NowT[*,*,i], EndY=NowN[*,*,i] ) >0

         IntBase=((Start_End.SOSN[*,*,i])*$
                  (NowT[*,*,i]-Start_End.SOST[*,*,i])) >0

         NDVItoDate[*,*,i]=IntNDVI-IntBase

         tmpndvi=NDVItoDate[*,*,i]

         idx=where(SeasonLength[*,*,i] LE  0 OR $
                   SeasonLength[*,*,i] GT bpy OR NDVItoDate[*,*,i] lt 0, nidx)
         if (nidx gt 0) then tmpndvi[ idx ]=FILL

         NDVItoDate[*,*,i]=(tmpndvi)*DaysPerBand

      END; FOR i

      NDVItoDate={NDVItoDate:NDVItoDate, NowT:NowT, NowN:NowN $
           , GSB:-1L, GSN:-1L, GST:-1L}
   END; CASE 3 
   ELSE:
   ENDCASE




RETURN, NDVIToDate
END;GetNDVIToDate
