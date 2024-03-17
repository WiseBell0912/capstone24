clc; clear; close all;

fdir = '/Users/kimyehyun/Documents/Thousand/PRI/Weather/snow/';
flist = dir([fdir '*.csv']);

fsize = size(flist);
new = [];

for ii = 1: fsize(:,1)
    weather = readmatrix(sprintf("%s/%s", flist(ii).folder, flist(ii).name), 'OutputType','string');
    snowidx = find(weather(:, 1) == '104' & double(weather(:, 6)) > 0);
    weather = weather(snowidx, [3, 6]);
    new = vertcat(new, weather);
end

new(:, 1) = datetime(new(:, 1), 'InputFormat','yyyy-MM-dd HH:mm', 'Format', 'yyyyMMdd_HH');

save('snow.mat', 'new');