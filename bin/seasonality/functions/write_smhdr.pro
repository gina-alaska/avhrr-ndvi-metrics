PRO Write_SMHdr, OutFile, SMHDR

   OpenW, LUN, OutFile, /Get_LUN

   PrintF, LUN, SMHDR.File
   PrintF, LUN, SMHDR.Label
   PrintF, LUN, ''
   PrintF, LUN, SMHDR.NS, "		#Samples", FORMAT='(I10,a)'
   PrintF, LUN, SMHDR.NL, "		#Line", FORMAT='(I10,a)'
   PrintF, LUN, SMHDR.NB, "		#Band", FORMAT='(I10,a)'
   PrintF, LUN, SMHDR.DT, "		#Data Type", FORMAT='(I10,a)'
   PrintF, LUN, ''
   PrintF, LUN, SMHDR.ProjCode, "		#Projection Code", FORMAT='(I10,a)'
   PrintF, LUN, SMHDR.ZoneCode, "		#Zone Code", FORMAT='(I10,a)'
   PrintF, LUN, SMHDR.Ellipsoid, "		#Ellipsoid", FORMAT='(I10,a)'
   PrintF, LUN, ''
   PrintF, LUN, SMHDR.ProjCoef[0:4], FORMAT='(5e14.6, a)'
   PrintF, LUN, SMHDR.ProjCoef[5:9], FORMAT='(5e14.6, a)'
   PrintF, LUN, SMHDR.ProjCoef[10:14], "		#15 LAS Projection Coefficients", $
                FORMAT='(5e14.6, a)'
   PrintF, LUN, ''
   PrintF, LUN, SMHDR.UL, "		#UL in packed DMS", FORMAT='(2e16.8, a)'
   PrintF, LUN, SMHDR.LL, "		#LL in packed DMS", FORMAT='(2e16.8, a)'
   PrintF, LUN, SMHDR.UR, "		#UR in packed DMS", FORMAT='(2e16.8, a)'
   PrintF, LUN, SMHDR.LR, "		#LR in packed DMS", FORMAT='(2e16.8, a)'
   PrintF, LUN, ''
   PrintF, LUN, SMHDR.ProjDist, "		#Projection Distance", FORMAT='(2e16.8, a)'
   PrintF, LUN, SMHDR.ProjIncr, "		#Projection Increment", FORMAT='(2e16.8, a)'
   PrintF, LUN, ''
   PrintF, LUN, SMHDR.UnScale, "		#Slope Intercept from data to units", $
                                               FORMAT='(2e16.4, a)'
   PrintF, LUN, SMHDR.Min, "		#Data Minimum", FORMAT='(I10,a)'
   PrintF, LUN, SMHDR.Max, "		#Data Maximum", FORMAT='(I10,a)'
   PrintF, LUN, ''
   PrintF, LUN, SMHDR.BPY, "		#Bands Per Year", FORMAT='(I10,a)'
   PrintF, LUN, SMHDR.DPP, "		#Days Per Band", FORMAT='(I10,a)'
   PrintF, LUN, SMHDR.DATE, "		#Start Day, Month, Year", FORMAT='(3I6,a)'


   Free_LUN, LUN
END
