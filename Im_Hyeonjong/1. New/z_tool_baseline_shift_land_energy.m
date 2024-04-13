%% land energy 를 baseline shift normalization 하는 스크립트
clear; close all; clc;

%% land energy 로드
load("2. Data/Land energy/land_energy_combined.mat");

%% plot
figure(1);
plot(radar_date, radar_land_energy);

%% 구간 확인

% 2019-07-01 00:00 ~ 2020-09-05 12:00
% mean : 105.6318
% index : from 1 to 61909

% 2020-09-17 23:50 ~ 2020-11-30 10:20
% mean : 53.7978
% index : from 61910 to 72459

% 2020-11-30 10:30 ~ 2021-06-05 15:00
% mean : 54.0131
% index : from 72460 to 99354

% 2021-06-05 15:10 ~ 2022-04-14 16:10
% mean : 62.1455
% index : from 99355 to 144389

% 2022-04-22 16:10 ~ 2022-07-19 04:00
% mean : 54.5253
% index : from 144390 to 156977

% 2022-07-31 17:50 ~ 2022-08-10 11:10
% mean : 62.0401
% index : from 156978 to 158374

% 2022-08-11 15:10 ~ 2023-01-14 03:40
% mean : 53.6993
% index : from 158375 to 180726

% 2023-01-17 10:30 ~ 2023-06-01 18:30
% mean : 62.3326
% index : from 180727 to 200179

% 2023-06-01 19:10 ~ 2023-07-01 00:00
% mean : 54.0041
% index : from 200180 to end
