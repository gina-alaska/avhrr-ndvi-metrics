; vuCube extracts a cube of data for processing in Surface and Volume
;         visualizations and for MooV animation...
;
; Parameters:
;
; FileName 	The input image file name.  If not given, this routine will
;  		prompt via the pick file dialog...
;
; FDims 	An array containing the dimensions of the image...
;
;         		FDims[0] ==> Number of samples
;         		FDims[1] ==> Number of Lines
;         		FDims[2] ==> Number of Bands
;         		FDims[3] ==> DataType  0: Byte, 1: Short Integer
;
; ProjInfo	A Double Precision array contain basic projection info
;
;			ProjInfo[0] ==> Upper Left Projection X Coordinate
;			ProjInfo[1] ==> Upper Left Projection Y Coordinate
;			ProjInfo[2] ==> Pixel Size
;
; Writen by DRS/EROS, 4-99
; ------------------------------------------------------------------------

; EVENT HANDLER FOR THE QUIT BUTTON
; ---------------------------------
PRO QuitButtonPress, Event
COMMON OLDCTBUF, saved_REDct, saved_GREENct, saved_BLUEct

; event structure
; event = {WIDGET_BUTTON, ID:0L, TOP:0L, HANDLER:0L}
; ID = widget ID of widget that cause event
; TOP = widget ID of the top-level-base
; destroy the top-level-base to end the application
; -------------------------------------------------
widget_control, event.top, get_uvalue = state
FREE_LUN,state.ImgLun
tvlct, saved_REDct, saved_GREENct, saved_BLUEct
widget_control,event.top,/destroy

END


; EVENT HANDLER FOR THE ANIMATE OVERVIEW BUTTON
; ---------------------------------------------
PRO AnimateOverView, Event

widget_control, event.top, get_uvalue = state
widget_control,/HourGlass

; Setup Buffer for the Image read from Disk...
; --------------------------------------------
tempBuf = bytarr(state.OverView_ns,state.OverView_nl)

openr, lun, state.OverView_filename, /GET_LUN

; Setup the animation window
; --------------------------
xinteranimate, set=[state.ViewSize_ns, state.ViewSize_nl, state.OverView_nb],$
	/SHOWLOAD, /TRACK, TITLE='OverView Animation'

; Load the imagery into the animation engine
; ------------------------------------------
for i=0, (state.OverView_nb-1) do begin
   readu,lun,tempBuf
   xinteranimate, FRAME=i, IMAGE=reverse(congrid(tempBuf, state.ViewSize_ns, $
	state.ViewSize_nl),2)
endfor
FREE_LUN,lun

; Pass control over to the animation engine
; -----------------------------------------
xinteranimate

END


; EVENT HANDLER FOR THE ANIMATE FULL REZ BUTTON
; ----------------------------------------------
PRO AnimateFullRez, Event

widget_control, event.top, get_uvalue = state
widget_control,/HourGlass

; Setup Buffer for the Image read from Disk...
; --------------------------------------------
tempBuf = bytarr(state.OverView_ns,state.OverView_nl)

openr, lun, state.OverView_filename, /GET_LUN

; Setup the animation window
; --------------------------
xinteranimate, set=[state.ViewSize_ns, state.ViewSize_nl, state.OverView_nb], $
	/SHOWLOAD, /TRACK, TITLE='FullRez Animation'

; Load the imagery into the animation engine
; ------------------------------------------
;print,state.img_ss,state.img_es,state.img_sl,state.img_el
for i=0, (state.OverView_nb-1) do begin
   readu,lun,tempBuf
   temp2 = tempBuf[state.img_ss:state.img_es-1,state.img_sl:state.img_el-1]
   xinteranimate, FRAME=i, IMAGE=reverse(temp2,2)
endfor
FREE_LUN,lun

; Pass control over to the animation engine
; -----------------------------------------
xinteranimate

END

; EVENT HANDLER FOR THE SURFACE VIEW BUTTON
; -----------------------------------------
PRO FullRezSurfaceView, Event

result = Dialog_Message('Pushed View Surface Button...', $
           title='Info only!')
END

; EVENT HANDLER FOR THE VOLUME VIEW BUTTON
; ---------------------------------------------
PRO FullRezVolView, Event

