FUNCTION PickImgMask, WinNum

;
;  This function returns a binary mask of a polygon selected
;  from an image in window WINNUM
;
wset, WinNum

pickpolygon, x, y, /dev

n = n_elements(x)-1

p = polyfillv(x(0:n-1), y(0:n-1), !D.X_Size, !D.Y_Size)

tmpimg = bytarr(!D.X_Size, !D.Y_Size, /nozero)
pmask = mask(tmpimg, p, /show)

return, pmask
end
