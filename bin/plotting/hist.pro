FUNCTION hist, data, x, binsize = binsize, xmin=xmin, xmax=xmax, log=log


if(NOT KEYWORD_SET(BINSIZE)) THEN binsize = 1

if (keyword_set(xmin)) then $
  xmin = xmin  $
else $
  xmin = floor(min(data))

if (keyword_set(xmax)) then $
  xmax = xmax  $
else $
  xmax = ceil(max(data))

nx = (xmax-xmin)/binsize + 1

x = findgen(nx)*binsize + xmin

histo = histogram(data, min=xmin, max=xmax, binsize=binsize)


RETURN, histo
end
