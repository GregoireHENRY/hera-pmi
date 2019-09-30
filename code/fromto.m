function [v0, vf] = fromto(t0, tf)

load('monthmap');

v0=[t0(1:4) dict(t0(6:8)) t0(10:11)];
vf=[tf(1:4) dict(tf(6:8)) tf(10:11)];
