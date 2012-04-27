FUNCTION Update_DDR_Size, ddr, nbOld

BDDR=bytarr(199, ddr.nb)

New_DDR={lasddr}

New_DDR=Create_Struct(New_DDR, 'bddr', bddr)


Return, New_DDR
END
