FUNCTION   selectchip, windownum, DEVICE=device, DATA=data

box = intarr(4)

wset, windownum

print, "Select first point"
cursor, x0, y0, /wait, /device
wait, 1
print, "Select second point"
cursor, x1, y1, /wait, /device

box(0) = min([x0, x1])
box(1) = max([x0, x1])
box(2) = min([y0, y1])
box(3) = max([y0, y1])

return, box
end
