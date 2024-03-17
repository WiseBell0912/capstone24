clc; clear; close all;
% The ratio of the average energy level between the inward and outward waves 
% in the case of precipitation/snowfall.

%The calculations were based on a square of a certain size.

%% if you want to plot snow case
load snow.mat
%% if you want to plot rain case
% load rain.mat

fdir = '/Users/kimyehyun/Documents/Thousand/PRI/PNG/rain_test/';
flist = dir([fdir '*.png']);

for i = 1:length(flist)
    %     fname = 'AIB_' + new(i, 1) + '.png';
    lname = flist(i).name;
    fi = lname(5:end-6);
    idx = find(new(:,1) == fi);
    if isempty(idx)
        precipi = "0";
    else 
        precipi = new(idx, 2);
    end
    %     idx = find([flist(:).name] == fname);

    %%
    pngname = [fdir lname];

    rdata = imread(pngname);

    ryear = lname(5:8);
    rmon = lname(9:10);
    rday = lname(11:12);
    rhour = lname(14:15);
    rmin = lname(16:17);
    %%

    %%%%%%%%%%%%%%
    sdrng = 800; %[m]
    dr = 3; %[m]
    nr = 512;
    mdeg = 29;% modification factor for north correction

    rr = sdrng:dr:sdrng+dr*(nr-1);

    nimg = 128;
    nbearing = 1080;

    theta = linspace(0,2*pi,nbearing);

    [Th,R] = meshgrid(theta,rr);

    X = R.*cos( deg2rad(90) - Th - deg2rad(mdeg));
    Y = R.*sin( deg2rad(90) - Th - deg2rad(mdeg));


    LBX1 = -1300;
    RTX1 = -800;
    LBY1 = 400;
    RTY1 = 900;

    LBX2 = -250;
    RTX2 = 250;
    LBY2 = 1750;
    RTY2 = 2250;
    %%%%%%%%%%%%%
    rdata = rdata(1:nr*nbearing*nimg);
    rdata = reshape(rdata,nr,nbearing,nimg);
    rdata = flip(rdata,3);

    x11 = LBX1:RTX1;
    y11 = ones(size(x11))*LBY1;
    z11 = ones(size(x11))*150;
    
    x12 = LBX1:RTX1;
    y12 = ones(size(x12))*RTY1;
    z12 = ones(size(x12))*150;
    
    y13 = LBY1:RTY1;
    x13 = ones(size(y13))*LBX1;
    z13 = ones(size(y13))*150;
    
    y14 = LBY1:RTY1;
    x14 = ones(size(y14))*RTX1;
    z14 = ones(size(y14))*150;

    x21 = LBX2:RTX2;
    y21 = ones(size(x21))*LBY2;
    z21 = ones(size(x21))*150;
    
    x22 = LBX2:RTX2;
    y22 = ones(size(x22))*RTY2;
    z22 = ones(size(x22))*150;
    
    y23 = LBY2:RTY2;
    x23 = ones(size(y23))*LBX2;
    z23 = ones(size(y23))*150;
    
    y24 = LBY2:RTY2;
    x24 = ones(size(y24))*RTX2;
    z24 = ones(size(y24))*150;

    for ii = 1%:nimg
        idx1X = find(X>LBX1 & X<RTX1);
        idx1Y = find(Y>LBY1 & Y<RTY1);

        idx1Z = intersect(idx1X, idx1Y);

        idx2X = find(X>LBX2 & X<RTX2);
        idx2Y = find(Y>LBY2 & Y<RTY2);

        idx2Z = intersect(idx2X, idx2Y);

        cdata = rdata(:,:,ii);
        nei = mean(cdata(idx1Z), 'all');
        wai = mean(cdata(idx2Z), 'all');
        ratio = nei/wai;

        figure(10)
        hold off
        set(gcf,'position', [500 100 800 600])

        surf(X, Y, rdata(:,:,ii), 'edgealpha',0);

        axis equal; axis([-2336 2336 -2336 2336]); view(0,90);
        colormap default;    clim([0 100]);    set(gca,'fontsize',13); grid on;

        xlabel('X [m]');ylabel('Y [m]');title(['RADAR image (ANIN, ' ryear '/' rmon ...
            '/' rday ' ' rhour ':' rmin ')'], ['Precipitation', precipi, 'in/out Ratio', ratio])
        hold on
        plot3(x11, y11, z11,'r', 'LineWidth', 1.5);
        plot3(x12, y12, z12,'r', 'LineWidth', 1.5);
        plot3(x13, y13, z13,'r', 'LineWidth', 1.5);
        plot3(x14, y14, z14,'r', 'LineWidth', 1.5);

        plot3(x21, y21, z21,'r', 'LineWidth', 1.5);
        plot3(x22, y22, z22,'r', 'LineWidth', 1.5);
        plot3(x23, y23, z23,'r', 'LineWidth', 1.5);
        plot3(x24, y24, z24,'r', 'LineWidth', 1.5);

        saveas(gcf,lname);
    end
end