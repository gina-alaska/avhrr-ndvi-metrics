FUNCTION ShiftCal, metrics, bpy, FILL=FILL

; This function looks at the first band of the key metric.
; for any (x,y) where the int_year of the first band is
; 1, shift that whole z-profile back
;
inSize=Size(metrics.SOST)
ns=inSize[1]
nl=inSize[2]
nb=inSize[3]

;FILL=-1


fillidx=where(metrics.maxt le 0, nf)
sfillidx=where(metrics.sost le 0, nsf)
efillidx=where(metrics.eost le 0, nef)

;
; Calculate year number and fractional day
;
int_year=floor(metrics.maxt / bpy)
new_year=int_year
frac_day=(metrics.maxt mod bpy)/bpy
new_frac_day=frac_day
sost=(metrics.sost mod bpy)/bpy
nsost=sost
eost=(metrics.eost mod bpy)/bpy
neost=eost

nmaxn=metrics.maxn
nsosn=metrics.sosn
neosn=metrics.eosn
ntotalndvi=metrics.totalndvi
nndvitodate=metrics.ndvitodate
nranget=metrics.ranget
nrangen=metrics.rangen
nslopeup=metrics.slopeup
nslopedown=metrics.slopedown

if (nf gt 0) then int_year[fillidx]=FILL

;
; This part takes care of the missing first year shift
; shift toward the back
;  Need to include remappings for other metrics
;
for j=1,nb-1 do begin                    ;this loop doesn't need to be so big
sh_idx=where(new_year[*,*,j-1] EQ j,nsh)
if(nsh GT 0) THEN BEGIN
for i=j,nb-1 do begin
   new_year[(ns*nl*i)+sh_idx]=int_year[(ns*nl*(i-1))+sh_idx]
   new_frac_day[(ns*nl*i)+sh_idx]=frac_day[(ns*nl*(i-1))+sh_idx]
   nsost[(ns*nl*i)+sh_idx]=sost[(ns*nl*(i-1))+sh_idx]
   neost[(ns*nl*i)+sh_idx]=eost[(ns*nl*(i-1))+sh_idx]
   nmaxn[(ns*nl*i)+sh_idx]=metrics.maxn[(ns*nl*(i-1))+sh_idx]
   nsosn[(ns*nl*i)+sh_idx]=metrics.sosn[(ns*nl*(i-1))+sh_idx]
   neosn[(ns*nl*i)+sh_idx]=metrics.eosn[(ns*nl*(i-1))+sh_idx]
   ntotalndvi[(ns*nl*i)+sh_idx]=metrics.totalndvi[(ns*nl*(i-1))+sh_idx]
   nndvitodate[(ns*nl*i)+sh_idx]=metrics.ndvitodate[(ns*nl*(i-1))+sh_idx]
   nranget[(ns*nl*i)+sh_idx]=metrics.ranget[(ns*nl*(i-1))+sh_idx]
   nrangen[(ns*nl*i)+sh_idx]=metrics.rangen[(ns*nl*(i-1))+sh_idx]
   nslopeup[(ns*nl*i)+sh_idx]=metrics.slopeup[(ns*nl*(i-1))+sh_idx]
   nslopedown[(ns*nl*i)+sh_idx]=metrics.slopedown[(ns*nl*(i-1))+sh_idx]
endfor
new_year[(ns*nl*(j-1))+sh_idx]=FILL
new_frac_day[(ns*nl*(j-1))+sh_idx]=FILL
nsost[(ns*nl*(j-1))+sh_idx]=FILL
neost[(ns*nl*(j-1))+sh_idx]=FILL
nmaxn[(ns*nl*(j-1))+sh_idx]=FILL
nsosn[(ns*nl*(j-1))+sh_idx]=FILL
neosn[(ns*nl*(j-1))+sh_idx]=FILL
ntotalndvi[(ns*nl*(j-1))+sh_idx]=FILL
nndvitodate[(ns*nl*(j-1))+sh_idx]=FILL
nranget[(ns*nl*(j-1))+sh_idx]=FILL
nrangen[(ns*nl*(j-1))+sh_idx]=FILL
nslopeup[(ns*nl*(j-1))+sh_idx]=FILL
nslopedown[(ns*nl*(j-1))+sh_idx]=FILL
ENDIF
endfor

; Update Fill index
FillIdx=where(new_year EQ FILL, nf)
sfillidx=where(nsost le 0, nsf)
efillidx=where(neost le 0, nef)

;
; Now need to shift some bands the other direction and adjust the metric
; date
;
; Only need to shift metrics for
;
for i=1, nb-1 do begin
sh_idx=where(new_year[*,*,i] EQ i-1,nsh)
if(nsh GT 0) THEN BEGIN
   new_year[(ns*nl*i)+sh_idx]=int_year[(ns*nl*i)+sh_idx]+1
   new_frac_day[(ns*nl*i)+sh_idx]=frac_day[(ns*nl*i)+sh_idx]-1
   nsost[(ns*nl*i)+sh_idx]=sost[(ns*nl*i)+sh_idx]-1
   neost[(ns*nl*i)+sh_idx]=eost[(ns*nl*i)+sh_idx]-1
ENDIF
endfor

;
; Restore Fill
;
if nf gt 0 then begin
  new_year[FIllIdx]=Fill
  new_frac_day[FIllIdx]=Fill
  nmaxn[FillIdx]=Fill
  nslopeup[FillIdx]=Fill
  nslopedown[FillIdx]=Fill
  nranget[FillIdx]=Fill
  nrangen[FillIdx]=Fill
  ntotalndvi[FillIdx]=Fill
ENDIF

if nsf gt 0 then begin
  nsost[sFIllIdx]=Fill
  nsosn[sFIllIdx]=Fill
  ntotalndvi[sFillIdx]=Fill
end

if nef gt 0 then begin
  neost[eFIllIdx]=Fill
  neosn[eFIllIdx]=Fill
end


;
; make sure SOST < Maxt and EOST > MaxT
;
sidx=where(nsost gt new_frac_day and nsost ne fill and new_frac_day ne fill, nsi)
eidx=where(neost lt new_frac_day and neost ne fill,nei )
if nsi gt 0 then nsost[sidx]=nsost[sidx]-1
if nei gt 0 then neost[eidx]=neost[eidx]+1

m={$
    maxt:new_frac_day $
  , maxn:nmaxn $
  , sost:nsost $
  , sosn:nsosn $
  , eost:neost $
  , eosn:neosn $
  , ranget:nranget $
  , rangen:nrangen $
  , slopeup:nslopeup $
  , slopedown:nslopedown $
  , totalndvi:ntotalndvi $
  , ndvitodate:nndvitodate $
  }


;die


return, m
END
