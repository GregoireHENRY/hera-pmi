function u = TEMP3(args)

% Subroutine to compute the temperature
% 
% Inputs
%     args  - structure containing the simulation variables:
%                 u_now - initialized temperature
%                 pos   - shape model surface nodes
%                 r     - Sun position
%                 dau   - Sun distance in AU
%                 et    - simuation time
%                 ntp   - last period time size
%                 vx    - ground depth
%                 n     - normals of the studied points of the asteroid
%                 c2    - flux-out constant: emi*SfBoltz
%                 c3    - newton function constant: k/(2*dx)
%                 S     - numerical method constant: alpha*dt/dx^2
%                 kk    - depth range now
%                 kkm1  - depth range prev
%                 kkp1  - depth range next
%
% Outputs
%     u - surface temperature

u_now = args.u_now;
pos   = args.pos;
M_pos = args.M_pos;
d_Mm  = args.d_Mm;
theta = args.theta;
M_theta = args.M_theta;
r     = args.r;
dau   = args.dau;
M_dau = args.M_dau;
n     = args.n;
M_n   = args.M_n;
nt    = numel(args.et);

for ii = 2:nt
    u_prev  = u_now;
    w       = unit(pos-r(:,1));
    M_w     = unit(M_pos-r(:,1));
    costh   = sum(-w.*n);
    M_costh = sum(-M_w.*M_n);
    Vij     = 3*theta.*M_theta./(pi*d_Mm.^2);
    Vij(logical((theta>90) + (M_theta>90))) = 0;
    M_Q     = Vij*args.c1.*M_costh./M_dau(1)^2;
    M_Q(M_Q<0) = 0;  
    Q       = args.c2*costh./dau(1)^2;
    Q(Q<0)  = 0;
    QF      = sum(M_Q) + Q;
    
    newton_args      = {};
    newton_args.ii   = ii;
    newton_args.Q    = QF;
    newton_args.u_p1 = u_prev(2,:);
    newton_args.u_p2 = u_prev(3,:);
    newton_args.c3   = args.c3;
    newton_args.c4   = args.c4;
    newton_args.ii   = ii;

    u_now(1,:)       = NEWTON(u_prev(1,:), newton_args);
    u_now(args.kk,:) = args.S*(u_prev(args.kkp1,:)+u_prev(args.kkm1,:)) ...
                     +(1-2*args.S)*u_prev(args.kk,:);
    u_now(end,:)     = u_now(end-1,:);
end
save('u_now', 'u_now');
u = u_now(1,:);