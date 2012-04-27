;---------------------------------------------------------------------------
; Author: Manuel J. Suarez
; $RCSfile$
; $Revision$
; Orig: 1999/05/07 21:30:00
; $Date$
;---------------------------------------------------------------------------
; Module: 
; Purpose: 
; Functions: 
; Procedures: 
; Calling Sequence: 
; Inputs: 
; Outputs: 
; Keywords: 
; History: 
;---------------------------------------------------------------------------
; $Log$
;---------------------------------------------------------------------------

PRO GetBox, x, y, mBox

;
; This procedure calculates box parameters
;
       halfx=mBox.XBoxSize/2
       halfY=mBox.YBoxSize/2

; Get Center of reduced box and calculate box
       mBox.XCenter = ((x > (mBox.ImgOffset[0]+HalfX)) < $
                       (mBox.ImgSize[0]+mBox.ImgOffset[0]-HalfX))
       mBox.YCenter = ((y > (mBox.ImgOffset[1]+HalfY)) < $
                       (mBox.ImgSize[1]+mBox.ImgOffset[1]-HalfY))

       XCent = mBox.XCenter
       YCent = mBox.YCenter


       mBox.XBox = round([XCent - halfX, XCent + halfX, $
                 XCent + halfX, XCent - halfX, XCent - halfX])
       mBox.YBox = round([YCent - halfY, YCent - halfY, $
                 YCent + halfY, YCent + halfY, YCent - halfY])


END
