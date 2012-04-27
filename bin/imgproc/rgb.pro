;=====   RGB   =============================================
; This function returns a number for a 24bit color given the
; three 8bit color components, red, green and blue
;===========================================================

FUNCTION RGB,RED,GREEN,BLUE

RETURN,RED + 256L*(GREEN + 256L*BLUE)
END
