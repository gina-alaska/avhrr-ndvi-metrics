FUNCTION  GetTotNDVI, NDVI, Time, Start_End, bpy;, $

   FILL=-1.0
   nSize=Size(NDVI)
   sSize=Size(Start_End.SOST)
   IF(nSize[0] EQ sSize[0]) THEN $
   ny=sSize[sSize[0]] $
   ELSE ny = 1
   DaysPerBand=365./bpy

;jzhu, 5/9/2011, for emodis data, DayPerBand=7.0
   DayPerBand=7.0
   
   SeasonLength=float(floor(Start_End.EOST)-ceil(Start_End.SOST)) 
   a=where(SeasonLength EQ 0, na)
   IF (na gt 0) THEN SeasonLength[a] = -1.0e-6
   BaseSlope=(Start_End.EOSN-Start_End.SOSN)/SeasonLength
   BaseInt=Start_End.SOSN-Start_End.SOST*BaseSlope

;
; CASE OF NUMBER OF DIMENSIONS
;
   CASE (nSize[0]) OF

;
; 1-D Data, ie a point as in
;
   1: BEGIN
      x=findgen(n_elements(NDVI))
      icount=0

      TotalNDVI=fltarr(ny)+FILL
      FOR i = 0, ny-1 DO BEGIN
         IF (SeasonLength[i] GT 0 AND SeasonLength[i] LT bpy) THEN BEGIN

            XSeg=[Time[ceil(Start_End.SOST[i]):floor(Start_End.EOST[i])]]

            NDVILine=[ NDVI[ceil(Start_End.SOST[i]):floor(Start_End.EOST[i])]]

            If(XSeg[0] NE Start_End.SOST[i]) THEN BEGIN
               XSeg=[Start_End.SOST[i], [XSeg]]
               NDVILine=[Start_End.SOSN[i], [NDVILine]]
            END

            If(XSeg[N_Elements(XSeg)-1] NE Start_End.EOST[i]) THEN BEGIN
               XSeg=[[XSeg], Start_End.EOST[i]]
               NDVILine=[[NDVILine], Start_End.EOSN[i]]
            END


            BaseLine=XSeg*BaseSlope[i]+BaseInt[i]

            XSeg=XSeg(Uniq(XSeg))
            NDVILine=NDVILine(sort(XSeg))
            BaseLine=BaseLine(sort(XSeg))
   
         
            IntNDVI=Int_Tabulated(XSeg, NDVILine,/sort)
            IntBase=Int_Tabulated(XSeg, BaseLine,/sort)

            TotalNDVI[i]=(IntNDVI-IntBase)*DaysPerBand
;print, i
;print, IntNDVI,IntBase,TotalNDVI[i]
;---------jzhu, 5/10/2011, comment out alternative intndvi and intbase method

;nn=n_elements(NDVILine)-1

;dxi=(XSeg[1]-XSeg[0])
;dxf=(XSeg[nn]-XSeg[nn-1])
;IntNDVI=avg(NDVILine[0:1])*dxi + avg(NDVILine[nn-1:nn])*dxf + $
;        avg([NDVILine[1],NDVILine[nn-1]]) + total(NDVILine[2:nn-2])

;            IntNDVI=Total(NDVILine)-0.5*(NDVILine[0]+NDVILine[nn])
;            IntBase=Total(BaseLine)-0.5*(BaseLine[0]+BaseLine[nn])


;         IntBase=((Start_End.SOSN[i]+Start_End.EOSN[i])$
;                 *(Start_End.EOST[i]-Start_End.SOST[i])/2.) 

;            TotalNDVI[i]=(IntNDVI-IntBase)*DaysPerBand

;---------jzhu, 5/10, end of the comemnt out the alternative intndvi and intbase method



            IF (icount EQ 0) THEN BEGIN
               GSN=NDVILine
               GST=XSeg
               GSB=BaseLine

            END ELSE BEGIN
               GSN=[GSN, NDVILine]
               GST=[GST, XSeg]
               GSB=[GSB, BaseLine]

            END
            icount=icount+1
         
         END ELSE BEGIN
            TotalNDVI[i]=FILL
;            GSB=0
;            GSN=0
;            GST=0
         END
      END; FOR i

      TotalNDVI={TotalNDVI:TotalNDVI $
           , GSB:GSB, GSN:GSN, GST:GST}

;die
   END; CASE 1 

;
; 2-D data, (not implemented yet but could be used for transects or isolines
;
   2: BEGIN
   END; CASE 2 

;
; 3-D data, ie doing metrics on a cube
;
   3: BEGIN
      TotalNDVI=Make_Array(Size=Size(Start_End.SOST))+FILL

      FOR i = 0, ny-1 DO BEGIN
         xlastidx=0
         nlastidx=0
         XSeg=FromTo(Time,  ceil(Start_End.SOST[*,*,i]), $
                     floor(Start_End.EOST[*,*,i]), LastIdx=XLastIdx)
         NDVILine=FromTo(NDVI, ceil(Start_End.SOST[*,*,i]), $
                     floor(Start_End.EOST[*,*,i]), LastIdx=NLastIdx) 

         BaseLine=XSeg*BaseSlope[*,*,i]+BaseInt[*,*,i]

         IntNDVI=Trap3D(NDVILine, fill=-1, LastMap=NLastIdx, $
                        StartX=Start_End.SOST[*,*,i], StartY=Start_End.SOSN[*,*,i], $
                        EndX=Start_End.EOST[*,*,i], EndY=Start_End.EOSN[*,*,i] ) 
         intndvi=intndvi>0

         IntBase=((Start_End.SOSN[*,*,i]+Start_End.EOSN[*,*,i])$
                 *(Start_End.EOST[*,*,i]-Start_End.SOST[*,*,i])/2.) >0

         TotalNDVI[*,*,i]=IntNDVI-IntBase

         tmpndvi=TotalNDVI[*,*,i]

       
         tmpndvi=tmpndvi*DaysPerBand
         idx=where(SeasonLength[*,*,i] LE  0 OR $
                   SeasonLength[*,*,i] GT bpy OR $
                   TotalNDVI[*,*,i] lt 0, nidx)
         IF (nidx gt 0) then tmpndvi[ idx ]=FILL

;         TotalNDVI[*,*,i]=tmpndvi*DaysPerBand
         TotalNDVI[*,*,i]=tmpndvi


;die
      END; FOR i
      TotalNDVI={TotalNDVI:TotalNDVI $
           , GSB:-1L, GSN:-1L, GST:-1L}

   END; CASE 3 
   ELSE:
   ENDCASE; Data dimension



RETURN, TotalNDVI
END;GetTotNDVI
