;###########################################################################
; File Name:  fontgen.pro
; Version:    1.1
; Author:     Mike Schienle
; Orig Date:  96-12-17
; Delta Date: 24 Feb 1997 @ 14:57:19
;###########################################################################
; Purpose: 
; History: 
;###########################################################################
; @(#)fontgen.pro	1.1
;###########################################################################

FUNCTION FontGen, PROP=prop, MONO=mono, SYMBOL=symbol
	IF (N_Elements(prop) EQ 0L) THEN $
		prop = 'times'

	IF (N_Elements(mono) EQ 0L) THEN $
		mono = 'courier'

	IF (N_Elements(symbol) EQ 0L) THEN $
		symbol = 'symbol'

	;	get Operating System info
	mOsInfo = OsInfo()
    IF (mOsInfo.sWinName EQ 'X') THEN BEGIN
    	;	We're using UNIX (possible VMS - but we'll ignore that)
    	;	specify the names of proportional and monospace fonts
    	asFontName = ['-*-' + prop + '-', $
			'-*-' + mono + '-', $
			'-*-' + symbol + '-']
    	;	specify font weights
		asFontWeight = ['medium-', 'bold-']
		;	specify "extras" - string completers
    	asFontExtra = ['r-*-*-', '*']
    ENDIF ELSE BEGIN
    	;	Non-UNIX (Mac, Windows)
    	;	specify the names of proportional and monospace fonts
    	asFontName = [prop + '*', mono + '*', symbol + '*']
    	;	specify font weights
		asFontWeight = ['', 'bold*']
		;	specify "extras" - string completers
    	asFontExtra = ['', '']
    ENDELSE

	;	specify the hardware fonts - not Hershey vector fonts
	;	!P.Font = -1
    ;   font strings
    ;	UNIX style
	;	-adobe-times-medium-r-normal--12-120-75-75-p-64-iso8859-1
	;	Mac/PC Style
	;	times*bold*18, times*18

    ;   font sizes
    asFontSize = ['10', '12', '18', '24']
    ;	abbreviated font wieghts
    asFontWAbbr = ['m', 'b']

	;	create a structure of font names, proportional and monospace
    sCmdFont = 'mFont = {'
	FOR fs = 0, (n_elements(asFontSize) - 1) DO $
		FOR fw = 0, (n_elements(asFontWeight) - 1) DO $
			sCmdFont = sCmdFont + $
				'prop' + asFontSize(fs) + asFontWAbbr(fw) + ':"' + $
				asFontName(0) + asFontWeight(fw) + asFontExtra(0) + $
				asFontSize(fs) + asFontExtra(1) + '", ' + $
				'mono' + asFontSize(fs) + asFontWAbbr(fw) + ':"' + $
				asFontName(1) + asFontWeight(fw) + asFontExtra(0) + $
				asFontSize(fs) + asFontExtra(1) + '", ' + $
				'symbol' + asFontSize(fs) + asFontWAbbr(fw) + ':"' + $
				asFontName(2) + asFontWeight(fw) + asFontExtra(0) + $
				asFontSize(fs) + asFontExtra(1) + '", '

	sCmdFont = StrMid(sCmdFont, 0, StrLen(sCmdFont) - 2) + '}'
	;	example follows - Mac/PC version
	;	mFont = {prop10m:"times*10", mono10m:"courier*10", $
	;	prop10b:"times*bold*10", mono10b:"courier*bold*10", $
	;	...
	;	prop24m:"times*24", mono24m:"courier*24", $
	;	prop24b:"times*bold*24", mono24b:"courier*bold*24"}

    status = Execute(sCmdFont)

	;	return the font structure
	Return, mFont
END
