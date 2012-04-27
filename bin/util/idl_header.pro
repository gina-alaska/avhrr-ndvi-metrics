;--------------------------------------------------------------------------
;                   Copyright 1998 - Interactive Visuals
;--------------------------------------------------------------------------
; Author: Mike Schienle
; $RCSfile$
; $Revision$
; Orig: 1998/09/08
; $Date$
;--------------------------------------------------------------------------
; Purpose: Generate IDL source control header files.
; History:
;--------------------------------------------------------------------------
; $Log$
;--------------------------------------------------------------------------

;	procedure to output the Purpose and History lines
FUNCTION IDL_Header_Author, sName
	IF (StrLen(sName) EQ 0) THEN $
		Return, ' $Author$' $
	ELSE $
		Return, ' Author: ' + sName
END

;	procedure to output the Purpose and History lines
PRO IDL_Header_Block, iLun, sComment
	;	output the Purpose and History lines
	PrintF, iLun, sComment + ' Module: '
	PrintF, iLun, sComment + ' Purpose: '
	PrintF, iLun, sComment + ' Functions: '
	PrintF, iLun, sComment + ' Procedures: '
	PrintF, iLun, sComment + ' Calling Sequence: '
	PrintF, iLun, sComment + ' Inputs: '
	PrintF, iLun, sComment + ' Outputs: '
	PrintF, iLun, sComment + ' Keywords: '
	PrintF, iLun, sComment + ' History: '
END

;	function to return the date with a specified separator
FUNCTION IDL_Header_Date, aDT, sSeparator
	;	create the "Original" date string and return it
	Return, StrTrim(aDT(0), 2) + sSeparator + $
		StrZero(aDT(1), 2) + sSeparator + $
		StrZero(aDT(2), 2)
END

;	function to return the date with a specified separator
FUNCTION IDL_Header_Time, aDT
	;	create the "Original" time string and return it
	Return, StrTrim(aDT(3), 2) + ':' + $
		StrZero(aDT(4), 2) + ':' + $
		StrZero(aDT(5), 2)
END

