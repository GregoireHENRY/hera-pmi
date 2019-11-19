clear; cspice_kclear;

% =========================================================================
% SPICE distance/phase angle/fov
% =========================================================================
% 

do_compute = 1;
do_display = 1;
p          = 11.92*3600;
day        = 86400;
au         = 1.495978707e8;
timesetup  = {'2027-JUN-24'};
path       = '../kernels/';

%
% HERA:      -999
% DIDYMAIN:  -658030
% DIDYMOON:  -658031
%
% ECP:        2027-JAN-28 08:16:07.184 -->> 2027-FEB-25 08:16:07.185;
% DCP1:       2027-FEB-25 08:16:07.185 -->> 2027-MAR-28 08:16:07.184;
% DCP3:       2027-APR-25 08:16:07.184 -->> 2027-JUN-24 08:16:07.185;
% DCP3VCF:    2027-JUN-03 16:09:52.184 -->> 2027-JUN-06 16:09:52.184;
%

toload = { ...
    'color' ...
};
for ii = 1:length(toload)
    load(toload{ii});
end

cspice_furnsh([path 'mk/' 'hera_study.tm'])
et = setup_et('utc single', timesetup);

SUN       = 'SUN';
INSTR     = 'HERA_AFC-1';
SAT       = 'HERA';
OBJ1      = 'DIDYMAIN';
OBJ2      = 'DIDYMOON';
J2000     = 'J2000';
FRAMESAT  = 'HERA_DIDYMAIN_NPO';
FRAME1    = 'DIDYMAIN_FIXED';
FRAME2    = 'DIDYMOON_FIXED';
SHAPE1    = 'POINT';
SHAPE2    = 'ELLIPSOID';
METHOD    = 'NEAR POINT/ELLIPSOID';
CORR      = 'NONE';

% COMPUTE
fprintf('Computing..  '); tic;
if (do_compute)
r = cspice_spkpos(OBJ1, et, J2000, CORR, SUN);
d = sqrt(sum(r.^2));
end; toc;

% DISPLAY
fprintf('Displaying.. '); tic;
if (do_display)
close all;
end; toc;

fprintf('\ndistance: %10.4f AU\n', d/au);

fprintf('\n'); cspice_kclear;