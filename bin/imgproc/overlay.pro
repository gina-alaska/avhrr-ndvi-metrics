PRO Overlay, Image, Mask, COLOR=Color, REMOVE=Remove

;
;  This procedure adds a 3-band colored overlay mask
;  to a 3-band image.  The overlay is in the view only,
;  i.e., the input image does not change.  Optionally,
;  the overlay can be removed with the REMOVE keyword.
;
;  The input Image is expected to be the same 3-band
;  image being view in the current window.
; 
;  The input Mask is a 1 Band binary image  with 1's 
;  where you want Color to show up, 0's elsewhere.
;
;  The COLOR keyword expects a 3-member array for
;  RGB components respectively
; 


ImgSize = Size(Image)

UberLay = bytarr(ImgSize(1), ImgSize(2), ImgSize(3), /nozero)
MaskNeg = bytarr(ImgSize(1), ImgSize(2), ImgSize(3), /nozero)

IF(NOT KEYWORD_SET(COLOR)) THEN Color = [255,255,255]
CASE (KEYWORD_SET(REMOVE)) OF
   0: BEGIN 
         UberLay(*,*,0) = Mask*Color(0)
         UberLay(*,*,1) = Mask*Color(1)
         UberLay(*,*,2) = Mask*Color(2)
      END
   1: BEGIN
         UberLay(*,*,0) = Mask*Image(*,*,0)
         UberLay(*,*,1) = Mask*Image(*,*,1)
         UberLay(*,*,2) = Mask*Image(*,*,2)
      END

   ELSE:
ENDCASE

CurImg=TVRD( TRUE=3)
 
MaskNeg(*,*,0) = (Mask - 1)^2
MaskNeg(*,*,1) = (Mask - 1)^2
MaskNeg(*,*,2) = (Mask - 1)^2


TV, CurImg*MaskNeg + UberLay, TRUE=3

END
