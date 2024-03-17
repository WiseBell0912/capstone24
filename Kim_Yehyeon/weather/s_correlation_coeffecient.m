clear; close all; clc;

load land_energy_new.mat
load gangmun_precipitation.mat

%%
x = energy_level(:, 4);

% histogram(x)
pd = fitdist(x,'Normal');
% mu+sigmax

x_pdf = 1:0.1:200;
y = pdf(pd,x_pdf);
%  
figure
fitdist(x, 'Normal')

histogram(x,'Normalization','pdf')

set(gca,'fontsize',13)
xlabel('Energy level','fontsize',13);
ylabel('Frequancy','fontsize',13);
title(['Histgram of energy level']);
xlim([90 150])
% exportgraphics(gcf,'Histogram of energy level.png','Resolution',300)
line(x_pdf,y)
%%
energy_avg = mean(energy_level(:, 4));

means_above = energy_level(:, 4) > energy_avg;
pre_time = datetime(precipi(:, 1));
pre_ = double(precipi(:, 2)) > 0;


hold on
scatter(energy_time, means_above, 'marker', '.')
scatter(pre_time, pre_)
ylim([-1 2]);
xlim([datetime('2019-04-01') datetime('2019-04-05')])
legend('energy','precipitation')

%%
% energy_avg = 109.5;
% means_avg = 114.6078;
energy_avg = 110.1974;

means_above = energy_level(:, 4) > energy_avg;
pre_time = datetime(precipi(:, 1));
pre_ = double(precipi(:, 2)) > 0;


hold on
scatter(energy_time, means_above, 'marker', '.', 'markeredgecolor','k')
scatter(pre_time, pre_, 'marker', 'O', 'markeredgecolor', 'r')
ylim([-0.5 1.5]);
xlim([datetime('2019-09-19') datetime('2019-10-04')])
set(gca,'fontsize',13)
xlabel('Date [mm/dd]','fontsize',13);
ylabel('Rain(Logical)','fontsize',13);
title(['Rainny date']);

legend('energy level','precipitation')
exportgraphics(gcf,'Rainny day.png','Resolution',300)


% 강우시의 MAX/MIN
% 비강우시의 MAX/MIN
% 평균의 업데이트 

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


energy = energy_level(:, 2);
energy = rescale(energy, 0, 1);

figure(1)
plot(x_date, y_precipitation)
xlim([datetime('2019-01-01') datetime('2019-12-31')])
ylim([-2 5]);
grid on;
hold on;
plot(time, energy)

% means_avg = 114.6078;
% means_above = means(:, 4) > means_avg;
% pre_time = datetime(precipi(:, 1));
% pre_ = double(precipi(:, 2)) > 0;
% 
% 
% hold on
% scatter(time, means_above, 'marker', '.')
% scatter(pre_time, pre_)

%%
% energy_avg = 109.5;
% means_avg = 114.6078;
energy_avg = 0.0102+4.2884;


load('land_energy_level_avg.mat')

energy_level(:, 4) = energy_level(:, 4) - movingA(energy_level(:, 4), 1440);

mean(energy_level(:, 4))
std(energy_level(:, 4))

pd = fitdist(energy_level(:, 4),'Normal');

means_above = energy_level(:, 4) > energy_avg;
pre_time = datetime(precipi(:, 1));
pre_ = double(precipi(:, 2)) > 0;


hold on
scatter(energy_time, means_above, 'marker', '.', 'markeredgecolor','k')
scatter(pre_time, pre_, 'marker', 'O', 'markeredgecolor', 'r')
ylim([-0.5 1.5]);
xlim([datetime('2020-04-01') datetime('2020-08-31')])
set(gcf,'position', [500 500 1300 600])
set(gca,'fontsize',13)
xlabel('Date','fontsize',13);
ylabel('Rain(Logical)','fontsize',13);
title(['Rainny date']);

legend('energy level','precipitation')
exportgraphics(gcf,'Rainny day.png','Resolution',300)


% 강우시의 MAX/MIN
% 비강우시의 MAX/MIN
% 평균의 업데이트 