FUNCTION read_las_ddr,ddrfile
;
; Read a LAS file
;
; DATE: Last Modified: 4/26/99
;

  DDR = {LASDDR}

  ;ddrfile = pickfile(filter="*.ddr")
  openr, lun, ddrfile, /get_lun

  ; set up the DDRINT, DDRDUB, and BDDR records
  rec1 = bytarr(151)
  rec2 = bytarr(248)
  rec3 = bytarr(199)

; read the DDRINT record & get the NL, NS, NB, DT
  readu, lun, rec1
  
  ddr.Rec1Header=byte(rec1(0:31))

  ddr.nl=long(rec1,79)
  print,ddr.nl,' lines'

  ddr.ns=long(rec1,79+4)
  print,ddr.ns,' samples'

  ddr.nb=long(rec1,79+2*4)
  print,ddr.nb,' bands'

  ddr.dt=long(rec1,79+3*4)
  CASE ddr.dt OF
    1: print,'byte data'
    2: print,'short data'
    3: print,'long data'
    4: print,'float data'
    else: print,'invalid data type'
  ENDCASE

  ddr.master_line=long(rec1, 79+4*4)
  ddr.master_sample=long(rec1, 79+5*4)
  for i = 0, 7 DO  ddr.valid(i)=long(rec1, 79+6*4 +i*4)

  ddr.ProjCode=long(rec1, 79+14*4)
  ddr.ZoneCode=long(rec1, 79+15*4)
  ddr.Ellipsoid=long(rec1, 79+16*4)
;print, "PC:", ddr.ProjCode
;print, "ZC:", ddr.ZoneCode
;print, "EL:", ddr.Ellipsoid

;  ddr.SysType=bytarr(12)
  for i = 0, 11 do ddr.SysType(i)=byte(rec1, 32+i)
;ddr.systype=rec1(32:43)
  ;print, string(ddr.SysType)
;print, string(rec1(32:42))
;print, string(rec1(32:45))

; ddr.ProjUnit=bytarr(12)
  for i = 0, 11 do ddr.ProjUnit(i)=byte(rec1, 32+12+i)
;ddr.ProjUnit=rec1(44:55)
  ;print, string(ddr.ProjUnit)

;  ddr.Last_Used_Date=bytarr(12)
  for i = 0, 11 do ddr.Last_Used_Date(i)=byte(rec1, 32+24+i)
;ddr.Last_Used_Date=rec1(56:67)
  ;print, string(ddr.Last_Used_Date)

;  ddr.Last_Used_Time=bytarr(12)
  for i = 0, 10 do ddr.Last_Used_Time(i)=byte(rec1, 32+36+i)
;ddr.Last_Used_Time=rec1(68:79)
  ;print, string(ddr.Last_Used_Time)


; read the DDRDUB record
  readu, lun, rec2
  ddr.Rec2Header=byte(rec2(0:31))
;print, ddr.Rec2Header
;  ProjCoef=dblarr(15)
  for i = 0, 14 do ddr.ProjCoef[i]=double(rec2, 32+i*8)
  ;print, ddr.projcoef

  ddr.UL=dblarr(2)
  ddr.UL[0]=double(rec2, 32+15*8)
  ddr.UL[1]=double(rec2, 32+16*8)

  ddr.LL=dblarr(2)
  ddr.LL[0]=double(rec2, 32+17*8)
  ddr.LL[1]=double(rec2, 32+18*8)

  ddr.UR=dblarr(2)
  ddr.UR[0]=double(rec2, 32+19*8)
  ddr.UR[1]=double(rec2, 32+20*8)

  ddr.LR=dblarr(2)
  ddr.LR[0]=double(rec2, 32+21*8)
  ddr.LR[1]=double(rec2, 32+22*8)

  print,"UL:",ddr.UL
  print,"UR:",ddr.UR
  print,"LL:",ddr.LL
  print,"LR:",ddr.LR

  ddr.ProjDist=dblarr(2)
  ddr.ProjDist[0]=double(rec2, 32+23*8)
  ddr.ProjDist[1]=double(rec2, 32+24*8)
  print, "PD:", ddr.ProjDist

  ddr.Increment=dblarr(2)
  ddr.Increment[0]=double(rec2, 32+25*8)
  ddr.Increment[1]=double(rec2, 32+26*8)
  ;print, "IN:", ddr.Increment



; read the appropriate number of BDDR records
BDDR=bytarr(199, ddr.nb)
  FOR i=0,ddr.nb-1 do BEGIN
    readu, lun, rec3
bddr(*,i)=rec3

  ENDFOR

  free_lun,lun


ddr=create_struct(ddr, 'bddr', bddr)
Return, DDR
end
