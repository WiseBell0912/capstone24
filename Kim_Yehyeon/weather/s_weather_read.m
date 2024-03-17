clc; clear; close all;
%%
% A script that extracts the dates and precipitation amounts 
% from weather data only for days with precipitation and saves them.

fdir = '/Users/kimyehyun/Documents/Thousand/PRI/Weather/';
flist = dir([fdir '*.csv']);

fsize = size(flist);
new = [];

for ii = 1: fsize(:,1)
    weather = readmatrix(sprintf("%s/%s", flist(ii).folder, flist(ii).name), 'OutputType','string');
    rainidx = find(weather(:, 1) == '524' & double(weather(:, 5)) > 0);
    weather = weather(rainidx, [3, 5]);
    new = vertcat(new, weather);
end

new(:, 1) = datetime(new(:, 1), 'InputFormat','yyyy-MM-dd HH:mm', 'Format', 'yyyyMMdd_HH');

save('weather.mat', 'new');