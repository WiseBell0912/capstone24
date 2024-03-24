%%
clear; close all; clc;
%% calculate land energy level from radar image
flist = dir([pwd '/PNG/*.png']);

%%%
sdrng = 800; %[m]
dr = 3; %[m]
nr = 512;
mdeg = 29;% modification factor for north correction

rr = sdrng:dr:sdrng+dr*(nr-1);

nimg = 128;
nbearing = 1080;
%%%

land1 = zeros(length(flist), 3);
land2 = zeros(length(flist), 3);
land3 = zeros(length(flist), 3);
sea = zeros(length(flist), 3);
all = zeros(length(flist), 3);


for ii = 1:length(flist)
    pngname= [pwd, '/PNG/', flist(ii).name];

    data = imread(pngname);
    data = data(1:nr*nbearing*nimg);
    data = reshape(data,nr,nbearing,nimg);
    data = flip(data,3);

    means1 = mean(data(:, 691:723, :), [1, 2]);
    land1(ii, 1) = max(means1);
    land1(ii, 2) = mean(means1);
    land1(ii, 3) = min(means1);

    means2 = mean(data(:, 168:215, :), [1, 2]);
    land2(ii, 1) = max(means2);
    land2(ii, 2) = mean(means2);
    land2(ii, 3) = min(means2);


    means3 = mean(data(:, [168:215, 691:723], :), [1, 2]);
    land3(ii, 1) = max(means3);
    land3(ii, 2) = mean(means3);
    land3(ii, 3) = min(means3);

    means4 = mean(data(:, [1:167, 724:1080], :), [1, 2]);
    sea(ii, 1) = max(means4);
    sea(ii, 2) = mean(means4);
    sea(ii, 3) = min(means4);

    means5 = mean(data(:, [1:215, 691:1080], :), [1, 2]);
    all(ii, 1) = max(means5);
    all(ii, 2) = mean(means5);
    all(ii, 3) = min(means5);

    disp((ii/length(flist))*100)
end

save land_energy_new land1 land2 land3 sea all