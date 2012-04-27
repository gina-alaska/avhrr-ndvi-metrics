FUNCTION Deg2DMS, deg

d = double(long(deg))
m = double(abs(long(deg*60L-d*60L)))
s = double(abs((deg-(d+d/abs(d)*m/60D))))*3600D

Return, [d,m,s]
END
