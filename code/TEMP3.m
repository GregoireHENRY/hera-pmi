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

u_now  = args.u_now;
m      = args.m;
m2     = args.m2;
dobj   = args.dobj;
theta  = args.theta;
theta2 = args.theta2;
r      = args.r;
dau    = args.dau;
dau2   = args.dau2;
area2  = args.area2;
n      = args.n;
n2     = args.n2;
nt     = numel(args.et);

for ii = 2:nt
    u_prev   = u_now;
    w        = unit(m-r(:,1));
    w2       = unit(m2-r(:,1));
    n       = args.mrot*n;
    costh    = sum(-w.*n);
    costh2   = sum(-w2.*n2);
    costh(costh<0) = 0;
    costh2(costh2<0) = 0;
    theta(theta>90) = 0;
    theta2(theta2>90) = 0;
    Vij      = area2.*theta.*theta2./(pi*dobj.^2);
    %Vij(logical((theta>90) + (theta2>90))) = 0;
    Q2       = Vij*args.c1.*costh2./dau2^2;
    %Q2(Q2<0) = 0;  
    QS       = args.c2*costh./dau^2;
    %QS(QS<0) = 0;
    QD = Vij.*args.c3*args.tmd^4;
    QF       = sum(Q2,2)' + QS + sum(QD,2)';
    
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