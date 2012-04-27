FUNCTION   emiss,T4, T5

c2 = 1.4387863e-2
l4 = 10.8e-6
l5 = 11.8e-6

return, c2*(T4 - T5)/(T4*T5*(l4-l5))

end
