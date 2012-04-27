FUNCTION Compare, A, B

;
; Returns TRUE=1 if vectors A and B are identical
; Returns FALSE=0 if vectors A and B are different
;

if(n_elements(a) ne n_elements(b)) then begin
  ISTRUE = 0
end else begin
  ISTRUE = total((a-b) eq a*0) eq n_elements(a)
end

return, ISTRUE 
end
