clear;

do_preload = 0;

% CONSTANTS & NAMES
day        = 86400;
au         = 1.495978707e11;
S0         = 1361.5;
SfBoltz    = 5.670374419e-8;

% SETTINGS
p     = 11.92*3600;
porb  = 11.92*3600;
gamma = 500;
rho   = 2146;
cp    = 600;
A     = 0.07; 
emi   = 0.9;
C     = 0.25;
dt    = 30;
t0    = 0;
tf    = 50*p;
tfr   = 0.25*p;
tf    = tf+tfr;

% COMPUTE POSITION
r = -[0; 1.0748; 0]*au; 
dau = my_norm(r)/au;

% ASTEROID GROUND PROPERTIES COMPUTED
k     = gamma^2/(rho*cp);
alpha = k/(rho*cp);
ls    = sqrt(alpha*pi*porb);
V     = C*(rho*cp/gamma)^2;
c1    = S0*A;
c2    = S0*(1-A);
c3    = emi*SfBoltz;
nls   = 1;

% ASTEROID SHAPE MODEL
objpath='didy.obj';
%objpath = '../kernels/dsk/hera_didymoon_k001_v01.obj';
obj = read_obj(objpath);
tris = set_tris(obj);
m = tris.m';
n = tris.n';
sph = tris.sph;

% HOUR ANGLE MERDIAN lo=0°
thrsh = 0.03;
condlo = sph(:,1)<thrsh & sph(:,1)>0;
sph = sph(condlo,:);
m = m(:,condlo);
n = n(:,condlo);
np = length(n);

% OBLIQUITY MODEL
obl   = 162;
rotv0 = [1; 0; 0];
rotv  = [0; -sind(obl); cosd(obl)];
mrot0 = mrotv3(rotv0, obl*pi/180);
mrot  = mrotv3(rotv,  dt*2*pi/p);
m     = mrot0*m;
n     = mrot0*n;

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
    'pos',      m,   ...
    'r',        r,     ...
    'dau',      dau,   ...
    'et',       et,    ...
    'ntp',      ntp,   ...
    'np',       np,    ...
    'vx',       vx,    ...
    'n',        n,     ...
    'mrot',     mrot,  ...
    'c2',       c2,    ...
    'c3',       c3,    ...
    'c4',       c4,    ...
    'S',        S,     ...
    'kk',       kk,    ...
    'kkm1',     kkm1,  ...
    'kkp1',     kkp1   ...
);

% TEMPERATURE SUBROUTINE
fprintf('Computing.. '); tic;
u = TEMP4(args); toc;

% DISPLAY
t = (et-et(1))/day;
la = sph(:,2)*180/pi;
hr = linspace(0,359,ntp);
[XX, YY, ZZ] = supercontour(hr, la, u);
close all;
hold on; grid on; %axis equal;
xlim([min(min(XX)) max(max(XX))]);
ylim([min(min(YY)) max(max(YY))]);
yticks(-80:20:80);
level = 0:15:400;
xlabel('Hour angle [deg]'); ylabel('Latitude [deg]');
[C,h] = contourf(XX,YY,ZZ,level,'showtext','off','linestyle','-');
colormap jet; caxis([100 350]); colorbar;
%clabel(C,h,'FontSize',8,'FontSmoothing','on');
title(sprintf('%.4f AU', dau));
set(gcf, 'Position', [819 189 425 373]);

imgname    = sprintf('images/hourangle_d%.4f.png', dau);
% print(gcf,imgname,'-dpng','-r600');

close all;
hold on; grid on; axis equal;
scatter3(m(1,:), m(2,:), m(3,:), 'b', 'filled', 'sizedata', 3, 'markeredgecolor', 'k');
ru = r/my_norm(r)*100;
scatter3(ru(1,:), ru(2,:), ru(3,:), 'r', 'filled', 'sizedata', 1000, 'markeredgecolor', 'k');