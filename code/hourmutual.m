clear;

do_preload = 0;

% CONSTANTS & NAMES
day        = 86400;
au         = 1.495978707e11;
S0         = 1361.5;
SfBoltz    = 5.670374419e-8;

% SETTINGS
p     = 11.92*60*60;
gamma = 500;
rho   = 2146;
cp    = 600;
A     = 0.07; 
emi   = 0.9;
C     = 0.25;
dt    = 50;
t0    = 0;
tf    = 10*day;
tfr   = 4*3600 + 17*60;
tf    = tf+tfr;

% COMPUTE POSITION
r = [1.6749;0;0]*au; 
dau = my_norm(r)/au;

% ASTEROID GROUND PROPERTIES COMPUTED
k     = gamma^2/(rho*cp);
alpha = k/(rho*cp);
ls    = sqrt(alpha*pi*p);
V     = C*(rho*cp/gamma)^2;
c1    = S0*A;
c2    = S0*(1-A);
c3    = emi*SfBoltz;
nls   =1;
% ASTEROID SHAPE MODEL: spherical assumption
objpath='didy.obj';
%objpath = '../kernels/dsk/hera_didymoon_k001_v01.obj';
obj = read_obj(objpath);
tris = set_tris(obj);
m = tris.m'; %*1e3;
n = tris.n';
sph = tris.sph;

% HOUR ANGLE MERDIAN lo=0°
thrsh = 0.03;
condlo = sph(:,1)<thrsh & sph(:,1)>0;
sph = sph(condlo,:);
m = m(:,condlo);
n = n(:,condlo);
np = length(n);

radi = 80;
dsph = 20;
pos  = zeros(3, 324);
cpt  = 1;
for ii = 1:m
    for jj = 1:n
        [posx,posy,posz] = sph2cart(m(ii), n(jj), radi);
        pos(:,cpt) = [posx;posy;posz];
        cpt = cpt + 1;
    end
end
n = pos./radi;
M_center = [1000;0;0];
M_pos = M_center+pos;
M_n = n;
M_dau = my_norm(M_center-r)/au;

% Vij
np = 1;
posi = 9; %9 171
pos = pos(:,posi);
n = n(:,posi);
dir_Mm = unit(pos-M_pos);
d_Mm = my_norm(pos-M_pos);
theta = angvec2(n,-dir_Mm);
M_theta = angvec2(M_n,dir_Mm);


% OBLIQUITY MODEL
obl   = 162;
rotv0 = [0; 1; 0];
rotv  = [sind(obl); 0; cosd(obl)];
mrot  = mrotv3(rotv, dt*2*pi/p);
m     = mrotv3(rotv0, obl*pi/180)*m;
n     = mrotv3(rotv0, obl*pi/180)*n;


% NUMERICAL MODEL DISCRETIZATION
et   = t0:dt:tf;
dx_  = sqrt(dt/V);
ntp  = ceil(p/dt);
xmax = ls*nls; 
nx   = ceil((xmax-0)/dx_);
vx   = linspace(0,xmax,nx);
dx   = vx(2)-vx(1);
kk   = 2:nx-1;
kkm1 = kk-1;  
kkp1 = kk+1;
S    = alpha*dt/dx^2;
c4   = k/(2*dx);

u_now = zeros(nx,np);
if (do_preload), load('u_now'); end

args = struct( ...
    'u_now',    u_now, ...
    'M_pos',    M_pos, ...
    'd_Mm',     d_Mm, ...
    'theta',    theta, ...
    'M_theta',  M_theta, ...
    'pos',      pos,   ...
    'r',        r,     ...
    'dau',      dau, ...
    'M_dau',    M_dau,   ...
    'et',       et,    ...
    'ntp',      ntp,   ...
    'vx',       vx,    ...
    'mrot',     mrot,  ...
    'n',        n, ...
    'M_n',      M_n,     ...
    'c1',       c1,    ...
    'c2',       c2, ...
    'c3',       c3,    ...
    'c4',       c4,    ...
    'S',        S,     ...
    'kk',       kk,    ...
    'kkm1',     kkm1,  ...
    'kkp1',     kkp1  ...
);

% TEMPERATURE SUBROUTINE
fprintf('Computing.. '); tic;
u = TEMP3(args); toc;

% DISPLAY
t = (et-et(1))/day;
la = sph(:,2)*180/pi;
hr = linspace(0,359,ntp);
[XX, YY, ZZ] = supercontour(hr, la, u);
close all;
hold on; grid on; axis equal;
xlim([min(hr) max(hr)]);
ylim([min(la) max(la)]);
yticks(-80:20:80);
level = 0:10:400;
xlabel('Hour angle [deg]'); ylabel('Latitude [deg]');
[C,h] = contourf(XX,YY,ZZ,level,'showtext','on','linestyle','-');
colormap jet; caxis([0 400]);
clabel(C,h,'FontSize',8,'FontSmoothing','on');
title(sprintf('%.4f AU - %s=%d', dau, '\Gamma', gamma));

imgname    = sprintf('images/pelivan_d%.1f_g%.0f.png', dau, gamma);
% print(gcf,imgname,'-dpng','-r600');