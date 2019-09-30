function u = TEMP(model, args)

% Subroutine to compute the temperature
% 
% Inputs
%     model - name of the simulation model:
%                 pelivan
%                 delbo
%                 ground
%                 contour
%     args  - structure containing the simulation variables:
%                 u_now - initialized temperature
%                 t     - simuation time
%                 ntp   - last period time size
%                 vx    - ground depth
%                 n     - normals of the studied points of the asteroid
%                 w     - direction of the sun
%                 mrot  - rotation matrix to rotate normals to respect the
%                         revolution period of the asteroid
%                 c1    - flux-in constant: S*(1-A)/r^2
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
n = args.n;
nt = numel(args.t);

if (strcmp(model, 'delbo'))
u = zeros(1,args.ntp);
elseif (strcmp(model, 'ground'))
u = zeros(size(u_now,1),args.ntp);
end

for ii = 2:nt
    u_prev = u_now;
    n      = args.mrot*n;
    costh  = sum(-args.w.*n);
    Q      = args.c1*costh;
    Q(Q<0) = 0;

    newton_args      = {};
    newton_args.Q    = Q;
    newton_args.u_p1 = u_prev(2,:);
    newton_args.u_p2 = u_prev(3,:);
    newton_args.c2   = args.c2;
    newton_args.c3   = args.c3;

    u_now(1,:)       = NEWTON(u_prev(1,:), newton_args);
    u_now(args.kk,:) = args.S*(u_prev(args.kkp1,:)+u_prev(args.kkm1,:)) ...
                     +(1-2*args.S)*u_prev(args.kk,:);
    u_now(end,:)     = u_now(end-1,:);
    
    if (strcmp(model, 'delbo'))
    if (nt-ii < args.ntp)
        ind = args.ntp-(nt-ii);
        u(:,ind) = u_now(1)';
    end
    elseif (strcmp(model, 'ground'))
    if (nt-ii < args.ntp)
        ind = args.ntp-(nt-ii);
        u(:,ind) = u_now;
    end
    end
end
save('u_now', 'u_now');
if (~strcmp(model, 'delbo') && ~strcmp(model, 'ground'))
u = u_now(1,:);
end