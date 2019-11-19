clear;

toload = { 'obj' ...
           'tris' ...
           'u_v10_g500_r1' ...
           'cdata' ...
         };
for ii = 1:length(toload), load(toload{ii}); end

close all;
hold on; axis square; axis tight; axis equal; axis off;
movegui([2000, 400]);
xlabel('x'); ylabel('y'); zlabel('z');
draw=trisurf(obj.f.v,obj.v(:,1),obj.v(:,2),obj.v(:,3),'EdgeAlpha',0,'cdata',cdata);
cb=colorbar; colormap jet; caxis([0 400]);
shading interp;
cameratoolbar;