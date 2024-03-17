function fun_png_display_functionuse(date, rdata, i, print)
load 'Grid data.mat'

date = char(date);
ryear = date(5:8);
rmon = date(9:10);
rday = date(11:12);
rhour = date(14:15);
rmin = date(16:17);
%%%%%%%%%%%%%%
nr = 512;
nbearing = 1080;
nimg = 129;

%%
rdata = rdata(1:nr*nbearing*nimg);
rdata = reshape(rdata,nr,nbearing,nimg);
rdata = flip(rdata,3);

for ii = 1%:nimg

figure(i)
hold off

set(gcf,'position', [500 100 800 600])

surf(X, Y, rdata(:,:,ii), 'edgealpha',0);  

axis equal; axis([-2336 2336 -2336 2336]); view(0,90); 
colormap default;    clim([0 100]);    set(gca,'fontsize',13); grid off; axis off;

xlabel('X [m]');ylabel('Y [m]'); title('X-band radar imagery in normal condition')

%title(['RADAR image (ANIN, ' ryear '/'...
%        rmon '/' rday ' ' rhour ':' rmin ')'])  

end

% figure 저장 여부
if print == 1
    exportgraphics(gcf, [date(5:end-4) '.png'], 'Resolution', 300)
end