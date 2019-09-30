function PRINT(model, savefig, u, args, sets)

% Subroutine to compute the temperature
% 
% Inputs
%     model   - name of the simulation model:
%                   pelivan
%                   delbo
%                   ground
%                   contour
%     savefig - boolean figure saving png
%     u       - surface temperature
%     args    - structure containing the simulation variables:
%                   u_now - initialized temperature
%                   t     - simuation time
%                   ntp   - last period time size
%                   vx    - ground depth
%                   n     - normals of the studied points of the asteroid
%                   w     - direction of the sun
%                   mrot  - rotation matrix to rotate normals to respect the
%                           revolution period of the asteroid
%                   c1    - flux-in constant: S*(1-A)/r^2
%                   c2    - flux-out constant: emi*SfBoltz
%                   c3    - newton function constant: k/(2*dx)
%                   S     - numerical method constant: alpha*dt/dx^2
%                   kk    - depth range now
%                   kkm1  - depth range prev
%                   kkp1  - depth range next
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
% Outputs
%     void

load('color.mat', 'color');
lo = sets.lo*180/pi;
la = sets.la*180/pi;
nlo = numel(lo);
nla = numel(la);

if (strcmp(model, 'pelivan'))
load(sprintf('yq_v4_r%.3f.mat',sets.dau),'yq');
close all;
subplot 211;
hold on; grid on; box on;
xlim([0 359]); ylim([160 360]); xticks(0:50:360); yticks(0:20:400);
xlabel('Longitude [deg]'); ylabel('Temperature [K]');
plot(lo,u,'-','color',color{1},'DisplayName',sprintf("%.3f",sets.dau));
plot(lo,yq,'--','color',color{1},'DisplayName',sprintf("%.3f",sets.dau));
legend('Location','bestoutside'); set(gca,'layer','top');
subplot 212;
hold on; grid on; box on;
xlim([0 359]); ylim([0 6]); xticks(0:50:360); yticks(0:1:10);
xlabel('Longitude [deg]'); ylabel('{\Delta} Temperature [K]');
plot(lo,abs(u-yq),'-o','markersize',2,'color',color{1},...
     'DisplayName',sprintf("%.3f",sets.dau));
legend('Location','bestoutside'); set(gca,'layer','top');
imgname = sprintf('images/temperature_equator_dau%.3f.png',sets.dau);
if (savefig), fprintf('saving as png.. ');
    print(gcf,imgname,'-dpng','-r600');
end

elseif (strcmp(model, 'delbo'))
load(sprintf('yq_v6_g%d.mat',sets.gamma),'yq');
tp = linspace(0,6,numel(yq));
indi = floor(linspace(1,size(u,2),numel(tp)));
u = u(indi);
close all;
subplot 211;
hold on; grid on; box on;
xlim([0 6]); ylim([80 400]); xticks(0:1:6); yticks(0:20:400);
xlabel('Time [h]'); ylabel('Temperature [K]');
plot(tp,u,'-','color',color{1},'DisplayName',sprintf("%d",sets.gamma));
plot(tp,yq,'--','color',color{1},'DisplayName',sprintf("%d",sets.gamma));
legend('Location', 'bestoutside'); set(gca,'layer','top');
subplot 212;
hold on; grid on; box;
xlim([0 6]); ylim([0 16]); xticks(0:1:6); yticks(0:2:16);
xlabel('Time [h]'); ylabel('Temperature [K]');
plot(tp,abs(u-yq),'-o','markersize',2,'color',color{1},...
     'DisplayName',sprintf("%d", sets.gamma));
legend('Location', 'bestoutside'); set(gca,'layer','top');
imgname = sprintf('images/temperature_equator_gamma_%d.png',sets.gamma);
if (savefig), fprintf('saving as png.. ');
    print(gcf,imgname,'-dpng','-r600');
end

elseif (strcmp(model, 'ground'))
close all;
hold on; grid on; box on;
xlim([0 args.vx(end)]); ylim([180 310]); yticks(0:10:400);
xlabel('Ground depth [m]'); ylabel('Temperature [K]');
plot(args.vx,u(:,1:120:args.ntp),'color','k');
set(gca,'layer','top');
imgname = sprintf('images/temperature_ground.png');
if (savefig), fprintf('saving as png.. ');
    print(gcf,imgname,'-dpng','-r600');
end

elseif (strcmp(model, 'contour'))
Lo = repmat(lo, nlo, 1);
La = repmat(la', 1, nla);
u  = reshape(u, nlo, nla);
close all;
hold on; grid on;
xlim([0 359]);
ylim([-90 90]);
level = 0:10:400;
xlabel('Longitude [deg]'); ylabel('Latitude [deg]');
[C,h] = contourf(Lo,La,u,level,'showtext','on','linestyle','-');
colormap jet; caxis([0 400]);
clabel(C,h,'FontSize',8,'FontSmoothing','on');
imgname = sprintf('images/temperature_contour_g%d_r%.4f.png',...
                  sets.gamma,sets.dau);
if (savefig), fprintf('saving as png.. ');
    print(gcf,imgname,'-dpng','-r600');
end
end

% movegui([2000, 400]);