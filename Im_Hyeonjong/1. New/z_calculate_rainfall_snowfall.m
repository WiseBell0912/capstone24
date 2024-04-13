%% 강우/강설 여부를 논리형으로 판단하는 스크립트 (강우/강설:1, 아닐시:0)
clear; close all; clc;

%% 강우/강설 여부를 판단할 데이터 로드
load();

%% 평균, 표준편차 도출
land_energy_mean = mean();
land_energy_std_dev = std();

%% 강우/강설 여부 판단 (평균 + 1 표준편차 이상이면 강우/강설)
land__rainfall_snowfall = false(size());

for i = 1 : length()
    if 
end