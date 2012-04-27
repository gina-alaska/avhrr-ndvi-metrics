; GSURFACE
;
; Demo Program for visualizing Greenness surfaces via IDL Object Graphics
;
; DRS 3/31/99...
;
; Event handlers are first, followed by object definitions, and finally, the
; mainline routine with widget setups...
; --------------------------------------

; MODEL ROTATION SLIDER EVENT HANDLER--AS WELL AS X,Y,Z BUTTON EVENTS 
; -------------------------------------------------------------------
PRO RotSliderEvent, Event

; Slider Events
; Event = {WIDGET_SLIDER, ID:0L, TOP:0L, HANDLER:0L, VALUE:0L, DRAG:0}
;
; Event.Value is the current position of the slider!
;
widget_control, event.top, get_uvalue = state  ;get the state structure back
rot = event.value - state.sliderVal
state.sliderVal = event.value
state.oModel->Rotate, [state.x,state.y,state.z], rot
state.oWindow->Draw, state.oView
widget_control, event.top, set_uvalue = state  ;put it back! (only needed if changed...)
END

PRO ZButtonPress, Event
;
; Button Events
; Event = {WIDGET_BUTTON, ID:0L, TOP:0L, HANDLER:0L, SELECT:0}
;
; Event.select is used to determine if a toggle button is on of off
;
widget_control, event.top, get_uvalue = state  ;get the state structure back
state.z = event.select
widget_control, event.top, set_uvalue = state  ;put it back! (only needed if changed...)
END

PRO YButtonPress, Event
;
; Button Events
; Event = {WIDGET_BUTTON, ID:0L, TOP:0L, HANDLER:0L, SELECT:0}
;
; Event.select is used to determine if a toggle button is on of off
;
widget_control, event.top, get_uvalue = state  ;get the state structure back
state.y = event.select
widget_control, event.top, set_uvalue = state  ;put it back! (only needed if changed...)
END

PRO XButtonPress, Event
;
; Button Events
; Event = {WIDGET_BUTTON, ID:0L, TOP:0L, HANDLER:0L, SELECT:0}
;
; Event.select is used to determine if a toggle button is on of off
;
widget_control, event.top, get_uvalue = state  ;get the state structure back
state.x = event.select
widget_control, event.top, set_uvalue = state  ;put it back! (only needed if changed...)
END



; EVENT FOR THE COLOR DROP LIST
; -----------------------------
PRO ColorDropListEvent, Event

widget_control, event.top, get_uvalue = state  ;get the state structure back

; DropList Event
; Event = {WIDGET_DROPLIST, ID:0L, TOP:0L, HANDLER:0L, INDEX:0}
;
; Event.index ==> the index of the selected list item
; ---------------------------------------------------
case event.index of
  0: color = [255,100,100]
  1: color = [100,235,100]
  2: color = [100,100,255]
  3: color = [215,215,215]
  4: color = [100,100,100]
endcase

state.oSurface->SetProperty, COLOR=color
state.oWindow->Draw, state.oView

widget_control, event.top, set_uvalue = state  ;put it back!

END



; EVENT PROCESSING FOR THE SLICE SLIDER
; -------------------------------------
PRO SliceSliderEvent, Event

; Slider Events
; Event = {WIDGET_SLIDER, ID:0L, TOP:0L, HANDLER:0L, VALUE:0L, DRAG:0}
;
; Event.Value is the current position of the slider!
; --------------------------------------------------
widget_control, event.top, get_uvalue = state  ;get the state structure back

sliceVal = event.value

; Scale-->this will change!!!!
; ----------------------------
sliceVal = (sliceVal - 25.0)/50.0
state.oPoly->SetProperty, $
	DATA=[[sliceVal,-0.6,0],[sliceVal,-0.6,0.6],[sliceVal,0.6,0.6],[sliceVal,0.6,0]]
state.sliceLoc = event.value
state.oWindow->Draw, state.oView
wset, state.oPlotWindow
plot, (*state.dataPtr)[event.value-1,*]

widget_control, event.top, set_uvalue = state  ;put it back! (only needed if changed...)
END


PRO OnButtonPress, Event

widget_control, event.top, get_uvalue = state
state.oPoly->SetProperty, HIDE=0
state.oWindow->Draw, state.oView
END

PRO OffButtonPress, Event

widget_control, event.top, get_uvalue = state
state.oPoly->SetProperty, HIDE=1
state.oWindow->Draw, state.oView
END


; HANDLE EVENTS FROM THE DRAW WIDGET
; ----------------------------------
PRO ObjDrawEvents, Event

widget_control, event.top, get_uvalue = state  ;get the state structure back

; Check for double click events
; -----------------------------
if (event.clicks eq 2) then begin
   state.mode = (state.mode + 1) mod 2
