% crea_wienC

pL0sel=re_apply_null(pL0,'C:\Users\Sergio Frasca\Documents\MATLAB\velaC\gCsel_gd_null_20090605_151033.txt')
pL45sel=re_apply_null(pL45,'C:\Users\Sergio Frasca\Documents\MATLAB\velaC\gCsel_gd_null_20090605_151033.txt')
pCAsel=re_apply_null(pCA,'C:\Users\Sergio Frasca\Documents\MATLAB\velaC\gCsel_gd_null_20090605_151033.txt')
pCCsel=re_apply_null(pCC,'C:\Users\Sergio Frasca\Documents\MATLAB\velaC\gCsel_gd_null_20090605_151033.txt')

save('SimVelaSel','pL0sel','pL45sel','pCAsel','pCCsel')

pCAwien=pCAsel.*wienC
pCCwien=pCCsel.*wienC
pL0wien=pL0sel.*wienC
pL45wien=pL45sel.*wienC

save('SimVelaWien','pL0wien','pL45wien','pCAwien','pCCwien')