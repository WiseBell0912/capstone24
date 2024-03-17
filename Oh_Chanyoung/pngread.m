clear; close all; clc;
%%
fdir = pwd;
fname0 = '20181208_1900';
pngname = [fdir '/png/' fname0 '.png'];

rdata = imread(pngname);

ryear = fname0(1:4);
rmon = fname0(5:6);
rday = fname0(7:8);
rhour = fname0(10:11);
rmin = fname0(12:13);
%%

%%%%%%%%%%%%%%
sdrng = 800; %[m]
dr = 3; %[m]
nr = 512;
mdeg = 76;% modification factor for north correction

rr = sdrng:dr:sdrng+dr*(nr-1);

nimg = 128;
nbearing = 1080;

theta = linspace(0,2*pi,nbearing);

[Th,R] = meshgrid(theta,rr);

X = R.*cos( deg2rad(90) - Th - deg2rad(mdeg));
Y = R.*sin( deg2rad(90) - Th - deg2rad(mdeg));
%%%%%%%%%%%%%%
rdata = rdata(1:nr*nbearing*nimg);
rdata = reshape(rdata,nr,nbearing,nimg);
rdata = flip(rdata,3);

for ii = 1:nimg

figure(10)
hold off
set(gcf,'position', [500 100 800 600])

surf(X, Y, rdata(:,:,ii), 'edgealpha',0);  

axis equal; axis([-2336 2336 -2336 2336]); view(0,90); 
colormap default;    caxis([0 100]);    set(gca,'fontsize',13); grid on; 

xlabel('X [m]');ylabel('Y [m]');title(['RADAR image (ANIN, ' ryear '/'...
        rmon '/' rday ' ' rhour ':' rmin ')'])  
end


% save polar data
save('polar_temp.mat','fname0','rdata','X','Y')