endif

; Check Exposure
; --------------
if (event.type eq 4) then state.oWindow->Draw, state.oView

; Check the trackball -- call the update method
; ---------------------------------------------
h = state.oTrack->UPDATE(Event, TRANSFORM = new, TRANSLATE = state.mode)
if (h) then begin  ; trackball update occurred...

; Get the old transform matrix from the model and multiply the old X new
; ----------------------------------------------------------------------
   state.oModel->GetProperty, TRANSFORM=old
   state.oModel->SetProperty, TRANSFORM=old#new
   state.oWindow->Draw, state.oView
endif

widget_control, event.top, set_uvalue = state  ;put it back!

END


; EVENT HANDLER FOR THE QUIT BUTTON
; --------------------------------- 
PRO QuitButtonPress, Event

; event structure
; event = {WIDGET_BUTTON, ID:0L, TOP:0L, HANDLER:0L}
; ID = widget ID of widget that cause event
; TOP = widget ID of the top-level-base
; destroy the top-level-base to end the application
; -------------------------------------------------
widget_control,event.top,/destroy

END



; CLEANUP ROUTINE (UPON EXIT)
; ---------------------------
PRO SurfManipCleanup, TLB

; Widget Cleanup routines are sent one argument -- the widget ID of the
;  top-level-base...
; Get the state structure from the TLB
; ------------------------------------
widget_control, tlb, get_uvalue = state

; Cleanup all the objects in the state structure
; ----------------------------------------------
for i=0, n_tags(state) - 1 do begin
   if (obj_valid(state.(i))) then begin
   		obj_destroy, state.(i)
   endif
endfor

END


; DEFINE SURFACE OBJECTS AND PLACE IN THE MODEL/VIEW
; --------------------------------------------------
PRO SurfObj, zData, View = View, Model=Model, Surface = Surface, PolySlice = xPoly

if (n_params() eq 0) then begin		; If no parameters, generate them!
	zData = -shift(dist(50), 25, 15)
endif

; create the graphics hierarchy
; -----------------------------
; View->Model->Surface
;
; Create the view object and set the background color to grey
; -----------------------------------------------------------
View = obj_new('IDLgrView', EYE=3, PROJECTION=2, COLOR=[40,40,40],ZCLIP=[1.4,-1.4])
Model = obj_new('IDLgrModel')
View->Add, Model

; Create the surface object (a graphical atom) & add it to the model
; ------------------------------------------------------------------
Surface = obj_new('IDLgrSurface', zData, STYLE=2, SHADING=0, $
	COLOR=[100,100,255], BOTTOM=[64,192,128])
Model->Add, Surface

; Add a slicing plane...
; ----------------------
xPoly = obj_new('IDLgrPolygon',$
	[[-0.48,-0.6,0.0],[-0.48,-0.6,0.6],[-0.48,0.6,0.6],[-0.48,0.6,0.0]], $
	COLOR=[255,100,100])
Model->Add, xPoly
xPoly->SetProperty, HIDE=1

; Get some properties from the Surface Object
; -------------------------------------------
Surface->GetProperty, XRANGE=xr,YRANGE=yr,ZRANGE=zr

; Calculate coordinate conversions
; The default view sets up a coordinate system from -1 to 1.  We must set up
; coordinate conversion factors to fit the surface into this coordinate system
; ----------------------------------------------------------------------------
xc = norm_coord(xr)
yc = norm_coord(yr)
zc = norm_coord(zr)

; Coordinate conversion factors
;  [s0,s1]				(two element vector)
;  Cx = s0 + s1 * x		(Coordinate conversion equation)
;  where  s0 ==> shifting
;    and  s1 ==> scaling
;
; shift the data left(x), down(y), and back(z) - 0.5
; --------------------------------------------------
xc[0] = xc[0] - 0.5
yc[0] = yc[0] - 0.5
zc[0] = zc[0] - 0.5

; Apply the coordinate conversion factors to the surface
; ------------------------------------------------------
Surface->SetProperty, XCOORD=xc, YCOORD=yc, ZCOORD=zc

; Add a light source to the object
; --------------------------------
Light1 = obj_new('IDLgrLight', TYPE=1, LOCATION=[1,-1,2])
Model->Add, Light1
Light2 = obj_new('IDLgrLight', TYPE=0, INTENSITY=0.5)
Model->Add, Light2

; Add Axes.....
; -------------
;xaxis = OBJ_NEW('IDLgrAxis',0)
;yaxis = OBJ_NEW('IDLgrAxis',1)
;zaxis = OBJ_NEW('IDLgrAxis',2)
;Model->Add, xaxis;
;Model->Add, yaxis;
;Model->Add, zaxis;