result = Dialog_Message('Pushed View Volume Button...', $
           title='Info only!')
END


; EVENT HANDLER FOR THE LINEWORK BUTTON--OVERVIEW
; -----------------------------------------------
PRO OverViewLineWork, Event
COMMON IMGFILEINFO, LineFile, ImgData, ImgBuf

widget_control, event.top, get_uvalue = state

wset, state.OverViewWin
if (event.select eq 1) then begin
   if (state.LineFileDefined eq 0) then BEGIN
      Linefile = Dialog_PickFile(Path='.', Filter='lines.txt',/MUST_EXIST)
      if (LineFile eq '') then BEGIN
 	  widget_control, event.id, Set_Button = 0
	  return
      endif
      state.LineFileDefined = 1
   endif
   widget_control,/HourGlass
   openr, linelun, LineFile, /GET_LUN
   numRecs = 0L;
   readf, linelun, numRecs

   for i = 1,numRecs do begin
      numPts = 0L;
      readf, linelun, numPts
      dataVec = dblarr(2,numPts);
      readf, linelun, dataVec
      dataVec[0,*] = dataVec[0,*] - state.UpperLeft_X
      dataVec[0,*] = dataVec[0,*] / (state.PixelSize * state.subSampleFactor)
      dataVec[1,*] = state.UpperLeft_Y - dataVec[1,*]
      dataVec[1,*] = dataVec[1,*] / (state.PixelSize * state.subSampleFactor)
      dataVec[1,*] = state.ViewSize_nl - dataVec[1,*]
      plots,dataVec,/device
   endfor
   FREE_LUN,linelun
   state.OverViewHasLines = 1
endif 
if (event.select eq 0) then begin
   if (state.scaleOverViewDisplay eq 1) then $
      tvscl, congrid(ImgBuf, state.ViewSize_ns, state.ViewSize_nl) $
   else tv, congrid(ImgBuf, state.ViewSize_ns, state.ViewSize_nl)
   state.OverViewHasLines = 2
endif
   
widget_control, event.top, set_uvalue = state

END


; EVENT HANDLER FOR THE LINEWORK BUTTON--FULL REZ
; -----------------------------------------------
PRO FullRezLineWork, Event
COMMON IMGFILEINFO, LineFile, ImgData, ImgBuf

widget_control, event.top, get_uvalue = state

wset, state.FullRezWin
if (event.select eq 1) then begin
   if (state.LineFileDefined eq 0) then BEGIN
      Linefile = Dialog_PickFile(Path='.', Filter='lines.txt',/MUST_EXIST)
      if (LineFile eq '') then BEGIN
          widget_control, event.id, Set_Button = 0
          return
      endif
      state.LineFileDefined = 1
   endif
   widget_control,/HourGlass
   openr, linelun, LineFile, /GET_LUN
   numRecs = 0L;
   readf, linelun, numRecs

   for i = 1,numRecs do begin
      numPts = 0L;
      readf, linelun, numPts
      dataVec = dblarr(2,numPts);
      readf, linelun, dataVec
      dataVec[0,*] = dataVec[0,*] - state.UpperLeft_X
      dataVec[0,*] = dataVec[0,*] / state.PixelSize
      dataVec[0,*] = dataVec[0,*] - state.img_ss
      dataVec[1,*] = state.UpperLeft_Y - dataVec[1,*]
      dataVec[1,*] = dataVec[1,*] / state.PixelSize
      dataVec[1,*] = dataVec[1,*] - state.img_sl
      dataVec[1,*] = state.ViewSize_nl - dataVec[1,*]
      plots,dataVec,/device
   endfor
   FREE_LUN,linelun
   state.FullRezHasLines = 1
endif 
if (event.select eq 0) then begin
   if (state.scaleOverViewDisplay eq 1) then $
      tvscl, ImgBuf[state.img_ss:state.img_es,state.img_sl:state.img_el] $
   else tv, ImgBuf[state.img_ss:state.img_es,state.img_sl:state.img_el]
   state.FullRezHasLines = 2
endif

widget_control, event.top, set_uvalue = state

END

; EVENT HANDLER FOR THE NDVI Color Table BUTTON
; ---------------------------------------------
PRO NDVIctButtonEvent, Event
COMMON OLDCTBUF, saved_REDct, saved_GREENct, saved_BLUEct

