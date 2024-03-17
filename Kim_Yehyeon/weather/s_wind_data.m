clear; close all; clc;
%%

fdir = '/Users/kimyehyun/Documents/thousand/PRI/wind/';
flist = dir([fdir '*.csv']);
fsize = size(flist);

wind = [];

for ii = 1:fsize
    raw = readmatrix(sprintf("%s/%s", flist(ii).folder, flist(ii).name), 'OutputType','string');
    wind = [wind; raw];
end

%% pol2cart X,Y 
% [x, y] = pol2cart(deg2rad(double(wind(:, 6))), double(wind(:, 7)));
% windsp = [x, y];
% 
% windsp(:, 1) = movingA(windsp(:, 1), 60);
% windsp(:, 2) = movingA(windsp(:, 2), 60);

%% Only magnitude

windsp(:, 1) = datenum(datetime(wind(:, 2), "InputFormat", "yyyy-MM-dd HH:mm", 'Format','default'));
windsp(:, 2) = double(wind(:, 6));
windsp(:, 3) = double(wind(:, 7));

save wind_data_230712.mat windsp