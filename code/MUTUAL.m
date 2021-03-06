clear;

do_preload = 0;

% WORLD CONSTANTS
day        = 86400;
au         = 1.495978707e11;
S0         = 1361.5;
SfBoltz    = 5.670374419e-8;

% SETTINGS
objpath  = '../kernels/dsk/hera_didymoon_k001_v01.obj';
objpath2 = '../kernels/dsk/hera_didymain_k001_v01(repaired).obj';
p        = 11.92*3600;
porb     = 11.92*3600;
gamma    = 500;
rho      = 2146;
cp       = 600;
A        = 0.07;
emi      = 0.9;
C        = 0.25;
dt       = 30;
t0       = 0;
tf       = 60*p;
tfr      = 0.75*p;
tf       = tf+tfr;

% COMPUTE POSITION
r = -[0; 1; 0]*au; 
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
obj = read_obj(objpath);
tris = set_tris(obj);
m = tris.m'*500;
n = tris.n';
sph = tris.sph;
area = tris.S';
np = length(n);

% ASTEROID SHAPE MODEL 2
obj2 = read_obj(objpath2);
tris2 = set_tris(obj2);
m2 = tris2.m'*1e3;
n2 = tris2.n';
sph2 = tris2.sph;
area2 = tris2.S';
np2 = length(n2);
r2 = [1; 0; 0]*1e3;
dau2 = my_norm(r2-r)/au;

% OBLIQUITY MODEL
obl   = 0;%162;
% rotv0 = [1; 0; 0];
rotv  = [0; -sind(obl); cosd(obl)];
% mrot0 = mrotv3(rotv0, obl*pi/180);
mrot  = mrotv3(rotv,  dt*2*pi/p);
% m     = mrot0*m;
% n     = mrot0*n;
% vert  = mrot0*obj.v';

dobj = my_norm(r2);
for ii=1:length(m)
    dirobj=m(:,ii)-(m2+r2);
    theta(ii,:) = angvec2(n(:,ii),-dirobj);
    theta2(ii,:) = angvec2(n2(:,ii),dirobj);
end
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

% diffuse (temperature midday)
tmd = sqrt(sqrt(c2/c3/dau^2));

u_now = zeros(nx,np);
if (0), load('u_now'); end

args = struct( ...
    'u_now',    u_now, ...
    'm2',       m2, ...
    'dobj',     dobj, ...
    'theta',    theta, ...
    'theta2',   theta2, ...
    'm',        m,   ...
    'r',        r,     ...
    'dau',      dau, ...
    'dau2',     dau2,   ...
    'area',     area, ...
    'area2',    area2, ...
    'et',       et,    ...
    'ntp',      ntp,   ...
    'vx',       vx,    ...
    'n',        n, ...
    'n2',       n2,     ...
    'mrot',     mrot,  ...
    'c1',       c1,    ...
    'c2',       c2, ...
    'c3',       c3,    ...
    'c4',       c4,    ...
    'S',        S,     ...
    'kk',       kk,    ...
    'kkm1',     kkm1,  ...
    'kkp1',     kkp1,  ...
    'tmd',      tmd    ...
);

% TEMPERATURE SUBROUTINE
fprintf('Computing.. '); tic;
u = TEMP_MUTUAL(args); toc;

% DISPLAY
close all;
t = (et-et(1))/day;
X = sph(:,1)*180/pi;
Y = sph(:,2)*180/pi;
[XX, YY, ZZ] = supercontour(X, Y, u);
figure;
hold on; grid on; axis equal;
xlim([min(min(XX)) max(max(XX))]);
ylim([min(min(YY)) max(max(YY))]);
yticks(-80:20:80);
level = 0:10:400;
xlabel('Longitude [deg]'); ylabel('Latitude [deg]');
[C,h] = contourf(XX,YY,ZZ,level,'showtext','off','linestyle','-');
colormap jet; caxis([0 400]); colorbar;
title(sprintf('%.1f AU', dau));

% t = (et-et(1))/day;
% X = sph(:,1)*180/pi;
% Y = sph(:,2)*180/pi;
% [XX, YY, ZZ] = supercontour(X, Y, ud);
% close all;
% hold on; grid on; axis equal;
% xlim([min(min(XX)) max(max(XX))]);
% ylim([min(min(YY)) max(max(YY))]);
% yticks(-80:20:80);
% level = 0:0.1:10;
% xlabel('Longitude [deg]'); ylabel('Latitude [deg]');
% [C,h] = contourf(XX,YY,ZZ,level,'showtext','off','linestyle','-');
% colormap jet;
% title(sprintf('%.1f AU', dau));
% colorbar
% caxis([min(ud) max(ud)]);
% % imgname    = sprintf('images/mutual.png');
% % print(gcf,imgname,'-dpng','-r600');

m2r = m2+r2;
figure;
hold on; grid on; axis equal;
scatter3(m(1,:), m(2,:), m(3,:), 'b', 'filled', 'sizedata', 4, 'markeredgecolor', 'k');
scatter3(m2r(1,:), m2r(2,:), m2r(3,:), 'b', 'filled', 'sizedata', 3, 'markeredgecolor', 'k');
ru = r/my_norm(r)*1500;
scatter3(ru(1,:), ru(2,:), ru(3,:), 'r', 'filled', 'sizedata', 200, 'markeredgecolor', 'k');
% imgname    = sprintf('images/mutual_model.png');
% print(gcf,imgname,'-dpng','-r600');