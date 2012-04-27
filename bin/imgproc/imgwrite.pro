;=== IMGWRITE ============================================
;  This procedure writes 'data' to binary file, 'filename'
;=========================================================
PRO   imgwrite, data, filename

openw, LUN, filename, /GET_LUN

writeu, LUN, data

FREE_LUN, LUN

end
