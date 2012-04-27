FUNCTION sunearthdist, jd

;
;  This function calculates the sun-earth distance in
;  AU for a given Julian date.  It was adapted from the
;  ADAPS code.
;

r0 = 1.0
e = 0.0167
m = jd/365.25 * !PI*2
nu = m + 2.0 * e * sin(m)

d = (r0 *(1-e^2))/(1.0 + e*cos(nu))

return, d
end
