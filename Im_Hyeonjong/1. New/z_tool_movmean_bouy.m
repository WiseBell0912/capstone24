%% bouy 데이터를 취합하고 11점 평균
clear; close all; clc;

load("2. Data\Bouy\bouy_Hs_2019.mat");
bouy_date = date;
bouy_Hs = Hs;

load("2. Data\Bouy\bouy_Hs_2020.mat");
bouy_date = [bouy_date date];
bouy_Hs = [bouy_Hs Hs];

load("2. Data\Bouy\bouy_Hs_2021.mat");
bouy_date = [bouy_date date];
bouy_Hs = [bouy_Hs Hs];

load("2. Data\Bouy\bouy_Hs_2022.mat");
bouy_date = [bouy_date date];
bouy_Hs = [bouy_Hs Hs];

load("2. Data\Bouy\bouy_Hs_2023_01.mat");
bouy_date = [bouy_date date];
bouy_Hs = [bouy_Hs Hs];

load("2. Data\Bouy\bouy_Hs_2023_02.mat");
bouy_date = [bouy_date date];
bouy_Hs = [bouy_Hs Hs];

load("2. Data\Bouy\bouy_Hs_2023_03.mat");
bouy_date = [bouy_date date];
bouy_Hs = [bouy_Hs Hs];

load("2. Data\Bouy\bouy_Hs_2023_04.mat"); % 4월 6일이 두 번 기록됨.
bouy_date = [bouy_date date([1:1440, 1729:end])];
bouy_Hs = [bouy_Hs Hs([1:1440, 1729:end])];

load("2. Data\Bouy\bouy_Hs_2023_05.mat");
bouy_date = [bouy_date date];
bouy_Hs = [bouy_Hs Hs];

load("2. Data\Bouy\bouy_Hs_2023_06.mat");
bouy_date = [bouy_date date];
bouy_Hs = [bouy_Hs Hs];

load("2. Data\Bouy\bouy_Hs_2023_07.mat");
bouy_date = [bouy_date date];
bouy_Hs = [bouy_Hs Hs];

%% plot original ver.
figure(1);
plot(bouy_date, bouy_Hs);

%% moving average
bouy_Hs = movmean(bouy_Hs, 11, 'omitnan');

%% plot moving average ver.
figure(2);
plot(bouy_date, bouy_Hs);

%% 저장
save bouy_Hs_2018_2023_combined_movmeaned bouy_date bouy_Hs;