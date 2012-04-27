;---------------------------------------------------------------------------
; Author: Manuel J. Suarez
; $RCSfile$
; $Revision$
; Orig: 1999/05/08 13:14:27
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
FUNCTION GetZoomImage, DevX, DevY, Image, mBox, Zoom


       x = (0 > DevX) < (mBox.ImgSize[0]-1)
       y = (0 > (mBox.ImgSize[1]-DevY-1)) < (mBox.ImgSize[1] - 1)



   halfX=mBox.XBoxSize/2
   halfY=mBox.YBoxSize/2


   ZoomXUL = (0 > (X - halfX)) < (mBox.ImgSize[0] - mBox.XBoxSize)
   ZoomYUL = (0 > (Y - halfY)) < (mBox.ImgSize[1] - mBox.YBoxSize)

;   ZoomImage=ConGrid(Image[ZoomXUL:ZoomXUL+mBox.XBoxSize-1, ZoomYUL:ZoomYUL+mBox.YBoxSize-1],$
;                     mBox.XBoxSize*Zoom, mBox.YBoxSize*Zoom)                   
   ZoomImage=Rebin(Image[ZoomXUL:ZoomXUL+mBox.XBoxSize-1, ZoomYUL:ZoomYUL+mBox.YBoxSize-1],$
                     mBox.XBoxSize*Zoom, mBox.YBoxSize*Zoom, /Sample)
   
Return, ZoomImage
END
