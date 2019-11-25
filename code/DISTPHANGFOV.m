clear; cspice_kclear;

% =========================================================================
% SPICE distance/phase angle/fov
% =========================================================================
% 

do_compute = 1;
do_display = 1;
do_print   = 0;
do_save    = 0;
p          = 11.92*3600;
day        = 86400;
timesetup  = {'2027-APR-25 08:18' '2027-JUN-24 08:15' 60};
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
fprintf('Computing..\t'); tic;
if (do_compute)
[utc0,utcf] = fromto(timesetup{1}, timesetup{2});
t     = (et-et(1))/day;
r1    = cspice_spkpos(OBJ1, et, FRAMESAT, CORR, SAT);
r2    = cspice_spkpos(OBJ2, et, FRAMESAT, CORR, SAT);
ang1  = cspice_angvec2(SUN, SAT, et, FRAME1, CORR, OBJ1);
ang2  = cspice_angvec2(SUN, SAT, et, FRAME2, CORR, OBJ2);
fov1  = cspice_fovtrg(INSTR, OBJ1, SHAPE2, FRAME1, CORR, SAT, et);
fov2  = cspice_fovtrg(INSTR, OBJ2, SHAPE2, FRAME2, CORR, SAT, et);
shdw2 = cspice_occult(OBJ2,SHAPE1,FRAME2,OBJ1,SHAPE2,FRAME1,CORR,SAT,et);
d1=sqrt(sum(r1.^2)); d2=sqrt(sum(r2.^2));
r1=r1*1e3; r2=r2*1e3;
end; toc;

% DISPLAY
fprintf('Displaying..\t'); tic;
if (do_display)
close all;
subplot 211;
hold on; grid on; box on;
xlim([0 t(end)]); ylim([0 40]); xticks(0:1:60); yticks(0:5:180);
xlabel('Time [day]'); ylabel('Distance [km]');
bar(t,fov2*40,'facecolor',[0.6 1.0 0.6],'barwidth',1,'displayname','DIDYMOON in FOV');
plot(t,d2,'-', 'displayname','DIDYMOON','color','k');
plot(t,d1,'--','displayname','DIDYMAIN','color','k');
legend('Location','bestoutside'); set(gca,'layer','top')
subplot 212;
hold on; grid on; box on;
xlim([0 t(end)]); ylim([0 180]); xticks(0:1:60); yticks(0:20:180);
xlabel('Time [day]'); ylabel('Phase angle [deg]');
bar(t,fov2*180,'facecolor',[0.6 1.0 0.6],'barwidth',1,'displayname','DIDYMOON in FOV');
plot(t,ang2,'-', 'displayname','DIDYMOON','color','k');
plot(t,ang1,'--','displayname','DIDYMAIN','color','k');
legend('Location','bestoutside'); set(gca,'layer','top')
bigtitle(sprintf('DIDYMOS wrt HERA from %s to %s',utc0,utcf),12);
movegui([2000, 400]);
end; toc;

% PRINT
fprintf('Printing..\t'); tic;
if (do_print)
imgname = sprintf('images/didymoon_data_from%sto%s.png',utc0,utcf);
print(gcf, imgname, '-dpng','-r600');
end; toc;

% SAVE
fprintf('Saving..\t'); tic;
save('et','et');
if (do_save)
r=r2; d=d2; ang=ang2; fov=fov2;
varsave = { ...
    {'r'   'r'} ...
    {'d'   'd'} ...
    {'ang' 'ang'} ...
    {'fov' 'fov'} ...
};
for ii=1:numel(varsave)
    save(varsave{ii}{1}, varsave{ii}{2});
end
end; toc;

fprintf('\n'); cspice_kclear;