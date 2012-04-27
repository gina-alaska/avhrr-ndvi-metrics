FUNCTION  DateRange, FileNames, MinDate, MaxDate

nim = N_Elements(FileNames)
dates = fltarr(nim)



FOR i = 0, nim-1 DO dates(i) = file2jul(FileNames(i))

idx = where (dates(*) GE MinDate AND dates(*) LE MaxDate, nidx)


ValidFiles = FileNames(idx)


RETURN, ValidFiles

END
