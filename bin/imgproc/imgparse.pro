FUNCTION imgparse, data, xmin, ymin, xdim, ydim, NBANDS=nbands

;
;  This Function will extract a chip from all bands of
;  an NBand image.
;


ImgSize = Size(Data)
NSamps = ImgSize(1)
NLines = ImgSize(2)

IF( NOT KEYWORD_SET(NBANDS)) THEN $ 
   NBands = NLines/NSamps $
ELSE $
   NBands = nbands
  
NLines = NLines/NBands

Parse = Data(1:XDim, 1:YDim*NBands)*0


FOR i = 0, NBands-1 DO BEGIN

   Parse(0:XDim-1, i*XDim:i*XDim+YDim-1) = $
       Data(XMin:XMin+XDim-1,i*NLines+Ymin:i*NLines + YMin + YDim - 1) 
ENDFOR

return, parse

END
