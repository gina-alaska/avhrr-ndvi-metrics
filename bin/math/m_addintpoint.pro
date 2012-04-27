FUNCTION  m_AddIntPoint, x, y, XIntPts, YIntPts, IntPtsC
;print, ''
;print, "****IN M_ADDINTPOINT****"
@vectormath.h

   size_x=size(x)
;   size_x[n_elements(size_x)-1] = 2        ; set data type to byte
   status=Make_Array(Size=size_x)
   status = status*FALSE
   duplicate = status

   IntPtsCNew=IntPtsC


;
; Check for cells that are empty
;
   IPC0_idx = where(IntPtsC EQ 0, nIPC0)

   IF (nIPC0 GT 0) THEN BEGIN
;print, "EMPTY CELLS",nipc0

      XIntPts[IPC0_idx] = x[IPC0_idx]
      YIntPts[IPC0_idx] = y[IPC0_idx]
      IntPtsCNew[IPC0_idx] = IntPtsC[IPC0_idx]+ 1
 
      status[IPC0_idx] =  TRUE
   END


;
; Check cells that have been filled at least once
; (prior to entering this code)
;

   IPCGT0= where(IntPtsC gt 0, nIPCGT0)

   IF (nIPCGT0 gt 0) THEN BEGIN
;print, "FULL CELLS",nipcgt0

; Among points where where we have a value already, check to see
; if the new value is the same as the old value (ie, duplicate)

         diff=where(( ABS(x[IPCGT0] - XIntPts[IPCGT0]) LE EPSILON ) AND $
             ( ABS(y[IPCGT0] - YIntPts[IPCGT0]) LE EPSILON ),ndiff ) 

         IF (ndiff gt 0) then BEGIN
            duplicate[IPCGT0[diff]] = TRUE
            status[IPCGT0[diff]] = TRUE
         ENDIF


;
; If it's not a duplicate, put new value in.  
;
       nodupe = where(duplicate[IPCGT0] EQ FALSE, nnodupe)
 
       IF (nnodupe GT 0) THEN BEGIN
;print, "NOT DUPED CELLS",nnodupe
 
            XIntPts[IPCGT0[nodupe]] = x[IPCGT0[nodupe]]
            YIntPts[IPCGT0[nodupe]] = y[IPCGT0[nodupe]]
            IntPtsCNew[IPCGT0[nodupe]] = IntPtsC[IPCGT0[nodupe]] + 1 
;print, total(IntPtsCNew)
            status[IPCGT0[nodupe]] = TRUE
       ENDIF
   ENDIF

IntPtsC=IntPtsCNew
;plot, xintpts, yintpts, psym=4
;print, "Prior to exiting ADD", total(status), total(intptsc)
;print, "****EXIT M_ADDINTPOINT****"
;print, ''
RETURN, status

END
