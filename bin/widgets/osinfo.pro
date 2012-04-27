;###########################################################################
; File Name:  osinfo.pro
; Version:    1.2
; Author:     Mike Schienle
; Orig Date:  96-11-29
; Delta Date: 4/1/97 @ 12:28:01
;###########################################################################
; Purpose: Gather/store OS information in a structure.
; History: 
;	97-04-01 MGS
;		Modified Wm Adjust field to be a 2x2 array. 
;		Intended to hold offsets for windows with full decorations, 
;		and windows with minimal decorations.
;###########################################################################
; @(#)osinfo.pro	1.2
;###########################################################################

FUNCTION OsInfo
	;	information keys off OS Family (MacOS, UNIX, Windows, VMS)
	sOsType = strlowcase(!Version.OS_Family)

	;	create the empty structure of information
	mOsInfo = {$
		sDiskChar: '', $		;	disk separator character
		sDirChar: '', $			;	directory separator character
		sWinName: '', $			;	Window manager name
		mBuffer: {$				;	buffer offsets
			frame: 0, $			;	frame boundary
			radio: 0, $			;	radio button (exclusive)
			check: 0, $			;	checkbox button (nonexclusive)
			button: 0}, $		;	button (regular)
		mWmOff: {$				;	Window manager offsets
			left: 0, $
			right: 0, $
			top: 0, $
			bottom: 0, $
			menubar: 0}, $
		aiWmAdj: intarr(2, 2)}	;	window manager adjustments

	;	fill in the structure based on OS Type
	case sOsType of
		'macos': begin
			mOsInfo.sDiskChar = ':'
			mOsInfo.sDirChar = ':'
			mOsInfo.sWinName = 'MAC'
			mOsInfo.mBuffer.frame = 5
			mOsInfo.mBuffer.radio = 12
			mOsInfo.mBuffer.check = 16
			mOsInfo.mBuffer.button = 8
			mOsInfo.mWmOff.left = 1
			mOsInfo.mWmOff.right = 16
			mOsInfo.mWmOff.top = 18
			mOsInfo.mWmOff.bottom = 18
			mOsInfo.mWmOff.menubar = 18
			mOsInfo.aiWmAdj(*) = 21
			end
		'unix': begin
			mOsInfo.sDiskChar = '/'
			mOsInfo.sDirChar = '/'
			mOsInfo.sWinName = 'X'
			mOsInfo.aiWmAdj(*) = 5
			mOsInfo.mWmOff.left = 5
			mOsInfo.mWmOff.right = 23
			mOsInfo.mWmOff.top = 5
			mOsInfo.mWmOff.bottom = 5
			end
		'vms': begin
			mOsInfo.sDiskChar = ':'
			mOsInfo.sDirChar = ']'
			mOsInfo.sWinName = 'X'
			mOsInfo.mWmOff.left = 5
			mOsInfo.mWmOff.right = 16
			mOsInfo.mWmOff.top = 5
			mOsInfo.mWmOff.bottom = 5
			end
		'windows': begin
			mOsInfo.sDiskChar = ':'
			mOsInfo.sDirChar = '\'
			mOsInfo.sWinName = 'WIN'
			mOsInfo.mWmOff.left = 1
			mOsInfo.mWmOff.right = 16
			mOsInfo.mWmOff.top = 16
			mOsInfo.mWmOff.bottom = 16
			end
		else:
	endcase
	return, mOsInfo
end
