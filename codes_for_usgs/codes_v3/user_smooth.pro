;this program do smooth for a vector
pro user_smooth, v, vout
;input:v--vector, output:vout--returned vector
;

if min(v) EQ max(v) then begin  ; do not do smooth

vout=v

endif else begin

savgolfilter = savgol(8,8,0,4) ; define savgolfilter coefficients, 16 defore, 16 after, smoothing=0, degree=4,less smoothing
;----- smooth, use good method, such as weighted least-squares -----
vout = fix( convol(float(v),savgolfilter,/EDGE_TRUNCATE) )

endelse

return

end


