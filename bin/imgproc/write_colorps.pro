PRO Write_ColorPS, file, image, TRUE=true
;
; This procedure writes a 24bit color image to an 8bit
; color PostScript file
;
CurrentDevice=!D.Name

Device, FILE=file, /COLOR, BITS=8
TV, image, TRUE=true
Device, /CLOSE

Set_Plot=CurrentDevice

END
