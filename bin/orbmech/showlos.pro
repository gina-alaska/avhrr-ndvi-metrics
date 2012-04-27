;PRO ShowLOS, LookAngle, Alt

LookAngle=50
alt=832

re=6378
theta=findgen(361)
earthx = re*cos(d2r(theta))   
earthy= re*sin(d2r(theta)) 
plot, earthx, earthy, YRange=[0, 10000]
oplot, [0,0], [0, re+Alt], psym=-4
oplot, [-10000, 10000], [Re, Re]

slope=tan(d2r(90-LookAngle))
LOS=slope*earthx + Re+Alt
oplot, earthx, LOS

END

