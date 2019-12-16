clear;

% SPICE IDS
SUN      = 'SUN';
INSTR    = 'HERA_AFC-1';
SAT      = 'HERA';
OBJ1     = 'DIDYMAIN';
OBJ2     = 'DIDYMOON';
J2000    = 'J2000';
FRAMESAT = 'HERA_DIDYMAIN_NPO';
FRAME1   = 'DIDYMAIN_FIXED';
FRAME2   = 'DIDYMOON_FIXED';
SHAPE1   = 'POINT';
SHAPE2   = 'ELLIPSOID';
METHOD   = 'NEAR POINT/ELLIPSOID';
CORR     = 'NONE';

% CONSTANTS & NAMES
day        = 86400;
au         = 1.495978707e8;
S0         = 1361.5;
SfBoltz    = 5.670374419e-8;
timesetup  = {'2027-JUN-05 05:00' 10*day 30};
path       = '/home/greg/hera/kernels/';
imgname    = 'images/obliquity5.png';

% SETTINGS
p     = 11.92*3600;
gamma = 500;
rho   = 2147;
cp    = 600;
A     = 0.07;
emi   = 0.9;
C     = 0.25;

% SPICE USAGE
cspice_kclear;
cspice_furnsh([path 'mk/' 'hera_study.tm'])
et  = setup_et('utc dur fill',timesetup);
r   = cspice_spkpos(SUN,et,FRAME2,CORR,OBJ2);
dau = sqrt(sum(r.^2))/au;
cspice_kclear;

% ASTEROID GROUND PROPERTIES COMPUTED
k     = gamma^2/(rho*cp);
alpha = k/(rho*cp);
ls    = sqrt(alpha*pi*p);
V     = C*(rho*cp/gamma)^2;
c1    = S0*(1-A);
c2    = emi*SfBoltz;

% ASTEROID SHAPE MODEL: spherical assumption
nls  = 1;
radi = 80;
dsph = 20;
nsph = ceil((359-0)/dsph);
lo   = linspace(0,359,nsph)*pi/180;
la   = linspace(-90,90,nsph)*pi/180;
nlo  = numel(lo);
nla  = numel(la);
np   = nlo*nla;
pos  = zeros(3, np);
cpt  = 1;
for ii = 1:nlo
    for jj = 1:nla
        [posx,posy,posz] = sph2cart(lo(ii), la(jj), radi);
        pos(:,cpt) = [posx;posy;posz];
        cpt = cpt + 1;
    end
end
n = pos./radi;

% NUMERICAL MODEL DISCRETIZATION
dt   = et(2)-et(1);
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
c3   = k/(2*dx);

u_now = zeros(nx,np);

args = struct( ...
    'u_now', u_now, ...
    'pos',   pos,   ...
    'r',     r,     ...
    'dau',   dau,   ...
    'et',    et,    ...
    'ntp',   ntp,   ...
    'vx',    vx,    ...
    'n',     n,     ...
    'c1',    c1,    ...
    'c2',    c2,    ...
    'c3',    c3,    ...
    'S',     S,     ...
    'kk',    kk,    ...
    'kkm1',  kkm1,  ...
    'kkp1',  kkp1  ...
);

% TEMPERATURE SUBROUTINE
fprintf('Computing.. '); tic;
u = TEMP2(args); toc;

% DISPLAY
t = (et-et(1))/day;
Lo = repmat(lo, nlo, 1)*180/pi;
La = repmat(la', 1, nla)*180/pi;
u  = reshape(u, nlo, nla);
close all;
hold on; grid on;
xlim([0 359]);
ylim([-90 90]);
level = 0:10:400;
xlabel('Longitude [deg]'); ylabel('Latitude [deg]');
[C,h] = contourf(Lo,La,u,level,'showtext','on','linestyle','-');
colormap jet; caxis([0 400]);
clabel(C,h,'FontSize',8,'FontSmoothing','on');
title(sprintf('\n1.7 AU - %s=500\n', '\Gamma'));
if (0), print(gcf,imgname,'-dpng','-r600'); end