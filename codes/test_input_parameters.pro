;this program produce one year ndvi data. It accepts one year ndvi files, get only good pixel which indicated in each related quality file, then
;layer these gooded data together into a yearly-good data. When user input ul and lr, it also do subsize of the data. But normally we need do
;whole alaska region data( with ul=0 and lr=0)
;accepts two inputs:year,work_home_dir 

pro test_input_parameters,year,flist1,flist2

print,'year: '+year
print,'flist1: '+flist1
print,'flist2: '+flist2

end



