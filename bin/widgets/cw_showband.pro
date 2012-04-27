FUNCTION CW_ShowBand, mParent, mImage, iBand

title = mImage.aBandNames(iBand)

wBase = Widget_Base(Title=title,  Group_Leader=mParent.wBase)

wDraw = Widget_Draw(wBase, XSize=mImage.lSamp, $
                           YSize=mImage.lLine)

return, wBase
END
