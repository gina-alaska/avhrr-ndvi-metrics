PRO Draw_Box, mNewBox, mOldBox, COLOR=color, ERASE=erase, NEW=new, $
    DEVICE=Device, DATA=DATA


CASE (KEYWORD_SET(DATA)) OF
  0: DATA=0
  1: DATA=1
  ELSE:
ENDCASE; DEVICE

CASE (KEYWORD_SET(DEVICE)) OF
  0: DEVICE=0
  1: DEVICE=1
  ELSE:
ENDCASE; DEVICE

IF (N_Elements(COLOR) GT 0) THEN $
   COLOR=color $
ELSE COLOR=rgb(255,255,0)

IF (KEYWORD_SET(ERASE)) THEN BEGIN
   device, get_graphics=oldg, set_graphics=6
   plots, mOldBox.XBox, mOldBox.YBox, DEVICE=device, $
          DATA=Data, color=color, thick=2
   device, set_graphics=oldg
END ELSE IF $
 (NOT Compare(mOldBox.XBox , mNewBox.XBox) OR $
   NOT Compare(mOldBox.YBox , mNewBox.YBox)) THEN BEGIN
   device, get_graphics=oldg, set_graphics=6
   plots, mOldBox.XBox, mOldBox.YBox, DEVICE=device, $
          DATA=Data, color=color, thick=2
IF(NOT KEYWORD_SET(NEW)) THEN $
   plots, mNewBox.XBox, mNewBox.YBox, DEVICE=device, $
          DATA=Data, color=color, thick=2
   device, set_graphics=oldg
end;box comparison


END
