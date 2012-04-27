FUNCTION OPEN_FILE, mParent
;
; Get image file name
;
        file = dialog_pickfile(title='Choose image file:', $
        	path='C:\metrics\Data',Filter='*.img',/MUST_EXIST)

       help,file
;
; Set up file information structure
;
;   mInfo ={mInfo}
;   mInfo.file = file
   CASE (1) OF
   file NE '': BEGIN
      slb = get_file_info(file)
      IF(slb.file EQ '') THEN Return, -1    ;MJS-7/12/99-Keep from bombing when
      mInfo=slb 							;    cancel is pushed during get_file_info.pro
      mInfo.ns=slb.ns
      mInfo.nl=slb.nl
      mInfo.nb=slb.nb
      mInfo.dt=slb.dt
;
; Get Bands Per Year
;
      CASE (slb.Comp) OF
      0: bpy=52
      1: bpy=36
      2: bpy=26
      3: bpy=24
      4: BEGIN
         IF(slb.CompType EQ 1) THEN bpy=slb.Other[0]
         IF(slb.CompType EQ 0) THEN bpy=round(365./slb.Other[0])
         END
      ELSE: bpy=-1
      ENDCASE; Comp
      mInfo.bpy=bpy
;
; Minimum and maximum values
;
      CASE (slb.DRange) OF
      0: BEGIN minval=0 & maxval=200
         END
      1: BEGIN minval=0 & maxval=255
         END
      2: BEGIN minval=0 & maxval=1023
         END
      3: BEGIN minval=-1000 & maxval=1000
         END
      ELSE:BEGIN minval=-1 & maxval=-1
         END
      END
      mInfo.minval=minval
      mInfo.maxval=maxval
      mInfo.startyear=slb.startyear
   END
   file EQ '': return, -1					;MJS-7/12/99-keep it from bombing when
   ELSE:									;    cancel is pushed while getting file name.
   ENDCASE;(1)
if(mInfo.ns eq -1) then file=''
mInfo.file=file
wBase=Widget_Base(UValue=mInfo)
;mParent.wOpenFile=wBase
return, wBase
END