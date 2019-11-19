clear; cspice_kclear;

% =========================================================================
% SOLAR ECLIPSES
% =========================================================================

do_display = 1;
do_print   = 0;
do_save    = 0;
p          = 11.92*3600;
day        = 86400;
color      = {'#0072BD','#D95319','#EDB120','#7E2F8E','#77AC30','#4DBEEE','#A2142F'};
timesetup  = {'2027-FEB-25' '2027-MAR-3' 30};
path       = '/home/greg/hera/kernels/';

% HERA      -999
% DIDYMAIN  -658030
% DIDYMOON  -658031
% ECP        2027-JAN-28 08:16:07.184 -->> 2027-FEB-25 08:16:07.185;
% DCP1       2027-FEB-25 08:16:07.185 -->> 2027-MAR-28 08:16:07.184;
% DCP3       2027-APR-25 08:16:07.184 -->> 2027-JUN-24 08:16:07.185;
% DCP3VCF    2027-JUN-03 16:09:52.184 -->> 2027-JUN-06 16:09:52.184;

cspice_furnsh([path 'mk/' 'hera_study.tm'])
et = setup_et('utc fill', timesetup);

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

S=containers.Map({0, -1, -3}, ...
                 {sprintf('End occultation at\t'), ...
                  sprintf('Begin partial occultation at\t'), ...
                  sprintf('Begin total occultation at\t')});

fprintf('Computing..\t'); tic;
shdw  = cspice_occult(OBJ2,SHAPE2,FRAME2,OBJ1,SHAPE2,FRAME1,CORR,SUN,et);
shdw(shdw > 0) = 0;
toc;

fprintf('\n');
for i = 2:length(shdw)
    if shdw(i) ~= shdw(i-1)
        fprintf('%s%s\n', S(shdw(i)), cspice_timout(et(i), 'YYYY-MON-DD HR:MN:SC'));
        if ~shdw(i), fprintf('\n'); end
    end
end

fprintf('Displaying..\t'); tic;
close all;
plot(shdw);
toc;
plot(shdw);