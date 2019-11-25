function sets = SETTINGS(model)

% Subroutine to setup simulation variables from initialization sets
% 
% Inputs                
%     model - name of the simulation model:
%                 pelivan
%                 delbo
%                 ground
%                 contour
%
% Outputs
%     sets - structure containing all the necessary sets:           
%                p       - revolution period
%                t       - simulation time
%                dau     - distance to the Sun in AU
%                gamma   - thermal inertia
%                rho     - density
%                cp      - heat capacity
%                A       - albedo
%                emi     - emissivity
%                C       - numerical model stability condition
%                nls     - number of ls to define the depth
%                radi    - asteroid radius (spherical object assomption)
%                lo      - longitude
%                la      - latitude
%                obl     - obliquity

% pelivan
% -------
% p: 11.92h
% gamma: 500
% dau: 1.074, 1.574, 2.073
% dsph: 5�
% obl: 162�
%
% delbo
% -----
% p: 6h
% gamma:    10, 50, 100, >200
% dt:     0.05,  1,   4,   30   (change dt in t settings according to gamma)
% dau: 1.1
% A: 0.1
% obl: 0�
%
% ground
% ------
% obl: 0�

% Settings
p     = 11.92*3600;
dt    = 30;
tf    = 20*p;
t     = 0:dt:tf;
dau   = 1.7557;
gamma = 500;
rho   = 2147;
cp    = 600;
A     = 0.07;
emi   = 0.9;
C     = 0.25;
nls   = 1;
radi  = 80;
dsph  = 20;
nsph  = ceil((359-0)/dsph);
lo    = linspace(0,359,nsph)*pi/180;
la    = linspace(-90,90,nsph)*pi/180;
if (strcmp(model,'pelivan'))
    la = 0; 
elseif (strcmp(model, 'delbo'))
    lo = 0;
    la = 0;
elseif (strcmp(model, 'ground'))
    lo = 0;
    la = 0;
elseif (strcmp(model,'contour'))
else, error('model %s not recognized', model);
end
obl     = 0*pi/180;

sets = struct( ...
    'p',       p,       ...
    't',       t,       ...
    'dau',     dau,     ...
    'gamma',   gamma,   ...
    'rho',     rho,     ...
    'cp',      cp,      ...
    'A',       A,       ...
    'emi',     emi,     ...
    'C',       C,       ...
    'nls',     nls,     ...
    'radi',    radi,    ...
    'lo',      lo,      ...
    'la',      la,      ...
    'obl',     obl      ...
);