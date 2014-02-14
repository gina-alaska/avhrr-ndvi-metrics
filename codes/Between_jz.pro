;this program compare three values (x, a, b), if the first (x) is in the middle between [a,b], then return 1, otherwise , return 0

Function Between_jz,xstar,x0,x1

; x0 is smaller than x1

flg=0 ; return value

if xstar GE x0 and xstar LE x1 then begin

flg=1 

endif

return, flg

end
