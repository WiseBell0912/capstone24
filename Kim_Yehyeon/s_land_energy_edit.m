clear; close all; clc;
%%
% overall mean 49.9973, 52.4464 102.4237

% Dec 10 2019 1420 - end
% 40029 - end
% mean 50.6238 53.4742 104.0980

% Jun 12 2019 1500 - Dec 10 2019 1410 above
% 14175 - 40028
% mean 59.4873 60.9884 120.4757 

% Mar 11 2019 1406 - Jun 11 2019 1920 below
% 7063 - 14174
% mean 52.1382 54.1248 106.2630

%%%%%%%%%%%

% Dec 27 2018 1600 - Mar 11 2019 1405 below
% 1757 - 7062

% Nov 26 2018 1140 - Dec 26 2018 1100 below

load land_energy_level_2018_2020.mat

energy_level(14175:40028, 2) = energy_level(14175:40028, 2) - (59.4873 - (50.6238+52.1382)/2);
energy_level(14175:40028, 3) = energy_level(14175:40028, 3) - (60.9884 - (53.4742+54.1248)/2);
energy_level(14175:40028, 4) = energy_level(14175:40028, 4) - (120.4757 - (104.0980+106.2630)/2);

energy_level = energy_level(7063:end, :);
energy_time = energy_time(7063:end);


%%
save land_energy_level_avg energy_level energy_time

%%
load land_energy_new.mat