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
au         = 1.495978707e11;
S0         = 1361.5;
SfBoltz    = 5.670374419e-8;
timesetup  = {'2027-JUN-05 05:00' 15*day 30};
path       = '/home/greg/hera/kernels/';
imgname    = 'images/test.png';

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
r   = cspice_spkposm(SUN,et,FRAME2,CORR,OBJ2);
dau = my_norm(r)/au;
cspice_kclear;
%r = repmat([0;0;2.5e11], 1, 28801);

% ASTEROID GROUND PROPERTIES COMPUTED
k     = gamma^2/(rho*cp);
alpha = k/(rho*cp);
ls    = sqrt(alpha*pi*p);
V     = C*(rho*cp/gamma)^2;
c1    = S0*A;
c2    = S0*(1-A);
c3    = emi*SfBoltz;

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
c4   = k/(2*dx);

%u_now = zeros(nx,np);
u_now = zeros(nx,np);
if (0), load('u_now'); end

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
fprintf('u: %.2f\n', u);