widget_control, event.top, get_uvalue = state

if (event.select eq 1) then begin
   if (NDVIctFile = Dialog_PickFile(Path='.', Filter='*.pal',/MUST_EXIST)) $
		then begin
      widget_control,/HourGlass
      openr, ctlun, NDVIctFile, /GET_LUN
      lutvar = intarr(4,256)
      readf, ctlun, lutvar
      tvlct, lutvar[1,*],lutvar[2,*],lutvar[3,*]
      FREE_LUN,ctlun
   endif else widget_control, event.id, Set_Button=0
endif else $
   tvlct, saved_REDct, saved_GREENct, saved_BLUEct

END

; EVENT HANDLER FOR THE OVERVIEW BAND SLIDER
; ------------------------------------------
PRO BandSliderEvent, Event
COMMON IMGFILEINFO, LineFile, ImgData, ImgBuf

widget_control, event.top, get_uvalue = state

widget_control,/HourGlass
ImgBuf[*,*] = ImgData[event.value-1]
wset, state.OverViewWin
if (state.scaleOverViewDisplay eq 1) then $
   tvscl, congrid(ImgBuf, state.ViewSize_ns, state.ViewSize_nl) $
else tv,congrid(ImgBuf, state.ViewSize_ns, state.ViewSize_nl)

state.currentBand = event.value - 1
widget_control, event.top, set_uvalue = state

; Cause a "fake" event to the linework button
; -------------------------------------------
OverViewLineWork, {WIDGET_BUTTON, ID:0L, TOP:event.top, HANDLER:0L, $
        SELECT:state.OverViewHasLines}

END

; EVENT HANDLER FOR SCALE DISPLAY TOGGLE--OverView WINDOW
; -------------------------------------------------------
PRO OverViewScale, Event
COMMON IMGFILEINFO, LineFile, ImgData, ImgBuf

widget_control, event.top, get_uvalue = state

wset, state.OverViewWin
if (event.select eq 1) then begin
   state.scaleOverViewDisplay = 1
   tvscl, congrid(ImgBuf, state.ViewSize_ns, state.ViewSize_nl)
endif else begin
   state.scaleOverViewDisplay = 0
   tv,congrid(ImgBuf, state.ViewSize_ns, state.ViewSize_nl)
endelse

widget_control, event.top, set_uvalue = state

; Cause a "fake" event to the linework button
; -------------------------------------------
OverViewLineWork, {WIDGET_BUTTON, ID:0L, TOP:event.top, HANDLER:0L, $
	SELECT:state.OverViewHasLines}


END


; EVENT HANDLER FOR SCALE DISPLAY TOGGLE--FULL REZ WINDOW
; -------------------------------------------------------
PRO FullRezScale, Event
COMMON IMGFILEINFO, LineFile, ImgData, ImgBuf

widget_control, event.top, get_uvalue = state

wset, state.FullRezWin
if (event.select eq 1) then begin
   state.scaleFullRezDisplay = 1
   tvscl, ImgBuf[state.img_ss:state.img_es,state.img_sl:state.img_el]
endif else begin
   state.scaleFullRezDisplay = 0
   tv, ImgBuf[state.img_ss:state.img_es,state.img_sl:state.img_el]
endelse

widget_control, event.top, set_uvalue = state

; Cause a "fake" event to the linework button
; -------------------------------------------
FullRezLineWork, {WIDGET_BUTTON, ID:0L, TOP:event.top, HANDLER:0L, $
        SELECT:state.FullRezHasLines}


END


; EVENT HANDLER FOR MOUSE EVENTS IN THE OVERVIEW DRAW WIDGET
; ----------------------------------------------------------
PRO OverViewDrawEvents, Event
COMMON IMGFILEINFO, LineFile, ImgData, ImgBuf

widget_control, event.top, get_uvalue = state

