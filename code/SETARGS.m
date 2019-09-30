function args = SETARGS(preload, sets)

% Subroutine to setup simulation variables from initialization sets
% 
% Inputs
%     preload - boolean temperature repartition initialization
%     sets    - structure containing all the necessary sets:           
%                   p       - revolution period
%                   t       - simulation time
%                   dau     - distance to the Sun in AU
%                   gamma   - thermal inertia
%                   rho     - density
%                   cp      - heat capacity
%                   A       - albedo
%                   emi     - emissivity
%                   C       - numerical model stability condition
%                   nls     - number of ls to define the depth
%                   radi    - asteroid radius (spherical object assomption)
%                   lo      - longitude
%                   la      - latitude
%                   obl     - obliquity
%                
%
% Outputs
%     args - structure containing the simulation variables:
%                u_now - initialized temperature
%                t     - simuation time
%                ntp   - last period time size
%                vx    - ground depth
%                n     - normals of the studied points of the asteroid
%                w     - direction of the sun
%                mrot  - rotation matrix to rotate normals to respect the
%                        revolution period of the asteroid
%                c1    - flux-in constant: S*(1-A)/r^2
%                c2    - flux-out constant: emi*SfBoltz
%                c3    - newton function constant: k/(2*dx)
%                S     - numerical method constant: alpha*dt/dx^2
%                kk    - depth range now
%                kkm1  - depth range prev
%                kkp1  - depth range next

% Universal constant
au      = 1.495978707e+11;
S0      = 1361.5;
SfBoltz = 5.670374419e-8;

% Asteroid properties
k     = sets.gamma^2/(sets.rho*sets.cp);
alpha = k/(sets.rho*sets.cp);
ls    = sqrt(alpha*pi*sets.p);
V     = sets.C*(sets.rho*sets.cp/sets.gamma)^2;
c1    = S0*(1-sets.A)/sets.dau^2;
c2    = sets.emi*SfBoltz;

% Numerical model discretization
dt   = sets.t(2)-sets.t(1);
dx_  = sqrt(dt/V);
ntp  = ceil(sets.p/dt);
xmax = ls*sets.nls; 
nx   = ceil((xmax-0)/dx_);
vx   = linspace(0,xmax,nx);
dx   = vx(2)-vx(1);
kk   = 2:nx-1;
kkm1 = kk-1;  
kkp1 = kk+1;
S    = alpha*dt/dx^2;
mrot = mrot3(0,0,dt*2*pi/sets.p);
c3   = k/(2*dx);

% Asteroid shape model (spherical object assomption)
nlo = numel(sets.lo);
nla = numel(sets.la);
np  = nlo*nla;
pos = zeros(3, np);
cpt = 1;
for ii = 1:nlo
    for jj = 1:nla
        [posx,posy,posz] = sph2cart(sets.lo(ii), sets.la(jj), sets.radi);
        pos(:,cpt) = [posx;posy;posz];
        cpt = cpt + 1;
    end
end
n = pos./sets.radi;

% Asteroid obliquity model and Sun direction
sun  = -[cos(sets.obl);0;-sin(sets.obl)]*sets.dau*au;
w    = pos-sun;
w    = w./sqrt(sum(w.^2));

% Asteroid temperature repartition initialization
if (preload), load('u_now.mat', 'u_now');
else, u_now = zeros(nx,np);
end

args = struct( ...
    'u_now', u_now,  ...
    't',     sets.t, ...
    'ntp',   ntp,    ...
    'vx',    vx,     ...
    'n',     n,      ...
    'w',     w,      ...
    'mrot',  mrot,   ...
    'c1',    c1,     ...
    'c2',    c2,     ...
    'c3',    c3,     ...
    'S',     S,      ...
    'kk',    kk,     ...
    'kkm1',  kkm1,   ...
    'kkp1',  kkp1    ...
);