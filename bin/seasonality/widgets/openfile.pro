;---------------------------------------------------------------------------
; Author: Manuel J. Suarez
; $RCSfile$
; $Revision$
; Orig: 1999/05/19 9:03:25
; $Date$
;---------------------------------------------------------------------------
; Module: OpenFile
; Purpose: Open an image file, check for header(s), write new header,
;   pack image info into structure.
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

;======================;
; OPENFILE_READ_HEADER ;
;======================;
FUNCTION OpenFile_Read_Header, File

   FileRoot=Str_Sep(File, Sep='.')
   SMHName=FileRoot+".smh" 
   DDRName=FileRoot+".ddr" 

;
; Check for .smh file header
;
   IF( Compare(FindFile(SMHName) EQ SMHName, [1])) THEN BEGIN
      mInfo=Read_SMHdr(SMHName)
   END ELSE IF( Compare(FindFile(DDRName) EQ DDRName, [1])) THEN BEGIN
      ddr=Read_LAS_DDR(DDRName)

RETURN, mInfo
END



;===================;
; WIDGET_DEFINITION ;
;===================;
FUNCTION OpenFile, wParent

;
; Get Image File Name
;   
   File=Dialog_PickFile(Title='Choose Image File:')
   IF (File EQ '') THEN RETURN, -1L


RETURN, wOpenFile
EXIT
