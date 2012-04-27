PRO Get_Box, x, y, mBox, half

;
; This procedure calculates box parameters
;

; Get Center of reduced box and calculate box
       mBox.XCenter = ((x > (mBox.ImgOffset[0]+half)) < $
                       (mBox.ImgSize[0]+mBox.ImgOffset[0]-half))
       mBox.YCenter = ((y > (mBox.ImgOffset[1]+half)) < $
                       (mBox.ImgSize[1]+mBox.ImgOffset[1]-half))

       XCent = mBox.XCenter
       YCent = mBox.YCenter

       mBox.XBox = round([XCent - half, XCent + half, $
                 XCent + half, XCent - half, XCent - half])
       mBox.YBox = round([YCent - half, YCent - half, $
                 YCent + half, YCent + half, YCent - half])


END
