clear;

savefig = 0;
mode    = 2;

r = 1.7557;
load('color.mat');
load(sprintf('U_r%.4f.mat', r));
t = linspace(0,11.92,100);
keys = U.keys();
values = U.values();
keys = cell2mat(keys);
values = cell2mat(values);
values = reshape(values, 100, 8)';
N = length(values(1,:));

keys_interp = linspace(30,2000,200);
values_interp = interp1(keys,values,keys_interp,'makima');

hold on; grid on; box on;
xlabel('Thermal Inertia [J.K-1.m-2.s-1/2]'); ylabel('Temperature [K]');
if (mode == 1)
    xlim([0 2000]); ylim([80 400]); xticks(0:200:2000); yticks(0:20:400);
    plot(keys_interp, max(values_interp'), '--', 'color', hex2rgb(color{2}), 'DisplayName', 'max(T)');
    plot(keys_interp, min(values_interp'), '--', 'color', hex2rgb(color{1}), 'DisplayName', 'min(T)');
    plot(keys, max(values'), 'o', 'color', 'k', 'markerfacecolor', hex2rgb(color{2}), 'markersize', 4, 'handlevisibility', 'off');
    plot(keys, min(values'), 'o', 'color', 'k', 'markerfacecolor', hex2rgb(color{1}), 'markersize', 4, 'handlevisibility', 'off');
elseif (mode == 2)
    c = hex2rgb(color{5});
    xlim([0 2000]); ylim([0 300]); xticks(0:200:2000); yticks(0:20:400);
    plot(keys_interp, max(values_interp')-min(values_interp'), '--', 'color', c, 'DisplayName', sprintf('%.4f', r));
    plot(keys, max(values')-min(values'), 'o', 'color', 'k', 'markerfacecolor', c, 'markersize', 4, 'handlevisibility', 'off');
end
legend('Location','bestoutside'); set(gca,'layer','top'); 
title(sprintf('\n%s{T}_{max, min}\n', '\Delta'));

if (savefig)
    modestyle = {'', '_delta'};
    imgname = sprintf('images/temp_gammas%s.png', modestyle{mode});
    print(gcf,imgname,'-dpng','-r600');
end