FUNCTION MetricsOnCube, File, NS,NL,NB,ny, swl, ewl, bpy, numsamps, numlines, DTYPE
;
; This function segments a smoothed cube into chunks that can be handled
; by computemetrics without running out of memory and writes them out
; segment wise into image files.
;
; Example: File='texas_sm.img'          <Filename of smoothed image
;          NS=650                       <Number of Samples
;          NL=550                       <Number of Lines
;          NB=223                       <Number of Bands
;          ny=9                         <Number of years (including partial yrs)
;          swl=12                       <Moving average window length for SOS
;          ewl=18                       <Moving average window length for EOS
;          bpy=26                       <Bands per year
;          numsamps=50                  <num samps segments
;          numlines=50                  <num lines segments
;          dtype=1                      <Data type: 1=Byte, 2=Int
;
; CALL:
;    mmetrics=metricsoncube(File, ...)
;
; NOTE: For the moment, NS and NL must be evenly divisible by numsamps and
;  numlines respectively
;

@metrics_scaling.h
CurrentBand=(nb-1) mod bpy
wl=[swl, ewl]

Case (DTYPE) OF
1: begin
     dmin=0 
     dmax=200
   end
2: begin
     dmin=0 
     dmax=1023
   end
3: begin
     dmin=-1000.
     dmax=1000.
     dtype=2
   end
4: begin
     dmin=0 
     dmax=255
     dtype=1
   end
else:
endcase 

t0=SysTime(1)

      FOR i = 0, ns-numsamps,numsamps DO BEGIN
        FOR j = 0, nl-numlines,numlines DO BEGIN

print, 'PROCESSING LINE/SAMP:',j, i

         Cube=CopyCube(File, NS, NL, i,j,0,numsamps, numlines,NB,dt=DTYPE)
         tmpCube=scale(cube, min=dmin,max=dmax,xmin=-1.,xmax=1.)

         tmpMetrics=ComputeMetrics(tmpCube, wl, bpy, CurrentBand)

;
; Convert Metrics to Integer
;
;         SOSN=Round(Poly(tmpMetrics.SOSN, NDVI_Sc))
;         SOST=Round(Poly(tmpMetrics.SOST, Time_Sc))
;         EOSN=Round(Poly(tmpMetrics.EOSN, NDVI_Sc))
;         EOST=Round(Poly(tmpMetrics.EOST, Time_Sc))
;         MaxN=Round(Poly(tmpMetrics.MaxN, NDVI_Sc))
;         MaxT=Round(Poly(tmpMetrics.MaxT, Time_Sc))
;         RangeN=Round(Poly(tmpMetrics.RangeN, NDVI_Sc))
;         RangeT=Round(Poly(tmpMetrics.RangeT, Time_Sc))
;         TotalNDVI=Round(Poly(tmpMetrics.TotalNDVI, IntNDVI_Sc))
;         NDVItoDate=Round(Poly(tmpMetrics.NDVItoDate, IntNDVI_Sc))

;
; Write out Metrics
;
         SegWrite, tmpMetrics.SOST, File+'.sost', NS, NL, i,j,0
         SegWrite, tmpMetrics.SOSN, File+'.sosn', NS, NL, i,j,0
         SegWrite, tmpMetrics.EOST, File+'.eost', NS, NL, i,j,0
         SegWrite, tmpMetrics.EOSN, File+'.eosn', NS, NL, i,j,0
         SegWrite, tmpMetrics.MaxT, File+'.maxt', NS, NL, i,j,0
         SegWrite, tmpMetrics.MaxN, File+'.maxn', NS, NL, i,j,0
         SegWrite, tmpMetrics.RangeT, File+'.ranget', NS, NL, i,j,0
         SegWrite, tmpMetrics.RangeN, File+'.rangen', NS, NL, i,j,0
         SegWrite, tmpMetrics.TotalNDVI, File+'.totalndvi', NS, NL, i,j,0
         SegWrite, tmpMetrics.NDVIToDate, File+'.ndvitodate', NS, NL, i,j,0

      END;j
      END;i


print, 'TIME(MetricsOnCube):',(Systime(1)-t0)/60.,' min'
Return, 1;mMetrics
END
