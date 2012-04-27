;---------------------------------------------------------------------------
; Author: Manuel J. Suarez
; $RCSfile$
; $Revision$
; Orig: 1999/05/26 8:32:04
; $Date$
;---------------------------------------------------------------------------
; Module: 
; Purpose: 
; Functions: 
; Procedures: 
; Calling Sequence: 
; Inputs: 
; Outputs: 
; Keywords: 
; History: 
;---------------------------------------------------------------------------
; $Log$
;---------------------------------------------------------------------------
PRO DrawLineWork, mLocal, devices, zooms

   numdev=n_elements(devices)
   LineFile=mLocal.LineFile
   widget_Control, mLocal.wParent, Get_UValue=mParent
   widget_control, mParent.wOpenFile, GET_UVALUE=minfo
   ddr = minfo.ddr

   widget_control,/HourGlass
   openr, linelun, LineFile, /GET_LUN
   numRecs = 0L;
   readf, linelun, numRecs

   for i = 1,numRecs do begin
      numPts = 0L;
      readf, linelun, numPts
      dataVec = dblarr(2,numPts);
      readf, linelun, dataVec
      dataVec[0,*] = dataVec[0,*] - ddr.ul[1]
      dataVec[0,*] = dataVec[0,*] / ddr.projdist[0]
      dataVec[1,*] = ddr.ul[0] - dataVec[1,*]
      dataVec[1,*] = dataVec[1,*] / ddr.projdist[0]
      dataVec[1,*] = mInfo.nl - dataVec[1,*]
      for idev=0, numdev-1 do begin
         wSet, devices[idev]
         plots,dataVec/zooms[idev],/device
      end
      
   endfor
   FREE_LUN,linelun




END
