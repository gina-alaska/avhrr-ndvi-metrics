FUNCTION  assocmulti, file, x,y,ns, nl,nb, dt=dt

t0 = systime(1)
OpenR, LUN, file, /Get_LUN
CASE(DT)OF
  1: BEGIN
     a = assoc(LUN, bytarr(ns, nl))
tmp=bytarr(nb)
  END;1

  2: BEGIN
     a = assoc(LUN, intarr(ns, nl))
  END;2
  ELSE:
ENDCASE
for i = 0, nb-1 DO BEGIN
   b = a[i]
   tmp[i] = b[x,y]
end
Free_LUN, LUN

print, "TIME(ASSOCMULTI):", systime(1)-t0

return, tmp
END
