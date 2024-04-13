%% land energy 를 plot 하는 스크립트
clear; close all; clc;

%% land energy 로드
load("2. Data/Land energy/land_energy_combined.mat");

%% plot
figure(1);
plot(radar_date, radar_land_energy);