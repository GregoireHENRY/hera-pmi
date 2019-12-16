function r = cspice_spkposm(OBJ, et, FRAME, CORR, OBS)

r = cspice_spkpos(OBJ,et,FRAME,CORR,OBS);
r = r*1e3;