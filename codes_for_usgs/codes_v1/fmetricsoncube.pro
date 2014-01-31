PRO fMetricsOnCube, File, NS,NL,NB,ny, swl, ewl, bpy, DTYPE, ISS=ISS, ISL=ISL, $
    RESTART_X=RESTART_X, RESTART_Y=RESTART_Y
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
;          dtype=1                      <Data type: 1=Byte, 2=Int
;
; CALL:
;    metricsoncube2,File,...
;
; KEYWORDS:
;    ISS = Input Subcube Samples (number of samples in subcube processing unit)
;    ISL = Input Subcube Lines (number of lines in subcube processing unit)
;    RESTART_X = If it becomes necessary to resume processing following a failure,
;          this is the processing subcube number in the sample direction on which
;          to start
;    RESTART_Y = If it becomes necessary to resume processing following a failure,
;          this is the processing subcube number in the line direction on which
;          to start
;
;
; NOTE: This code automatically segments the data into 1500x3 blocks.
;  Don't worry if the input NS,NL are not evenly divisible by these, the
;  code will figure it out and handle the extra portion.  Alternately
;  you can set the block size by the keywords ISS, ISL (Input Subcube
;  Samples/Lines)
;  
; NOTE on EFFICIENCY:
;  I/O will be most efficient if you read by entire lines at a time, 
;  the number of lines you use needs to be small enough that you avoid
;  having to use swap space.
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


if n_elements(ISS) EQ 0 then iss=1500 else iss=iss
if n_elements(ISL) EQ 0 then isl=3    else isl=isl
 
if n_elements(RESTART_X) EQ 0 then start_i=0 else start_i=RESTART_X-1
if n_elements(RESTART_Y) EQ 0 then start_j=0 else start_j=RESTART_Y-1


   ni0 = NS / iss
   nj0 = NL / isl

   extras= NS mod iss
   extral= NL mod isl
   if extras eq 0 then ni=ni0-1 else ni=ni0
   if extral eq 0 then nj=nj0-1 else nj=nj0

   Data=fltarr(iss, isl, nb)
   count=0
   avgt1=0.0

;
; These loops segment the data so we can handle big files
; I'M SUCH AN IDIOT.  THESE INDICIES COUNT SUBCUBES.  NEED
; TO USE SS, SL FOR LOCATING SPOTS IN COPYCUBE AND SEGWRITE
;
   FOR j = start_j < nj, nj DO BEGIN

      CASE (j eq nj0) OF
         0: BEGIN
               il=isl
               sl=isl*j 
            END
         1: BEGIN
               il=extral
               sl=isl*j 
            END
         ELSE:
      ENDCASE

; I LOOP
      FOR i = start_i < ni, ni DO BEGIN

      count=count+1
      t0=systime(1)
          
      CASE (i eq ni0) OF
         0: BEGIN
               is=iss
               ss=iss*i 
            END
         1: BEGIN
               is=extras
               ss=iss*i 
            END
         ELSE:
      ENDCASE

print, 'PROCESSING Sub-Cube: Line ',strcompress(j+1,/rem),'/',$
                                    strcompress(nj+1,/rem),   $
                        '  Sample ',strcompress(i+1,/rem),'/',$
                                    strcompress(ni+1,/rem)

         Cube=CopyCube(File, NS, NL, ss,sl,0,is, il,NB,dt=DTYPE)
         tmpCube=scale(cube, min=dmin,max=dmax,xmin=-1.,xmax=1.)

         tmpMetrics=ComputeMetrics(tmpCube, wl, bpy, CurrentBand)
         m=ShiftCal(tmpMetrics,bpy,Fill=-1 )
undefine,tmpMetrics
;
; Convert Metrics to Integer
;
;         SOSN=fix(Round(Poly(m.SOSN, NDVI_Sc)))
;         SOST=fix(Round(Poly(m.SOST, Time_Sc)))
;         EOSN=fix(Round(Poly(m.EOSN, NDVI_Sc)))
;         EOST=fix(Round(Poly(m.EOST, Time_Sc)))
;         MaxN=fix(Round(Poly(m.MaxN, NDVI_Sc)))
;         MaxT=fix(Round(Poly(m.MaxT, Time_Sc)))
;         RangeN=fix(Round(Poly(m.RangeN, NDVI_Sc)))
;         RangeT=fix(Round(Poly(m.RangeT, Time_Sc)))
;         TotalNDVI=fix(Round(Poly(m.TotalNDVI, IntND_Sc)))
;         NDVItoDate=fix(Round(Poly(m.NDVItoDate, IntND_Sc)))
;         SlopeUp=fix(Round(Poly(m.SlopeUp, Slope_Sc)))
;         SlopeDown=fix(Round(Poly(m.SlopeDown, Slope_Sc)))


;
;
; Write out Metrics
;
         SegWrite, m.SOST, File+'.sost', NS, NL, ss,sl,0
         SegWrite, m.SOSN, File+'.sosn', NS, NL, ss,sl,0
         SegWrite, m.EOST, File+'.eost', NS, NL, ss,sl,0
         SegWrite, m.EOSN, File+'.eosn', NS, NL, ss,sl,0
         SegWrite, m.MaxT, File+'.maxt', NS, NL, ss,sl,0
         SegWrite, m.MaxN, File+'.maxn', NS, NL, ss,sl,0
         SegWrite, m.RangeT, File+'.ranget', NS, NL, ss,sl,0
         SegWrite, m.RangeN, File+'.rangen', NS, NL, ss,sl,0
         SegWrite, m.TotalNDVI, File+'.totalndvi', NS, NL, ss,sl,0
         SegWrite, m.NDVIToDate, File+'.ndvitodate', NS, NL, ss,sl,0
         SegWrite, m.SlopeUp, File+'.slopeup', NS, NL, ss,sl,0
         SegWrite, m.SlopeDown, File+'.slopedn', NS, NL, ss,sl,0

t1=systime(1)-t0
avgt1=(avgt1 * (count-1) +t1)/count
etc=(avgt1)*(long(nj+1L)*(ni+1L)-count)
hms=s2hms(etc)
print, 'Processed Sub-cube in: ',t1, ' sec'
print, 'Estimated Time to Completion: ', $
        strcompress(long(hms[0]),/rem),' hr  ', $
        strcompress(long(hms[1]),/rem),' min'
print, ' '

      ENDFOR; i
   ENDFOR; j

END