PRO IDL_Header, $
	Type=sType, $
	File=sFile, $
	Name=sName, $
	Copyright=sCopyright, $
	Width=iWidth, $
	Help=iHelp
	
	;	get current !Quiet value
	iQuiet = !Quiet
	
	;	Type is header type [string] (RCS, SCCS, PVCS, CVS)
	;	File is output file [string] (output window)
	;	Name is author's name [string] (none)
	;	Copyright is copyright message [string] (none)
	;	Width is the width of the header lines [integer] (76)
	;	Help is help keyword [boolean] (0, 1)
	
	;	An attempt has been made to output dates in the same format
	;	as the source control program. 
	
	;	determine if Help was requested
	IF (N_Elements(iHelp) NE 0) THEN BEGIN
		Print, 'usage: IDL_Header [, Type="RCS|SCCS|PVCS|CVS"] $'
		Print, '	[, File="file"] [, Name="author"] $'
		Print, '	[, Copyright="copyright"] [, Width=integer] $'
		Print, '	[, Help=0|1]'
		Print, ''
	ENDIF ELSE BEGIN
		IF (N_Elements(sFile) NE 0) THEN BEGIN
			;	open the file, check for errors
			OpenW, iLun, sFile, /Get_Lun, Error=iErr
			
			;	check for error while opening file
			IF (iErr NE 0) THEN BEGIN
				Print, !Err_String
				Print, 'Setting output to Output Log'
				Print, ''
				iLun = -1
			ENDIF
		ENDIF ELSE BEGIN
			iLun = -1
		ENDELSE
		
		;	check if we are writing to the Output Log instead of a file
		IF (iLun EQ -1) THEN $
			;	suppress compile messages so output will be uninterrupted
			!Quiet = 1
		
		;	set the width of the header lines
		IF (N_Elements(iWidth) EQ 0) THEN $
			iWidth = 76
		;	set the comment character to a variable
		sComment = ';'
		;	use the dash character as a byte
		bDash = 45b
		;	use the space character as a byte
		bSpace = 32b
		
		;	create a comment line
		sCommentLine = sComment + String(BytArr(iWidth - 1) + bDash)

		;	get an array of today's date/time information
		aDT = Bin_Date()
		
		;	begin generating header 
		PrintF, iLun, sCommentLine

		;	check if Copyright was passed in
		IF (N_Elements(sCopyright) NE 0) THEN BEGIN
			;	copyright message passed in
			;	add "Copyright YYYY - " to beginning of message
			sCopyright = 'Copyright ' + StrTrim(aDT(0), 2) + ' - ' + $
				sCopyright
			
			;	center the message and print it out
			PrintF, iLun, sComment + String(BytArr((iWidth - $
				StrLen(sCopyright)) / 2 - 1) + bSpace) + sCopyright

			;	print a comment line as a separator
			PrintF, iLun, sCommentLine
		ENDIF

		;	see if the name was passed in
		IF (N_Elements(sName) EQ 0) THEN $
			;	no name passed in - default it to empty string
			sName = ''
		
		;	determine type of file requested
		IF (N_Elements(sType) EQ 0) THEN $
			sType = 'RCS' $
		ELSE $
			sType = StrUpCase(sType)
		
		CASE sType OF
			'RCS':	BEGIN
				;	Revision Control System specified
				;	the author, filename, and revision tags
				PrintF, iLun, sComment + IDL_Header_Author(sName)
				PrintF, iLun, sComment + ' $RCSfile$'
				PrintF, iLun, sComment + ' $Revision$'
				
				;	get the "Original" date string
				PrintF, iLun, sComment + ' Orig: ' + $
					IDL_Header_Date(aDT, '/') + ' ' + $
					IDL_Header_Time(aDT)

				;	output the date placeholder
				PrintF, iLun, sComment + ' $Date$'
				
				;	ouput a comment line
				PrintF, iLun, sCommentLine
				
				;	output the Purpose and History block
				IDL_Header_Block, iLun, sComment
				
				;	ouput a comment line
				PrintF, iLun, sCommentLine
				
				;	output the Log placeholder
				PrintF, iLun, sComment + ' $Log$'
				
				;	ouput a comment line
				PrintF, iLun, sCommentLine
				
				;	output a blank line
				PrintF, iLun, ''
				END
			'SCCS':	BEGIN
				;	Source Code Control specified
				;	the author, filename, and revision tags
				PrintF, iLun, sComment + ' Author: ' + sName
				PrintF, iLun, sComment + ' File Name: %M%'
				PrintF, iLun, sComment + ' Version: %I%
				
				;	get the "Original" date string
				PrintF, iLun, sComment + ' Orig: ' + $
					IDL_Header_Date(aDT, '/') + ' ' + $
					IDL_Header_Time(aDT)

				;	output the date placeholder
				PrintF, iLun, sComment + ' Delta Date: %G% %U%'
				
				;	ouput a comment line
				PrintF, iLun, sCommentLine
				
				;	output the Purpose and History block
				IDL_Header_Block, iLun, sComment
				
				;	ouput a comment line
				PrintF, iLun, sCommentLine
				
				;	output the "what" holder section
				PrintF, iLun, sComment + ' %W%'
				
				;	ouput a comment line
				PrintF, iLun, sCommentLine
				
				;	output a blank line
				PrintF, iLun, ''
				END
			'PVCS':	BEGIN
				;	PVCS Control specified
				;	the author, filename, and revision tags
				PrintF, iLun, sComment + IDL_Header_Author(sName)
				PrintF, iLun, sComment + ' $Workfile$'
				PrintF, iLun, sComment + ' $Revision$'
				
				;	get the "Original" date string
				PrintF, iLun, sComment + ' Orig: ' + SysTime()

				;	output the date placeholder
				PrintF, iLun, sComment + ' $Modtime$'
				
				;	ouput a comment line
				PrintF, iLun, sCommentLine
				
				;	output the Purpose and History block
				IDL_Header_Block, iLun, sComment
				
				;	ouput a comment line
				PrintF, iLun, sCommentLine
				
				;	output the Log placeholder
				PrintF, iLun, sComment + ' $Log$'
				
				;	ouput a comment line
				PrintF, iLun, sCommentLine
				
				;	output a blank line
				PrintF, iLun, ''
				END
			'CVS':	BEGIN
				;	CVS Control specified
				;	the author, filename, and revision tags
				PrintF, iLun, sComment + IDL_Header_Author(sName)
				PrintF, iLun, sComment + ' $Id$'
				PrintF, iLun, sComment + ' $Revision$'
				
				;	get the "Original" time string
				PrintF, iLun, sComment + ' Orig: ' + $
					IDL_Header_Date(aDT, '/') + ' ' + $
					IDL_Header_Time(aDT)

				;	output the date placeholder
				PrintF, iLun, sComment + ' $Date$'
				
				;	ouput a comment line
				PrintF, iLun, sCommentLine
				
				;	output the Purpose and History block
				IDL_Header_Block, iLun, sComment
				
				;	ouput a comment line
				PrintF, iLun, sCommentLine
				
				;	output the Log placeholder
				PrintF, iLun, sComment + ' $Log$'
				
				;	ouput a comment line
				PrintF, iLun, sCommentLine
				
				;	output a blank line
				PrintF, iLun, ''
				END
			ELSE:
		ENDCASE

		;	release the lun
		IF (iLun NE -1) THEN $
			Free_Lun, iLun
	ENDELSE
	!Quiet = iQuiet
END
