FUNCTION Range, data

dmin=min(data, max=dmax)
return, [dmin, dmax]
end
