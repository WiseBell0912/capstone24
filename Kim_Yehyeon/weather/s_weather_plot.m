clc; clear; close all;
% This code loads radar images for days only with recorded precipitation 
% and displays them along with the precipitation amounts.

%% if you want to plot snow case
load snow.mat
%% if you want to plot rain case
% load rain.mat

load 'Grid data.mat'

fdir = '/Users/kimyehyun/Documents/Thousand/PRI/PNG/';
flist = dir([fdir '*.png']);

% Since precipitation is measured on an hourly basis, this script uses 
% the radar data from the 00 minute mark, and if data for 00 minutes 
% is not available, it substitutes it with the data from the 10 minute mark.
for i = 1:length(new)
    lname = new(i,1);
    try
        pngname = strcat(fdir, 'AIB_', new(i,1), '00.png');
    catch
        pngname = strcat(fdir, 'AIB_', new(i,1), '10.png');
    end
        precipi = new(i,2);
    %%
    rdata = imread(pngname);
    lname = char(lname);
    ryear = lname(1:4);
    rmon = lname(5:6);
    rday = lname(7:8);
    rhour = lname(10:11);
    rmin = '00';
    %%

    %%%%%%%%%%%%%%
    sdrng = 800; %[m]
    dr = 3; %[m]
    nr = 512;
    mdeg = 29;% modification factor for north correction
    nimg = 128;
    nbearing = 1080;
    %%%%%%%%%%%%%%

    rdata = rdata(1:nr*nbearing*nimg);
    rdata = reshape(rdata,nr,nbearing,nimg);
    rdata = flip(rdata,3);

    for ii = 1%:nimg
        figure(10)
        hold off
        set(gcf,'position', [500 100 800 600])

        surf(X, Y, rdata(:,:,ii), 'edgealpha',0);

        axis equal; axis([-2336 2336 -2336 2336]); view(0,90);
        colormap default;    clim([0 100]);    set(gca,'fontsize',13); grid on;

        xlabel('X [m]');ylabel('Y [m]');title(['RADAR image (ANIN, ' ryear '/' rmon ...
            '/' rday ' ' rhour ':' rmin ')'], ['Precipitation', precipi])
        hold on
        saveas(gcf,lname);
    end
end