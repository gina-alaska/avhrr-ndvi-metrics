;
; This function gets plot colors based on the updated
; colors found in updatect.pro.  This is only a temporary
; approach (and in fact isn't currently implemented.
; See note in SM_PLOTZOOM.PRO).
;
FUNCTION GetPlotColors, ct, ctshowing

  CASE (CTSHOWING) OF

     0: BEGIN
           Black	=rgb(0,0,0)
           Red		=rgb(255,0,0)
           Green	=rgb(0,255,0)
           Blue		=rgb(0,0,255)
           Yellow	=rgb(255,255,0)
           Cyan		=rgb(0,255,255)
           Magenta	=rgb(255,0,255)
           DarkGrey	=rgb(64,64,64)
           MedGrey	=rgb(128,128,128)
           LightGrey	=rgb(192,192,192)
           White	=rgb(128,128,128)
        END
     1: BEGIN
           Black	=230
           Red		=231
           Green	=232
           Blue		=233
           Yellow	=234
           Cyan		=235
           Magenta	=236
           DarkGrey	=249
           MedGrey	=250
           LightGrey	=251
           White	=252
        END
     ELSE:
  ENDCASE

   ctStruct={ Black:Black $
            , Red:Red $
            , Green:Green $
            , Blue:Blue $
            , Yellow:Yellow $
            , Cyan:Cyan $
            , Magenta:Magenta $
            , DarkGrey:DarkGrey $
            , MedGrey:MedGrey $
            , LightGrey:LightGrey $
            , White:White $
            }
 
            

RETURN, ctStruct
END
