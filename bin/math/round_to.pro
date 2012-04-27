FUNCTION  Round_To, Number, to

;
; This function rounds NUMBER to the nearest integer multiple
; if TO
;

return, round(number/float(to))*to
end
