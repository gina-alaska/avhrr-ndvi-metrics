FUNCTION   timeshift, lookangle

PI=pi(1)
Re = 6378.0   ; Earth radius in km
Alt = 605.0   ; Orbit altitude in km
Rs = Re + Alt


pmzenith = PI - asin(Rs/Re * sin(d2r(lookangle)))
zenith = pi - pmzenith

earthangle = PI - (d2r(lookangle) + pmzenith)

print, d2r(lookangle), earthangle, pmzenith, zenith
dt = earthangle*12.0/PI

return, dt
end



FUNCTION   timeshift2, zenith

PI = pi(1)
Re = 6378.0   ; Earth radius in km
Alt = 605.0   ; Orbit altitude in km
Rs = Re + Alt

pmzenith = PI - d2r(zenith)
lookangle = asin(Re/Rs * sin(pmzenith))
earthangle = PI - (pmzenith +lookangle)

print, lookangle, earthangle, pmzenith, d2r(zenith)
dt = earthangle*12.0/PI

return, dt
end
