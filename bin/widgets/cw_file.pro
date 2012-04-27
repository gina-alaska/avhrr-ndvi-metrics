;###########################################################################
; File Name:  %M%
; Version:    %I%
; Author:     Mike Schienle
; Orig Date:  96-12-27
; Delta Date: %G% @ %U%
;###########################################################################
; Purpose: Compound widget to provide file selection.
; History: 
;	97-03-14 MGS
;		Original heavily modified from CW_Field.
;###########################################################################
; %W%
;###########################################################################

FUNCTION CW_File_Event, Event

	;	get the state of the widget
	stateWidget	= WIDGET_INFO(Event.Handler, /CHILD)
	Widget_Control, stateWidget, GET_UVALUE=state, /NO_COPY
	
	IF (event.Id EQ state.wFile) THEN BEGIN
		;	file selection button selected
		fileName = Dialog_PickFile($
			FILTER=state.sFilter, $
			;	PATH=state.sPath, $
			;	GET_PATH=state.sPath, $
			READ=state.iRead, $
			WRITE=state.iWrite, $
			/NoConfirm)
		IF (fileName NE '') THEN BEGIN
			Widget_Control, state.wField, Set_Value=fileName
			Widget_Control, state.wField, /Input_Focus
		ENDIF
	ENDIF
	
	IF (state.event NE 0L) THEN BEGIN
		Widget_Control, state.wField, Get_Value=fileName
		mEvent = {$
			ID: state.wBase, $
			Top: state.event, $
			Handler: 0L, $
			Value: fileName}
	ENDIF ELSE BEGIN
		mEvent = 1
	ENDELSE

	;	Restore our state structure
	WIDGET_CONTROL, stateWidget, SET_UVALUE=state, /NO_COPY
	RETURN, mEvent
END

PRO CW_File_Set, base, value
	child = Widget_Info(base, /Child)
	Widget_Control, Child, Get_UValue=state, /No_Copy
	Widget_Control, state.wField, Set_Value=StrTrim(value, 2)
	Widget_Control, Child, Set_UValue=state, /No_Copy
END

FUNCTION CW_File_Get, Base
	child = Widget_Info(Base, /Child)
	Widget_Control, child, Get_UValue=State, /No_Copy
	Widget_Control, State.wField, Get_Value=gValue
	Widget_Control, child, Set_UValue=State, /No_Copy
	Return, StrTrim(gValue, 2)
END

