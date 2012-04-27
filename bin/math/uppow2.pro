FUNCTION  UpPow2, number
;
; This function rounds the input number up to the nearest power
; of 2
;

Base=2L

While Number GT Base DO Base = Base*2


RETURN, Base
END

