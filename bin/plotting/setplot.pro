pro setplot, title, flag, xsz, ysz

;
; title is the file name used for the plot file (flag = 1 or 2)
; flag = 0	plot to x term
; flag = 1	plot to postscript and print (file.ps)
; flag = 2	plot to encapsulated postscript file (file.eps)
; xsz is an array containing the arguments xsize and xoffset for "device"
; ysz is an array containing the arguments ysize and yoffset for "device"
;

if (flag ne 0) then begin
  set_plot,'ps'
  if (flag eq 1) then begin
    device,file=title+'.ps',$
	yoffset=ysz(1), ysize=ysz(0), xoffset=xsz(1), xsize=xsz(0)
  endif
  if (flag eq 2) then begin
    device,file=title+'.eps',/encapsulated,$
	yoffset=ysz(1), ysize=ysz(0), xoffset=xsz(1), xsize=xsz(0)
    !p.font = 0
  endif
endif

return
end