;	If using EVENT it must be set to event.top of parent
Function CW_File, parent, $
	FILELABEL=fileLabel, FIELDLABEL=fieldLabel, $
	FONT=font, FILEFONT=fileFont, FIELDFONT=fieldFont, $
	FILEWIDTH=fileWidth, FIELDWIDTH=fieldWidth, $
	NOEDIT=noEdit, FILTER=filter, PATH=path, $
	TITLELEFT=titleLeft, TITLETOP=titleTop, TITLEFONT=titleFont, $
	READ=read, WRITE=write, $
	XOFFSET=xOffset, XSIZE=xSize, XPAD=xPad, $
	YOFFSET=yOffset, YSIZE=ySize, YPAD=yPad, $
	UVALUE=uValue, COLUMN=column, ROW=row, FRAME=frame, $
	EVENT=event
	
	
	IF (Widget_Info(parent, /Valid_Id)) THEN BEGIN
		IF (N_Elements(fileLabel) EQ 0L) THEN $
			fileLabel = 'FileName'
		IF (N_Elements(fieldLabel) EQ 0L) THEN $
			fieldLabel = 'FileName'
		IF (N_Elements(font) EQ 0L) THEN $
			font = ''
		IF (N_Elements(fileFont) EQ 0L) THEN $
			fileFont = font
		IF (N_Elements(fieldFont) EQ 0L) THEN $
			fieldFont = font
		IF (N_Elements(titleFont) EQ 0L) THEN $
			titleFont = font
		IF (N_Elements(fileWidth) EQ 0L) THEN $
			fileWidth = 0
		IF (N_Elements(fieldWidth) EQ 0L) THEN $
			fieldWidth = 0
		IF (N_Elements(uValue) EQ 0L) THEN $
			uValue = ''
		;	it is possible to request overlapping buttons
		IF (N_Elements(column) EQ 0L) THEN $
			column = 0
		IF (N_Elements(row) EQ 0L) THEN $
			row = 0
		IF (N_Elements(xOffset) EQ 0L) THEN $
			xOffset = 0
		IF (N_Elements(xSize) EQ 0L) THEN $
			xSize = 0
		IF (N_Elements(xPad) EQ 0L) THEN $
			xPad = 0
		IF (N_Elements(yOffset) EQ 0L) THEN $
			yOffset = 0
		IF (N_Elements(ySize) EQ 0L) THEN $
			ySize = 0
		IF (N_Elements(yPad) EQ 0L) THEN $
			yPad = 0
		IF (N_Elements(frame) EQ 0L) THEN $
			frame = 0
		IF (N_Elements(noEdit) EQ 0L) THEN $
			noEdit = 0
		IF (N_Elements(uValue) EQ 0L) THEN $
			uValue = 0
		IF (N_Elements(filter) EQ 0L) THEN $
			filter = ''
		IF (N_Elements(path) EQ 0L) THEN $
			CD, Current=path
		IF (N_Elements(WRITE) EQ 0L) THEN $
			write=0
		IF (N_Elements(READ) EQ 0L) THEN $
			IF (write EQ 0) THEN $
				read = 1 $
			ELSE $
				read = 0
		IF (N_Elements(event) EQ 0L) THEN $
			event = 0L

		;	IF (N_Elements(TitleLeft) EQ 0L) THEN $
		;		titleLeft = 0
		
		;	IF (N_Elements(TitleTop) EQ 0L) THEN $
		;		IF (titleLeft EQ 0L) THEN $
		;			titleTop = 1 $
		;		ELSE $
		;			titleTop = 0

		IF (N_Elements(Row) EQ 0L) THEN $
			row = 0

		IF (N_Elements(Column) EQ 0L) THEN $
			IF (row EQ 0L) THEN $
				column = 1 $
			ELSE $
				column = 0

		IF ((N_Elements(TitleTop) EQ 0L) AND $
			(N_Elements(TitleLeft) EQ 0L)) THEN BEGIN
			wBase = Widget_Base(parent, ROW=row, COLUMN=column, $
				XOFFSET=xOffset, XSIZE=xSize, XPAD=xPad, $
				YOFFSET=yOffset, YSIZE=ySize, YPAD=yPad, $
				FRAME=frame, EVENT_FUNC= 'CW_File_Event', $
				PRO_SET_VALUE= 'CW_File_Set', $
				FUNC_GET_VALUE= 'CW_File_Get')
			wBaseFF = wBase
		ENDIF ELSE BEGIN
			IF (N_Elements(TitleTop) NE 0L) THEN BEGIN
				row = 0
				column = 1
				title = titleTop
			ENDIF ELSE BEGIN	
				row = 1
				column = 0
				title = titleLeft
			ENDELSE
			
			wBase = Widget_Base(parent, ROW=row, COLUMN=column, $
				XOFFSET=xOffset, XSIZE=xSize, XPAD=xPad, $
				YOFFSET=yOffset, YSIZE=ySize, YPAD=yPad, $
				EVENT_FUNC= 'CW_File_Event', $
				PRO_SET_VALUE= 'CW_File_Set', $
				FUNC_GET_VALUE= 'CW_File_Get')
			
			wLabel = Widget_Label(wBase, Value=title, Font=titleFont)
			wBaseFF = Widget_Base(wBase, /Row, FRAME=frame)
		ENDELSE

		wFile = Widget_Button(wBaseFF, VALUE=fileLabel, FONT=fileFont, $
			XSize=fileWidth, /ALIGN_CENTER)
		wField = Widget_Text(wBaseFF, VALUE=fieldLabel, FONT=fieldFont, $
			XSize=fieldWidth, Units=1, /ALIGN_CENTER, /Editable)

		; Save our internal state in the first child widget
		State = {$
			wParent: parent, $
			wBase: wBase, $
			wFile: wFile, $
			wField: wField, $
			sFile: fileLabel, $
			sPath: path, $
			iRead: read, $
			iWrite: write, $
			sFilter: filter, $
			event: event}
		Widget_Control, (Widget_Info(wBase, /Child)), Set_UValue=State, $
			/No_Copy
	ENDIF ELSE BEGIN
		wBase = -1L
	ENDELSE

	Return, wBase

End
