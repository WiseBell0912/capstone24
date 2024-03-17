function fun_png2gif_functionuse(date, rdata)
load 'Grid data.mat'
%%
date = char(date);
ryear = date(5:8);
rmon = date(9:10);
rday = date(11:12);
rhour = date(14:15);
rmin = date(16:17);

%%
%%%%%%%%%%%%%%

nr = 512;

nimg = 129;
nbearing = 1080;

%%%%%%%%%%%%%%

rdata = reshape(rdata,nr,nbearing,nimg);
rdata = flip(rdata,3);

for ii = 1:129%nimg

figure(1)
hold off
set(gcf,'position', [100 100 1200 800])

surf(X, Y, rdata(:,:,ii), 'edgealpha',0);  

axis equal; axis([-2336 2336 -2336 2336]); view(0,90); 
colormap default;    caxis([0 100]);    set(gca,'fontsize',13); grid on; 

xlabel('X [m]');ylabel('Y [m]');title(['RADAR image (ANIN, ' ryear '/'...
        rmon '/' rday ' ' rhour ':' rmin ')'])  

exportgraphics(gca,[date(5:end-4) '.gif'],"Append",true)

end
%%