; Rotate the model slightly
; -------------------------
Model->Rotate,[1,0,0], -90
Model->Rotate,[0,1,0], 30
Model->Rotate,[1,0,0], 30

; Set the surface to filled so the light will shade the surface
; -------------------------------------------------------------
;Surface->SetProperty, STYLE=2

END


; Mainline GREENNESS SURFACE DEMO
; -------------------------------
PRO GSurface

; Create the top level base (tlb); request resize events
; ------------------------------------------------------
tlb = widget_base(TITLE='Surface Viewer', /TLB_SIZE_EVENTS, /COLUMN)

; Create a draw widget for object graphics
; Set EXPOSE_EVENTS in object graphics
; you must set GRAPHICS_LEVEL=2 for object graphics
; -------------------------------------------------
draw = widget_draw(tlb, XSIZE=310, YSIZE=300, /BUTTON_EVENTS,/MOTION_EVENTS, $
 		/EXPOSE_EVENTS, GRAPHICS_LEVEL=2, EVENT_PRO='ObjDrawEvents')
base0 = widget_base(tlb, /ROW, Frame=2)
plotdraw = widget_draw(base0, XSIZE=300, YSIZE=150)

base1 = widget_base(tlb,/ROW, frame=2)
base1a = widget_base(base1,/COLUMN, frame=2)
rotSlider = widget_slider(base1a, MIN= -360, MAX= 360, VALUE=0, $
		EVENT_PRO = 'RotSliderEvent',/DRAG, TITLE='  Surface Rotation  ') 
axisBase= widget_base(base1a, /ROW, /EXCLUSIVE)
xButton = widget_button(axisBase, VALUE='X', EVENT_PRO='XButtonPress')
yButton = widget_button(axisBase, VALUE='Y', EVENT_PRO='YButtonPress')
zButton = widget_button(axisBase, VALUE='Z', EVENT_PRO='ZButtonPress')
widget_control, xbutton, SET_BUTTON=1

base1b = widget_base(base1, /Column, frame=2)
sliceSlider = widget_slider(base1b, MIN= 1, MAX= 50, VALUE=1, $
    EVENT_PRO = 'SliceSliderEvent',/DRAG, TITLE='       Profile')
base1b1 = widget_base(base1b, /ROW, /EXCLUSIVE)
onButton = widget_button(base1b1, VALUE='On', EVENT_PRO='OnButtonPress')
offButton = widget_button(base1b1, VALUE='Off', EVENT_PRO='OffButtonPress')
widget_control, offButton, SET_BUTTON=1

base2 = widget_base(tlb, /ROW, frame=2)
colors = ['RED','GREEN','BLUE','WHITE','BLACK']
colorDrop = widget_droplist(base2, VALUE=colors, $
	TITLE='Surface Color: ', EVENT_PRO = 'ColorDropListEvent')
widget_control, colorDrop, SET_DROPLIST_SELECT = 2

quitbutton = widget_button(base2, VALUE='   Quit   ', EVENT_PRO='QuitButtonPress')
widget_control, tlb, /REALIZE

; Get the window object reference to the draw widget
; When GRAPHICS_LEVEL=2 is set, the VALUE of a draw widget is a window object
; ---------------------------------------------------------------------------
widget_control, draw, GET_VALUE = oWindow
widget_control, plotdraw, GET_VALUE = oPlotWindow

openr,lun,'/edcsnw10/home/stein/seasons/data/westtest.img',/get_lun
da_data = bindgen(50,50,256)
readu, lun, da_data
close, lun
new_data = bindgen(50,256)
new_data[*,*] = da_data[20,*,*]
smooth_data = smooth(new_data,9,/edge_truncate)
surfobj, smooth_data, VIEW=oView, MODEL=oModel, SURFACE=oSurface, POLYSLICE=oPoly
oWindow->Draw, oView

; Create a trackball object -- this is a helper object that does not need to be
; added to a graphical hierarch
; Pass in a center pt ([200,200]) and a radius (200) in device (pixel) coordinates
; --------------------------------------------------------------------------------
oTrack = obj_new('Trackball',[200,200],200)

; Create a state structure
; ------------------------
state = {oWindow:oWindow, oView:oView, oSurface:oSurface, oModel:oModel, $
	   oPoly:oPoly, oTrack:oTrack, sliceLoc:0, $
	   oPlotWindow:oPlotWindow, dataPtr:ptr_new(smooth_data), $
	   mode:0, x:1, y:0, z:0, sliderVal:0}

widget_control, tlb, set_uvalue = state, /NO_COPY

; Call Xmanager to start event handling
; -------------------------------------
Xmanager, 'surfmanip', tlb, CLEANUP='SurfManipCleanup', /NO_BLOCK

END
