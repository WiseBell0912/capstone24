clear; close all; clc;
%% calculate energy level from radar image
flist = dir('/Volumes/LAB Thousand HDD3/PNG2019/*.png');

means = zeros(length(flist), 2);

% 2068이 2019년의 시작
for ii = 1:length(flist)
    pngname= ['/Volumes/LAB Thousand HDD3/PNG2019/', flist(ii).name];
    rdata = imread(pngname);
    mdata = mean(rdata, 'all');
    date = datetime(flist(ii).name(5:17), 'InputFormat', 'yyyyMMdd_HHmm', 'Format', 'yyyyMMddHHmm');
    means(ii, 1) = datenum(date);
    means(ii, 2) = mdata;
    disp(ii)
end

save energy_level means
%% get precipitation from csv file
% fdir = '/Users/kimyehyun/Documents/Thousand/PRI/Weather/rain/';
fdir = '/Users/kimyehyun/Documents/Thousand/PRI/Weather/sangsi/';
flist = dir([fdir '*.csv']);
fsize = size(flist);
new = [];

for ii = 1:fsize(:,1)
    weather = readmatrix(sprintf("%s/%s", flist(ii).folder, flist(ii).name), 'OutputType','string');
    precipitation = weather(:, [2, 5]);
    precipitation(:, 1) = datetime(precipitation(:, 1), 'InputFormat','yyyy-MM-dd HH:mm', 'Format', 'yyyy-MM-dd HH:mm');
    new = vertcat(new, precipitation);

end
precipi = new;

save sangsi_precipitation precipi
%% get precipitation from csv file
% fdir = '/Users/kimyehyun/Documents/Thousand/PRI/Weather/rain/';
fdir = '/Users/kimyehyun/Documents/Thousand/PRI/Weather/rain/';
flist = dir([fdir '*.csv']);
fsize = size(flist);
new2 = [];

for ii = 1:fsize(:,1)
    weather = readmatrix(sprintf("%s/%s", flist(ii).folder, flist(ii).name), 'OutputType','string');
    rainidx = find(weather(:, 1) == '524');
    precipitation = weather(rainidx, [3, 5]);
    precipitation(:, 1) = datetime(precipitation(:, 1), 'InputFormat','yyyy-MM-dd HH:mm', 'Format', 'yyyy-MM-dd HH:mm');
    new2 = vertcat(new2, precipitation);

end
precipi = new2;

save gangmun_precipitation precipi
%% compare precipitation and energy level
% load energy_level.mat
% load sangsi_precipitation.mat
load gangmun_precipitation.mat

x_date = datetime(precipi(:, 1));
y_precipitation = double(precipi(:, 2));
y_precipitation = rescale(y_precipitation, 0, 2);

time = datetime(means(7200:end, 1),'ConvertFrom', 'datenum');
energy = means(7200:end, 2);
energy = rescale(energy, 0, 1);

figure(1)
plot(x_date, y_precipitation, 'r-')
xlim([datetime('2019-06-18') datetime('2019-08-18')])
ylim([-0.5 2]);
set(gca,'fontsize',13)
xlabel('Date [mm/dd]','fontsize',13);
ylabel('Precipitation','fontsize',13);
title(['precipitation energy level comparison']);
grid on;
hold on;
plot(time, energy-0.05, 'k-')
legend('Precipitation','Energy level(Sea)')


exportgraphics(gcf,'Comparison between precipitation and energy level.png','Resolution',300)
%%
% load('energy_level.mat');
% load('land_energy_level_2019.mat')
load('land_energy_level_avg.mat')
% means_2019 = means;
% load('land_energy_level_2020.mat')
% means_2020 = means;
% means_2020(:,4) = means_2020(:, 2) + means_2020(:, 3);
% 
% means = [means_2019; means_2020];

load gangmun_precipitation.mat
% load sangsi_precipitation.mat

x_date = datetime(precipi(:, 1));
y_precipitation = double(precipi(:, 2));
y_precipitation = rescale(y_precipitation, 0, 2);


time = datetime(energy_level(:,1),'ConvertFrom', 'datenum');


energy = energy_level(:, 4);

% energy = energy - movingA(energy, 1440);

energy = rescale(energy, 0, 1);
x = 1:2;
y = 1:2;

figure(1)
% plot(x_date, y_precipitation, 'r-')
plot(time, aa-0.3, 'k-')
xlim([datetime('2020-04-01') datetime('2020-06-30')])
hold on;
plot(x, y, 'r-')
ylim([0 0.4]);
set(gca,'fontsize',13)
set(gcf,'position', [500 500 1300 600])
xlabel('Date[yy-mm-dd]','fontsize',13);
ylabel('energy level','fontsize',13);
ax = gca;
ax.LineWidth = 1.5;
title(['energy level compare with rainny day'], 'FontSize',18);
xtickformat('yy-MM-dd')
grid off;
hold on;

legend('Energy level(Land)', 'rainny day')
exportgraphics(gcf,'Comparison between precipitation and land energy level_new.png','Resolution',600)
% saveas(gcf,'Comparison between precipitation and land energy level.png')
