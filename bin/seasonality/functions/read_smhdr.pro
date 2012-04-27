;
; This function reads a Seasonal Metrics Header file and stuffs
; the information into a structure
;
Function Read_SMHdr, file

;
; Define Struction from smhdr__define.pro
;
   SMHDR={SMHDR}
;
; Read Header File
;
   OpenR, LUN, File, /Get_LUN

   str=strarr(2)
   ReadF, LUN,str
   SMHDR.File=str[0]
   SMHDR.Label=str[1]
   ReadF, LUN,ltmp &  SMHDR.NS=long(ltmp)
   ReadF, LUN,ltmp & SMHDR.NL=long(ltmp)
   ReadF, LUN,ltmp & SMHDR.NB=long(ltmp)
   ReadF, LUN,ltmp & SMHDR.DT=long(ltmp)

   ReadF, LUN,ltmp & SMHDR.ProjCode =long(ltmp)
   ReadF, LUN,ltmp & SMHDR.ZoneCode =long(ltmp)
   ReadF, LUN,ltmp & SMHDR.Ellipsoid=long(ltmp)

   ftmp=dblarr(15)
   ReadF, LUN,ftmp & SMHDR.ProjCoef=double(ftmp)

   ftmp=dblarr(2)
   ReadF, LUN, ftmp & SMHDR.UL=ftmp
   ReadF, LUN, ftmp & SMHDR.LL=ftmp
   ReadF, LUN, ftmp & SMHDR.UR=ftmp
   ReadF, LUN, ftmp & SMHDR.LR=ftmp

   ReadF, LUN, ftmp & SMHDR.ProjDist=ftmp
   ReadF, LUN, ftmp & SMHDR.ProjIncr=ftmp

   ReadF, LUN, ftmp & SMHDR.UnScale=ftmp
   ReadF, LUN, ltmp & SMHDR.Min=long(ltmp)
   ReadF, LUN, ltmp & SMHDR.Max=long(ltmp)

   ReadF, LUN, ltmp & SMHDR.BPY=long(ltmp)
   ReadF, LUN, ltmp & SMHDR.DPP=long(ltmp)
ltmp=lonarr(3)
   ReadF, LUN, ltmp & SMHDR.DATE=long(ltmp)


   Free_LUN, LUN

Return, smhdr
END
