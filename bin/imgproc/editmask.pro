FUNCTION EditMask, Mask, WinNum

wset, WinNum

on_error, 2

!err = 0

newmask = mask

while !err ne 4 do BEGIN

  tmpmask = PickImgMask(WinNum)

  newmask = newmask*imgneg(tmpmask)

  !err = 1

  Print, "Press left or middle button to continue..."
  Print, "Press right button to exit..." 
  Print, ""
  cursor, x, y, /wait
  wait, 1
endwhile

return, NewMask
END
