clear; cspice_kclear;

% =========================================================================
% SPICE FOV camera surface covered
% =========================================================================
% 

%JUN-05 02:30/35/40 03:00
%FEB-05 03:00
do_compute = 1;
do_display = 1;
do_print   = 0;
do_save    = 0;
p          = 11.92*3600;
day        = 86400;
nt         = 3;
timedur    = 0.833;
timeinit   = {'2027-JUN-05 02:40:00'};
path       = 'D:/Projects/rob/hera/kernels/';

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
et = setup_et('utc single', timeinit);

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
timestr = timeinit{1}(1:11);
timeint = 0:(timedur/(nt+1)):timedur;
et = et + timeint(2:end-1)*3600;
t = et-et(1);
r2   = cspice_spkpos(SAT,et,FRAME2,CORR,OBJ2);  r2   = r2*1e3;
rd   = cspice_spkpos(OBJ1,et,FRAME2,CORR,OBJ2); rd   = rd*1e3;
r1   = cspice_spkpos(SAT,et,FRAME1,CORR,OBJ1);  r1   = r1*1e3;
ang  = cspice_angvec2(SUN,SAT,et,FRAME2,CORR,OBJ2);
fov  = cspice_fovtrg(INSTR,OBJ2,SHAPE1,FRAME2,CORR,SAT,et);
shdw = cspice_occult(OBJ2,SHAPE1,FRAME2,OBJ1,SHAPE2,FRAME1,CORR,SAT,et);
d1   = sqrt(sum(r1.^2));
d2   = sqrt(sum(r2.^2));

R    = 80;
dnlo = 5;
nlo  = ceil((359-0)/dnlo);
lo   = linspace(0,359,nlo)*pi/180;
la   = linspace(-90,90,nlo)*pi/180;
np   = nlo^2;
vw   = zeros(1,np);
for ii = 1:nt
    for jj = 1:nlo
        for kk = 1:nlo
            hh=nlo*(jj-1)+kk;
            [x,y,z]=sph2cart(lo(jj),la(kk),R);
            pt=[x;y;z];
            ptn=pt./R;
            ray=pt-r2(:,ii);
            rayd=sqrt(sum(ray.^2));
            rayn=ray./rayd;
            costh=sum(-rayn.*ptn);
            if (costh>0  && shdw(ii)>=0)
                vw(hh)=vw(hh)+cspice_fovray(INSTR,ray,FRAME2,CORR,SAT,et(ii));
            end
        end
    end
end

lo=lo*180/pi;
la=la*180/pi;
Lo=repmat(lo,nlo,1);
La=repmat(la',1,nlo);
maxvw=max(vw);
vw=reshape(vw,nlo,nlo);
end; toc;

% DISPLAY
fprintf('Displaying..\t'); tic;
if (do_display)
close all;
hold on; grid on; axis equal; box on;
xlim([0 359]);
ylim([-90 90]);
level = 0:1:maxvw;
xlabel('Longitude [deg]'); ylabel('Latitude [deg]');
contourf(Lo,La,vw,level,'showtext','on','linestyle','none');
colormap gray; colorbar; caxis([0 maxvw]);
title(sprintf('DIDYMOON visible area wrt HERA on %s',timestr));
movegui([1920 550]);
end; toc;

% PRINT
fprintf('Printing..\t\t'); tic;
if (do_print)
imgname = sprintf('images/didymoon_visible_area_on%s_00%d.png',timestr,nt);
print(gcf, imgname, '-dpng','-r600');
end; toc;

% SAVE
fprintf('Saving..\t\t'); tic;
save('et','et');
if (do_save)
varsave = { ...
    {'vw' 'vw'}  ...
};
for ii=1:numel(varsave)
    save(varsave{ii}{1}, varsave{ii}{2});
end
end; toc;

fprintf('\n'); cspice_kclear;