function bigtitle(txt,fs)

if (nargin<2), fs=14; end

axes('position',[0 0.95 1 0.05]);
set( gca,'color','none','xcolor','none','ycolor','none');
text(0.5,0,txt,'FontSize', fs,'FontWeight','Bold', ...
     'HorizontalAlignment','Center','VerticalAlignment','Bottom');
