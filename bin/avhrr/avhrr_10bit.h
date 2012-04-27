;
;  Scaling constants for AVHRR_10BIT data
;
;  Scaling equations are
;
;     scaled = actual*scale + offset
;     actual = (scaled - offset)/scale
;

SatZscl = 1.0   
SatZoff = 100.0

SolZscl = 1.0  
SolZoff = 10.0 

RelAzscl = 1.0
RelAzoff = 190.0 

Refscl = 1000.0 ; puts into 0.XX (might need to check this with rad2ref
Refoff = 1000.0

Radscl = 1.874
Radoff = 10.0

Tscl = 5.602    
Toff = -886.320  

Nscl = 100.0 
Noff = 110.0 

