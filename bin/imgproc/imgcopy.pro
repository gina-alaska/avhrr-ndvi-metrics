FUNCTION   imgcopy, c, xoff,yoff,xdim,ydim
;d=fltarr(xdim,ydim)
d= c(xoff:xoff+xdim-1,yoff:yoff+ydim-1)
return,d
end
