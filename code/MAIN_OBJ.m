clear;

do_preload = 0;

% WORLD CONSTANTS
day        = 86400;
au         = 1.495978707e11;
S0         = 1361.5;
SfBoltz    = 5.670374419e-8;

% SETTINGS
objpath = '../kernels/dsk/hera_didymoon_k001_v01.obj';
p       = 11.92*60*60;
gamma   = 100;
rho     = 2146;
cp      = 600;
A       = 0.07;
emi     = 0.9;
C       = 0.25;
dt      = 4;
t0      = 0;
tf      = 10*day;
tfr     = 7*3600 + 15*60;
tf      = tf+tfr;

% COMPUTE POSITION
r = [0; 1.7; 0]*au; 
dau = my_norm(r)/au;

% ASTEROID GROUND PROPERTIES COMPUTED
k     = gamma^2/(rho*cp);
alpha = k/(rho*cp);
ls    = sqrt(alpha*pi*p);
V     = C*(rho*cp/gamma)^2;
c1    = S0*A;
c2    = S0*(1-A);
c3    = emi*SfBoltz;
nls   = 1;

% ASTEROID SHAPE MODEL
obj = read_obj(objpath);
tris = set_tris(obj);
m = tris.m'*1e3;
n = tris.n';
sph = tris.sph;
np = length(n);

% OBLIQUITY MODEL
obl   = 162;
rotv0 = [1; 0; 0];
rotv  = [0; -sind(obl); cosd(obl)];
mrot  = mrotv3(rotv, dt*2*pi/p);
m     = mrotv3(rotv0, obl*pi/180)*m;
n     = mrotv3(rotv0, obl*pi/180)*n;
vert  = mrotv3(rotv0, obl*pi/180)*obj.v';

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
u = TEMP_OBJ(args); toc;

% DISPLAY
t = (et-et(1))/day;
X = sph(:,1)*180/pi;
Y = sph(:,2)*180/pi;
[XX, YY, ZZ] = supercontour(X, Y, u);

close all;
hold on; grid on; axis equal;
xlim([min(min(XX)) max(max(XX))]);
ylim([min(min(YY)) max(max(YY))]);
yticks(-80:20:80);
level = 0:10:400;
xlabel('Longitude [deg]'); ylabel('Latitude [deg]');
[C,h] = contourf(XX,YY,ZZ,level,'showtext','on','linestyle','-');
colormap jet; caxis([0 400]);
clabel(C,h,'FontSize',8,'FontSmoothing','on');
title(sprintf('%.1f AU - %s=%d', dau, '\Gamma', gamma));

figure;
hold on; axis square; axis tight; axis equal; axis off;
xlabel('x'); ylabel('y'); zlabel('z');
draw=trisurf(obj.f. v,vert(1,:), vert(2,:), vert(3,:),'EdgeAlpha',0,'cdata',u);
colormap jet; caxis([0 400]);
cameratoolbar;
%shading interp;

imgname = sprintf('images/juventas_d%.1f_g%.0f.png', dau, gamma);
% print(gcf,imgname,'-dpng','-r600');
save(sprintf('u_d%.1f_g%.0f.mat', dau, gamma), 'u');