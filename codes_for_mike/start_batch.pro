PRO START_BATCH, batch_log_name, batch_unit 
; 
; An example shortcut procedure for initiating ENVI batch mode. 
; 
IF (N_PARAMS() GT 0) THEN BEGIN 
   ; If a batch log file is requested, make sure the filename 
   ; is valid (i.e., a scalar string) and then initiate batch 
   ; mode. 
   sz = SIZE(batch_log_name) 
   IF (sz(0) NE 0) OR (sz(1) NE 7) THEN BEGIN 
      PRINT, 'ERROR: Filename argument must be a scalar string.' 
      RETURN 
   ENDIF 
   ENVI, /RESTORE_BASE_SAVE_FILES 
   ENVI_BATCH_INIT, LOG_FILE = batch_log_name, $ 
      BATCH_LUN = batch_unit 
ENDIF ELSE BEGIN 
   ; If no batch file is requested, just initiate batch mode. 
   ENVI, /RESTORE_BASE_SAVE_FILES 
   ENVI_BATCH_INIT 
ENDELSE 
 
END 

