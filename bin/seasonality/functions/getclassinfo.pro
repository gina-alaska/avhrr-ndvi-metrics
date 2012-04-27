;---------------------------------------------------------------------------
; Author: Manuel J. Suarez
; $RCSfile$
; $Revision$
; Orig: 1999/05/25 21:20:45
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
FUNCTION GetClassInfo, fileRoot, mImageInfo

   lccFile=fileRoot+'.lcc'	; Land Cover Image File
   attFile=fileRoot+'.att'	; Land Cover attribute File
   palFile='lcc159.pal'		; Land Cover color palette	


; ========= Check to see if land cover image is available =========

   IF (compare(findfile(lccFile) EQ lccFile, [1])) THEN BEGIN
      lccExist=1L
      lccFile=lccFile
      lccImage=BandRead(lccFile,0,mImageInfo.ns, mImageInfo.nl, dtype=1)
   ENDIF ELSE BEGIN
      lccExist=0L
      lccFile= ''
      lccImage=-1L
   END

; ========= Check to see if land cover attribute file is available =========
   IF (compare(findfile(attFile) EQ attFile, [1])) THEN BEGIN
      attExist=1L
      attFile=attFile
      attTable=readtab(attFile, 2, 160, 0,sep=':')
      attTable=attTable.data[1,*]
   ENDIF ELSE BEGIN
      attExist=0L
      attFile= ''
      attTable=-1L
   END

; ========= Check to see if land cover color palette is available =========
   IF (compare(findfile(palFile) EQ palFile, [1])) THEN BEGIN
      palExist=1L
      palFile=palFile
      palTable=readtab(palFile, 2, 160, 0,sep=':')
      palTable=palTable.data
   ENDIF ELSE BEGIN
      palExist=0L
      palFile= ''
      palTable=-1L
   END


   mClassInfo={ lccFile : lccFile  $
              , lccExist: lccExist $
              , lccImage: lccImage $
              , attFile : attFile  $
              , attExist: attExist $
              , attTable: attTable $
              , palFile : palFile  $
              , palExist: palExist $
              , palTable: palTable $
              }



RETURN, mClassInfo
END
