;
;  This Procedure will pull a single "day" per month
;  from a composited smoothed data set
;
PRO InterpBands, day


;
; Get input file info and generate output file name
;
   wOpenFile=Open_File()
   Widget_Control, wOpenFile, Get_UValue=mInfo
   a=str_sep(minfo.file, '.')
   OutFile=a[0]+'_'+strcompress(day, /Remove_all)+'.'+a[1]
   OutDDR=a[0]+'_'+strcompress(day, /Remove_all)+'.ddr'

   BandsPerYear=minfo.bpy
   DaysPerPeriod=round(365./BandsPerYear)

;
; Pull some information out of structure
;
   NYears=minfo.nb / minfo.bpy
   IS=minfo.ns
   IL=minfo.nl
   DT=minfo.dt
   NBOut=Long(NYears*12)

; Allocate some space
   a1=fltarr(NYears*12)
   b1=fltarr(NYears*12)
   Band=fltarr(NYears*12)
   day1=lonarr(NYears*12)

; Number of days per month
   dpm=[31,28,31,30,31,30,31, 31, 30, 31,30,31]



;
; Figure out the Julian day of the first of each month
;
   FOR I = 0, 12*NYears-1 DO BEGIN
      Year=i/12
      Month=i mod 12
      Day1[i]= Total(dpm[0:Month]) - dpm[0] + Year*365
   END


;
; Figure out our day
;
   daypick=day1+day

   daycomp1=indgen(BandsPerYear)*DaysPerPeriod+7
   daycomp=indgen(BandsPerYear)*DaysPerPeriod+7

   FOR i=1,nYears-1 do BEGIN
      daycomp=[daycomp,daycomp1+365]
   ENDFOR

   count=0

;
; For each day we want, figure out linear interpolation
; coefficients.
;
   for i=0,BandsPerYear*NYears-2 DO BEGIN

      idx=where(daycomp[i] le daypick and daycomp[i+1] GT daypick, nidx)

      if (nidx gt 0) then BEGIN
         Band[count]=i
         b1[count]=float(daypick[idx[0]]-daycomp[i])/DaysPerPeriod
         a1[count]=1-b1[count]

         count=count+1
      ENDIF
   ENDFOR

;
; Look for existing output file, otherwise create it
;
   tmp=findfile(OutFile, count=count)
   IF count eq 0 then $
   OpenW, LUN, OutFile, /Get_LUN $
   ELSE $
   OpenU, LUN, OutFile, /Get_LUN



;
; Interpolate between bands and write results
;
   FOR I = 0, NYears*12-1 DO BEGIN

      D1=BandRead(minfo.file, Band[i], IS, IL, DT=DT, /Assoc)
      D2=BandRead(minfo.file, Band[i]+1, IS, IL, DT=DT, /Assoc)
      Dout=Byte(round(D1*a1[i] + D2*b1[i]))

      WriteU, LUN, Dout

   ENDFOR
   Free_LUN, LUN

;
; Create DDR for Output
;
ddr=minfo.ddr
newddr={ Rec1Header:ddr.Rec1Header $
       , SysType:ddr.SysType $
       , ProjUnit:ddr.ProjUnit $
       , Last_Used_Time:ddr.Last_Used_Time $
       , Last_Used_Date:ddr.Last_Used_Date $
       , nl:ddr.nl $
       , ns:ddr.ns $
       , nb:nbout $
       , dt:ddr.dt $
       , Master_Line:ddr.Master_Line $
       , Master_Sample:ddr.Master_Sample $
       , Valid:ddr.Valid $
       , ProjCode:ddr.ProjCode $
       , ZoneCode:ddr.ZoneCode $
       , Ellipsoid:ddr.Ellipsoid $
       , Spare:ddr.Spare $
       , Rec2Header:ddr.Rec2Header $
       , ProjCoef:ddr.ProjCoef $
       , UL:ddr.UL $ 
       , LL:ddr.LL $ 
       , UR:ddr.UR $ 
       , LR:ddr.LR $ 
       , ProjDist:ddr.ProjDist $
       , Increment:ddr.Increment $
       , BDDR:bytarr(199,nbout) $
       }
   imgwrite, newddr, OutDDR
END