if (event.type eq 1) then BEGIN  ; Button release
   imgX = event.x * state.subSampleFactor
   imgY = state.OverView_nl - (event.y * state.subSampleFactor)
   ss = imgX - (state.ViewSize_ns/2)
   if (ss lt 0) then ss = 0
   if (ss gt ((state.OverView_ns - 1) - state.ViewSize_ns)) then $
	ss = (state.OverView_ns - 1) - state.ViewSize_ns
   es = ss + state.ViewSize_ns
   sl = imgY - (state.ViewSize_nl/2)
   if (sl lt 0) then sl = 0
   if (sl gt ((state.OverView_nl - 1) - state.ViewSize_nl)) then $
 	sl = (state.OverView_nl - 1) - state.ViewSize_nl
   el = sl + state.ViewSize_nl

; Get the Full Rez data
; ---------------------
;print,ss,es,sl,el
   wset, state.FullRezWin
   widget_control,/HourGlass
   if (state.scaleFullRezDisplay eq 1) then $
      tvscl, ImgBuf[ss:es, sl:el] $
   else tv, ImgBuf[ss:es, sl:el]
  
; Store the selected window (for full rez animation, surface, & volumes)
; ----------------------------------------------------------------------
   state.img_sl = sl
   state.img_el = el
   state.img_ss = ss
   state.img_es = es

   widget_control, event.top, set_uvalue = state

; Cause a "fake" event to the linework button
; -------------------------------------------
   FullRezLineWork, {WIDGET_BUTTON, ID:0L, TOP:event.top, HANDLER:0L, $
        SELECT:state.FullRezHasLines}
endif

END

; -----------MAINLINE WIDGET ROUTINE --------------

PRO vuCube, FileName, FDims, ProjInfo

COMMON IMGFILEINFO, LineFile, ImgData, ImgBuf
COMMON OLDCTBUF, saved_REDct, saved_GREENct, saved_BLUEct

; Check the number of parameters given
; ------------------------------------
if (n_params() eq 0) then BEGIN
   result = Dialog_Message('Image not specified!  Returning to caller...', $
	   title='Error!')
   return
endif

; Calculate the viewable image size.  This will be roughly around 250 * 480...
; ----------------------------------------------------------------------------
subSampleFactor = FIX((FDims[0] / 250.0) + 0.5)
display_ns = FIX(FDims[0] / subSampleFactor)
display_nl = FIX(FDims[1] / subSampleFactor)
print,'Viz Tool (v1.01)'
print,'Image:  ', FileName
print,'Display samples/lines:  ', display_ns, display_nl
print,'Subsampling factor:  ',subSampleFactor

; Setup various buttons, text areas, and draw widgets
; ---------------------------------------------------
TLB = WIDGET_BASE(/COLUMN, TITLE = 'Viz Tools (v1.01)')
base1 = WIDGET_BASE(TLB, /ROW, frame=2)
overViewBase = WIDGET_BASE(base1, /COLUMN, frame=2)
fullRezBase =  WIDGET_BASE(base1, /COLUMN, frame=2)
buttonBase =   WIDGET_BASE(TLB, /ROW, /ALIGN_RIGHT, space=30)
buttonBase1 =  WIDGET_BASE(buttonBase, /ROW, /NONEXCLUSIVE)
buttonBase2 =  WIDGET_BASE(buttonBase, /ROW)

overViewLabel = WIDGET_LABEL(overViewBase, value= 'OverView Image')
fullRezLabel =  WIDGET_LABEL(fullRezBase,  value= 'Full Resolution Window')

overViewImg = WIDGET_DRAW(overViewBase, retain=2, xsize=display_ns, $
	ysize=display_nl,  /BUTTON_EVENTS, /MOTION_EVENTS, $
	EVENT_PRO = 'OverViewDrawEvents')
fullRezImg =  WIDGET_DRAW(fullRezBase,  retain=2, xsize=display_ns, $
	ysize=display_nl)

OVBa = WIDGET_BASE(overViewBase, /ROW, /NONEXCLUSIVE)
FRBa = WIDGET_BASE(fullRezBase, /ROW, /NONEXCLUSIVE)

lineWork1 =  WIDGET_BUTTON(FRBa, value = 'Linework', $
	EVENT_PRO = 'FullRezLineWork')
scaleDsp1 =  WIDGET_BUTTON(FRBa, value = 'Scale Display', $
	EVENT_PRO = 'FullRezScale')
lineWork2 =  WIDGET_BUTTON(OVBa, value = 'Linework', $
	EVENT_PRO = 'OverViewLineWork')
