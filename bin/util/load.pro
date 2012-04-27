PRO Load, file, data, ASCII=ascii, BINARY=binary
;
; Simply reads either a binary (default) or ascii file
; into previously defined variable, Data
;



OpenR, LUN, file, /Get_LUN

IF(N_Elements(ASCII) GT 0) THEN ReadF, LUN, Data $
ELSE ReadU, LUN, Data


Free_LUN, LUN
End
