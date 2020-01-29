clear;

load('u_self0.mat');
obj = read_obj('mathilde.obj');
obj.f.v = obj.f.v(1:5:end, :);

close all;
hold on; axis square; axis tight; axis equal; axis off;
%movegui([2000, 400]);
xlabel('x'); ylabel('y'); zlabel('z');
draw=trisurf(obj.f.v,obj.v(:,1),obj.v(:,2),obj.v(:,3),'EdgeAlpha',0,'cdata',u);
cb=colorbar; colormap jet; caxis([0 400]);
%shading interp;
cameratoolbar;