FUNCTION GetMaxNDVI, NDVI, Time, Start_End, bpy

   FILL=-1.0
   ndSize=Size(NDVI)
   nSize=Size(Start_End.SOST)

   IF (ndSize[0] EQ nSize[0]) THEN $
   nSeasons=nSize[nSize[0]] $
   ELSE nSeasons=1


   CASE(NDSize[0]) OF

   1: BEGIN
      MaxN=fltarr(nSeasons)+FILL
      MaxT=fltarr(nSeasons)+FILL

      FOR i = 0, nSeasons-1 DO BEGIN

         if (Start_End.EOST[i] GT Start_End.SOST[i]  AND $
             Start_End.EOST[i]-Start_End.SOST[i] LT bpy) THEN BEGIN

            MaxN[i]=Max(NDVI[fix(Start_End.SOST[i]):fix(Start_End.EOST[i])])
            MaxIdx=where(NDVI[fix(Start_End.SOST[i]):fix(Start_End.EOST[i])] EQ  MaxN[i])
            MaxT[i]=MaxIdx[0]+fix(Start_End.SOST[i])

         END ELSE BEGIN
            MaxN[i] = FILL
            MaxT[i] = FILL
         END
      END; FOR i
   END;1

   2: BEGIN
   END;2

   3: BEGIN

      MaxN=fltarr(nSize[1], nSize[2], nSeasons)+FILL
      MaxT=fltarr(nSize[1], nSize[2], nSeasons)+FILL
       
      FOR i = 0, nSeasons-1 DO BEGIN
          
;
;MJS 4/1/99 lastband, lastloc had been sost, sosn.  I changed to eost,eosn
;
         SeasonN=FromTo(NDVI, ceil(Start_End.SOST[*,*,i]), floor(Start_End.EOST[*,*,i]), $
                       Firstband=Start_End.SOSN[*,*,i], LastBand=Start_End.EOSN[*,*,i], $
                       FirstLoc=Start_End.SOST[*,*,i], LastLoc=Start_End.EOST[*,*,i])

         SeasonT=FromTo(Time, ceil(Start_End.SOST[*,*,i]), floor(Start_End.EOST[*,*,i]), $
                       Firstband=Start_End.SOST[*,*,i], LastBand=Start_End.EOST[*,*,i], $
                       FirstLoc=Start_End.SOST[*,*,i], LastLoc=Start_End.EOST[*,*,i])

         MaxND=Max3D(SeasonN, ZLocation=MaxTime) 

BadIdx=where(Start_End.SOST[*,*,i] LT 0 OR Start_End.EOST[*,*,i] LT 0, nbad)

IF nbad gt 0 then MaxND[BadIdx]=FILL
         MaxN[*,*,i]=MaxND

         tmpMaxT=IndexMap(SeasonT, MaxTime)
IF nbad gt 0 then tmpMaxT[BadIdx]=FILL
         MaxT[*,*,i]=tmpMaxT

      END; FOR i



   END;3
   ELSE:
   ENDCASE

   MaxND={MaxN:MaxN, MaxT:MaxT}

RETURN, MaxND
END
