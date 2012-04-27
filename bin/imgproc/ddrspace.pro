FUNCTION ddrspace, nb

;
;  This function generates a null DDR
;

ddr = {LASDDR}

ddr.nb=nb
bddr=bytarr(199, nb)

ddr=create_struct(ddr, 'bddr', bddr)

return, ddr
END
