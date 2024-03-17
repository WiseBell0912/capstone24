clc; clear; close all;

fdir = '/Users/kimyehyun/Documents/Thousand/PRI/Weather/rain/';
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

save('rain.mat', 'new');