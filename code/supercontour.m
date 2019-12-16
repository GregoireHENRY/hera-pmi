function [XX, YY, ZZ] = supercontour(X, Y, Z)

[XX,YY] = meshgrid(min(X):max(X),min(Y):max(Y));
ZZ = griddata(X,Y,Z,XX,YY);