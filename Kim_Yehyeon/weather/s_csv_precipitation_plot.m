clc; clear; close all;
%% 
% read precipitation csv data from file directory below
% Extract only the information related to dates and precipitation amount
% 524 is the code of 'Gangmoon' weather station
% this code is similar to s_rain_read code but this code is for plot the
% precipitation change

%%
fdir = '/Users/kimyehyun/Documents/Thousand/PRI/Weather/rain/';
flist = dir([fdir '*.csv']);
fsize = size(flist);

for ii = 1:fsize(:,1)
    weather = readmatrix(sprintf("%s/%s", flist(ii).folder, flist(ii).name), 'OutputType','string');
    rainidx = find(weather(:, 1) == '524');
    precipiation = weather(rainidx, [3, 5]);
    precipiation(:, 1) = datetime(precipiation(:, 1), 'InputFormat','yyyy-MM-dd HH:mm', 'Format', 'yyyy-MM-dd HH:00');
    x_date = datetime(precipiation(:, 1));
    y_precipitation = double(precipiation(:, 2));

    figure(ii)
    plot(x_date, y_precipitation)
    xlim([datetime('2019-04-01') datetime('2019-05-31')])
    ylim([0 2]);
    grid on;
end



