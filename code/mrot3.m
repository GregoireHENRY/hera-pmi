function m = mrot3(rotx, roty, rotz)
m = mrotz(rotz) * mroty(roty) * mrotx(rotx);