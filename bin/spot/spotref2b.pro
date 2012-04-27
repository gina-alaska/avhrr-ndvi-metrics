FUNCTION SpotRef2B, Reflectance
Scale=250

Return, Byte(Round_To(Reflectance*Scale, 1))
END
