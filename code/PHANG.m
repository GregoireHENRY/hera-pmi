clear; cspice_kclear;

% =========================================================================
% DIDYMOON phase angle
% =========================================================================
% 

do_compute = 1;
do_display = 1;
do_print   = 1;
do_save    = 1;
p          = 6*3600;
day        = 86400;
timesetup  = {'2027-FEB-28 08:15:00' '2027-MAR-04 08:15:00' 60};
path       = '/home/greg/hera/kernels/';

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

% COMPUTE
fprintf('Computing..\t\t'); tic;
if (do_compute)
[utc0,utcf]=fromto(timesetup{1},timesetup{2});
nt=numel(et);
dt=et(2)-et(1);
t=(et-et(1))/3600;
r=cspice_spkpos(OBJ2,et,J2000,CORR,OBJ1); r=r*1e3;
rh=cspice_spkpos(OBJ2,et,J2000,CORR,SAT); rh=rh*1e3;
r0=repmat(r(:,1),1,nt);
phang=angvec2(r,r0,1);
d=sqrt(sum(r.^2))*1e-3;
dh=sqrt(sum(rh.^2))*1e-3;
end; toc;

% DISPLAY
fprintf('Displaying..\t'); tic;
if (do_display)
close all;
subplot 211;
hold on; grid on; box on;
xlim([0 t(end)]); ylim([-0 360]); xticks(0:6:t(end)); yticks(-180:45:360);
xlabel('Time [hour]'); ylabel('Phase angle [deg]');
plot(t, phang,'color','k');
subplot 212;
hold on; grid on; box on;
xlim([0 t(end)]); xticks(0:6:t(end));
xlabel('Time [hour]'); ylabel('Distance [km]');
plot(t, dh,'color','k');
bigtitle(sprintf('DIDYMOON orbital phase angle & distance from %s to %s',utc0,utcf),12);
movegui([1920 550]);
end; toc;

% PRINT
fprintf('Printing..\t\t'); tic;
if (do_print)
imgname = sprintf('images/didymoon_phase_angle_on%s.png',utc0);
print(gcf, imgname, '-dpng','-r600');
end; toc;

% SAVE
fprintf('Saving..\t\t'); tic;
save('et','et');
if (do_save)
varsave = { ...
};
for ii=1:numel(varsave)
    save(varsave{ii}{1}, varsave{ii}{2});
end
end; toc;

fprintf('\n'); cspice_kclear;