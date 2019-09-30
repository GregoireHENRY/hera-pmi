clear;

% =========================================================================
% Convergence of synthetic temperature evolution of a point at the equator
% =========================================================================
% 
gamma      = 500;
dau        = 1.5;
do_preload = 1;
do_save    = 1;
do_print   = 0;

toload = {'et' ...
          };
for ii = 1:length(toload)
    load(toload{ii});
end
if (do_preload)
    load('u_now');
    load('umax_v9');
    load('umin_v9');
    load('tp_v9');
end

au  = 1.495978707e+11;
day = 86400;

p     = 11.92 * 3600;
rho   = 2146;
cp    = 600;
k     = gamma^2 / (rho * cp);
alpha = k / (rho * cp);
ls    = sqrt(alpha * pi * p);
C     = 0.25;
V     = C * (rho * cp / gamma)^2;

nt    = numel(et);
t     = et - et(1);
dt    = t(2) - t(1);
np    = ceil(p / dt);
dx_   = sqrt( dt / V );
xmax  = ls*1; 
nx    = ceil((xmax - 0) / dx_);
vx    = linspace(0, xmax, nx);
dx    = vx(2) - vx(1);
kk    = 2:nx-1;
kkm1  = kk-1;   
kkp1  = kk+1;
S     = alpha * dt / dx^2;

R       = 80;
lo      = 0*pi/180;
la      = 0;
[x,y,z] = sph2cart(lo,la,R);
r       = [x;y;z];
n       = r./R; 

dec  = 0*pi/180;
sun  = [cos(dec);0;sin(dec)]*dau*au;
w    = r-sun;
w    = w./sqrt(sum(w.^2));

mrot = mrot3(0, 0, -dt * 2 * pi / p);
c1   = 1361.5 * (1 - 0.07) / dau^2;
c2   = 0.9 * 5.670374419e-8;
c3   = k / (2 * dx);

u = zeros(1, nt);
if (~do_preload)
    u_now = zeros(nx, 1);
    umax  = 0;
    umin  = 0;
    tp    = 0;
end

fprintf('Computing.. ');
tic;
for ii = 2:numel(t)
    u_prev   = u_now;
    n        = mrot * n;
    costh    = sum(-w .* n);
    Q        = c1 * costh;
    Q(Q < 0) = 0;

    newton_args      = {};
    newton_args.Q    = Q;
    newton_args.u_p1 = u_prev(2, :);
    newton_args.u_p2 = u_prev(3, :);
    newton_args.c2   = c2;
    newton_args.c3   = c3;

    u_now(1)   = NEWTON(u_prev(1), newton_args);
    u_now(kk)  = S * (u_prev(kkp1) + u_prev(kkm1)) ...
               + (1 - 2 * S) * u_prev(kk);
    u_now(end) = u_now(end-1);
    u(ii)      = u_now(1);
end
toc;

t=t(end-np+1:end)/3600;
u=u(end-np+1:end);
tnext=tp(end)+t(end)/11.92;
tp=[tp tnext];
umax=[umax max(u)];
umin=[umin min(u(u~=0))];
dumax=[0 umax(2:end)-umax(1:end-1)];
dumin=[0 umin(2:end)-umin(1:end-1)];
fprintf('Results:  %.2f %.2f\n', umax(end), umin(end));

close all;
subplot 121;
hold on; grid on; box on;
xlim([0 tp(end)]); ylim([0 350]);
xlabel('Time [period]'); ylabel('Temperature [K]');
plot(tp,umax,'-','color','k','displayname','max','linewidth',1);
plot(tp,umin,'--','color','k','displayname','min','linewidth',1);
legend('Location','bestoutside'); set(gca,'layer','top');
subplot 122;
hold on; grid on; box on;
xlim([tp(1) tp(end)]); ylim([0 1]);
xlabel('Time [period]'); ylabel('{\Delta} Temperature [K]');
plot(tp,dumax,'-','color','k','displayname','max','linewidth',1);
plot(tp,dumin,'--','color','k','displayname','min','linewidth',1);
legend('Location','bestoutside'); set(gca,'layer','top');
%movegui([2000, 500]);

if (do_print)
imgname = sprintf('images/temperature_convergence.png');
print(gcf,imgname,'-dpng','-r600');
end

if (do_save)
save('tp_v9','tp');
save('umax_v9','umax');
save('umin_v9','umin');
end
save('u_now', 'u_now');

fprintf('\n');