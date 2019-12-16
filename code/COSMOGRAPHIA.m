clear; cspice_kclear;

% =========================================================================
% SPICE FOV camera single time/single point
% =========================================================================
% 

do_compute = 1;
do_display = 1;
do_print   = 0;
do_save    = 0;
p          = 11.92*3600;
day        = 86400;
timesetup  = {'2027-JUN-05 04:30'}; %JUN-05 02:30/35/40 03:
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
INSTR     = 'HERA_TIRA';
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
% [utc0,utcf] = fromto(timesetup{1}, timesetup{2});
t     = (et-et(1))/day;
r2    = cspice_spkpos(SAT,et,FRAME2,CORR,OBJ2);  r2 = r2*1e3;
rd    = cspice_spkpos(OBJ1,et,FRAME2,CORR,OBJ2); rd = rd*1e3;
r1    = cspice_spkpos(SAT,et,FRAME1,CORR,OBJ1);  r1 = r1*1e3;
ang   = cspice_angvec2(SUN,SAT,et,FRAME2,CORR,OBJ2);
phang = cspice_angvec2(SUN,OBJ2,et,FRAME1,CORR,OBJ1);
fov   = cspice_fovtrg(INSTR,OBJ2,SHAPE1,FRAME2,CORR,SAT,et);
shdw  = cspice_occult(OBJ2,SHAPE1,FRAME2,OBJ1,SHAPE2,FRAME1,CORR,SAT,et);
d1    = sqrt(sum(r1.^2));
d2    = sqrt(sum(r2.^2));

R    = 80; lo=0; la=-90; [x,y,z]=sph2cart(lo,la,R); pt=[x;y;z]; pt=[0;0;0];
ray  = pt-r2;
vw = cspice_fovray(INSTR,ray,FRAME2,CORR,SAT,et);

instr_id    = cspice_bodn2c(INSTR);
[~,instr_frame, bsightd, bounds] = cspice_getfov(instr_id,4);
instr_fov   = angvec2(bounds(:,1),bsightd);
instr_fov_x = angvec2((bounds(:,1)+bounds(:,2))*0.5,bsightd);
instr_fov_y = angvec2((bounds(:,1)+bounds(:,4))*0.5,bsightd);
mform       = cspice_pxform(FRAMESAT,FRAME2,et);
bsight      = mform*bsightd*d1;
bounds1     = mform*bounds*d1;
angray      = angvec2(ray,bsight);
d2proj      = d2*cosd(angray);
bounds2     = mform*bounds*d2proj;
d2color='cyan'; if(~fov||shdw==-3),d2color='r';end
end; toc;

% DISPLAY
fprintf('Displaying..\t'); tic;
if (do_display)
close all;
hold on; axis equal; box on;
xlabel('x'); ylabel('y'); zlabel('z');
scatter3(0,0,0,50,'markerfacecolor',d2color,'markeredgecolor','k');
scatter3(rd(1),rd(2),rd(3),100,'markerfacecolor','b','markeredgecolor','k');
scatter3(r2(1),r2(2),r2(3),25,'markerfacecolor','k','markeredgecolor','k');
plot3([0 ray(1)]+r2(1),[0 ray(2)]+r2(2),[0 ray(3)]+r2(3),'color',d2color);
plot3([0 bsight(1)]+r2(1),[0 bsight(2)]+r2(2),[0 bsight(3)]+r2(3),'color','b');
create_fovbox(bounds1,r2,[0.0 0.8 0.0]);
create_fovbox(bounds2,r2,[0.0 0.8 0.0]);
%fig=gcf; fig.Position=[1925 -68 1050 1054];
view([-75 5]);
%movegui([2000, 400]);
end; toc;

% PRINT
fprintf('Printing..\t\t'); tic;
if (do_print)
imgname = sprintf('images/didymoon_data_from%sto%s.png',utc0,utcf);
print(gcf, imgname, '-dpng','-r600');
end; toc;

% SAVE
fprintf('Saving..\t\t'); tic;
save('et','et');
if (do_save)
varsave = { ...
    {'r'   'r2'}  ...
    {'d'   'd'}   ...
    {'ang' 'ang'} ...
    {'fov' 'fov'} ...
};
for ii=1:numel(varsave)
    save(varsave{ii}{1}, varsave{ii}{2});
end
end; toc;

fprintf( [ ...
    '\n' ...
    'Distance to Didymain:         %10.2f[km]\n' ...
    'Camera FOV:                   %10.2f[deg]\n'    ...
    'Raycast angle:                %10.2f[deg]\n'   ...
    'Didymoon phase angle:         %10.2f[deg]\n'  ...
    'Didymoon in fov:              %10d\n'              ...
    'Didymoon surface point in fov:%10d\n'      ...
         ],d2*1e-3,instr_fov,angray,phang,fov,vw);
fprintf('\n'); cspice_kclear;