scaleDsp =  WIDGET_BUTTON(OVBa, value = 'Scale Display', $
	EVENT_PRO = 'OverViewScale')
widget_control, scaleDsp, SET_BUTTON=1
widget_control, scaleDsp1, SET_BUTTON=1

SurfaceButton = WIDGET_BUTTON(fullRezBase, value = ' View Surface ', $
	EVENT_PRO = 'FullRezSurfaceView')
VolumeButton = WIDGET_BUTTON(fullRezBase, value = ' View Volume ', $
	EVENT_PRO = 'FullRezVolView')
widget_control, SurfaceButton, SENSITIVE=0
widget_control, VolumeButton,  SENSITIVE=0

AnimateButton1 = WIDGET_BUTTON(overViewBase, value = ' Animate ', $
	EVENT_PRO = 'AnimateOverView')
AnimateButton2 = WIDGET_BUTTON(fullRezBase,  value = ' Animate ', $
	EVENT_PRO = 'AnimateFullRez')

BandSlider = WIDGET_SLIDER(overViewBase, MIN= 1, MAX= FDims[2], VALUE=1, $
	EVENT_PRO = 'BandSliderEvent',/DRAG, $
	TITLE='  OverView Band Number  ')

NDVIct1 = WIDGET_BUTTON(buttonBase1, value = 'NDVI Color Table', $
	EVENT_PRO = 'NDVIctButtonEvent')

ExitButton = WIDGET_BUTTON(buttonBase2,value='    Exit    ', $
	EVENT_PRO='QuitButtonPress')

WIDGET_CONTROL, TLB, /REALIZE

; Read Image Overview into the OverView window
; --------------------------------------------
!order = 2
WIDGET_CONTROL, fullRezImg, get_value = FullRezWindowID
WIDGET_CONTROL, overViewImg, get_value = OverViewWindowID

ImgBuf = bytarr(FDims[0],FDims[1])
openr, lun, FileName, /GET_LUN
ImgData = assoc(lun, ImgBuf)
wset, OverViewWindowID 
widget_control,/HourGlass
ImgBuf[*,*] = ImgData[0]
tvscl, congrid(ImgBuf,display_ns,display_nl)

state = {OverView_filename:FileName, $		; Image file name
	OverView_ns: FDims[0], $		; Number of samples in image
	OverView_nl: FDims[1], $		; Number of lines in image
	OverView_nb: FDims[2], $		; Number of bands in image
  	ViewSize_ns: display_ns, $		; Display (Draw Widget) samples
	ViewSize_nl: display_nl, $		; Display (Draw Widget) lines
        LineFileDefined: 0L, $			; File Spec'd yet??
	ImgLun: lun, $				; LUN of image file
	currentBand: 0L, $			; Current band in Overview
	img_sl: 0L, $				; Window:  Starting Line
	img_el: 0L, $				; Window:  Ending Line
	img_ss: 0L, $				; Window:  Starting Sample
	img_es: 0L, $				; Window:  Ending Sample
	UpperLeft_X: ProjInfo[0], $		; Upper Left X Proj Coord
	UpperLeft_Y: ProjInfo[1], $		; Upper Left Y Proj Coord
	PixelSize: ProjInfo[2], $		; Image Pixel Size
	subSampleFactor: subSampleFactor, $	; Subsampling Factor
	scaleOverViewDisplay: 1L, $		; Display stretch flag--Overview
	scaleFullRezDisplay: 1L, $		; Display stretch flag--FullRez
	OverViewHasLines: 2L, $			; Linework Flag--Overview
	FullRezHasLines: 2L, $			; Linework Flag--FullRez
	FullRezWin:  FullRezWindowID, $		; IDL window ID--FullRez
	OverViewWin: OverViewWindowID $		; IDL window ID--Overview
	}

saved_REDct = bytarr(256)
saved_GREENct = bytarr(256)
saved_BLUEct = bytarr(256)
tvlct, saved_REDct, saved_GREENct, saved_BLUEct, /GET

WIDGET_CONTROL, TLB, SET_UVALUE = state, /NO_COPY

; Call Xmanager to start event handling
; -------------------------------------
XMANAGER, 'vuCube', TLB

END

