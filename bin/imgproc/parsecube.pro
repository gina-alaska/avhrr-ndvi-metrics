PRO parsecube, InCube, StartYear, BandsPerYear, FilenameRoot

;
;  This procedure parses in input data cube into individual
;  band files.  It outputs files with a naming convention:
;     
;      <FilenameRoot><Year>sm<Band>.img
;
;  Example: StartYear=80
;           BandsPerYear=36
;           FilenameRoot='sahel10d'
;
;  The 9th band of 1985 will be in the file:
;
;      sahel10d85sm09.img
;
;  For the above example, call using:
;
;      parsecube, data, 80, 36, 'sahel10d' 
;
;  where data is a cube that has already been read into
;  memory.  NOTE: We may run into problems even reading
;  in big files.  At some point I'll change this so it
;  uses associated memory which will completely eliminate
;  that problem.
;

;
; InCube
;
iSize=Size(InCube)
ns=iSize[1]
nl=iSize[2]
nb=iSize[3]
ny=nb/BandsPerYear

For iy=0, ny-1 DO BEGIN
   aYear=StrCompress(StartYear+iy, /Remove_All)

   For ib=1, BandsPerYear DO BEGIN
      if ib lt 10 then $
         aBand='0'+strcompress(ib, /Remove_All) $
      ELSE $
         aBand=strcompress(ib, /Remove_All) 

      filename=FileNameRoot+aYear+'sm'+aBand+'.img'
      print, "WRITING: ",filename, iy*BandsPerYear+ib-1
      ImgWrite, InCube[*,*,iy*BandsPerYear+(ib-1)], FileName
   END
END
END
