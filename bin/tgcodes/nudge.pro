FUNCTION  nudge, data, xoff, yoff

tmp = data* 0

ns = n_elements(data(*,0))
nl = n_elements(data(0,*))

ssmin = max([0, -xoff])
ssmax = min([ns-1, ns-1-xoff])
slmin = max([0, -yoff])
slmax = min([nl-1, nl-1-xoff])

rsmin = max([0, xoff])
rsmax = min([ns-1, ns-1+xoff])
rlmin = max([0, yoff])
rlmax = min([nl-1, nl-1+xoff])

tmp(ssmin:ssmax, slmin:slmax) = data(rsmin:rsmax, rlmin:rlmax)

return, tmp
end
