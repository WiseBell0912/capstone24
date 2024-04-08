%% Land energy level 을 계산하는 스크립트

clear; close all; clc

%% pngLong 을 읽어드림
pngLong = imread([pwd, '/PNG/AIB_20190702_1940.png']);

%% 초기 설정
rad_point = 512;
arc_point = 1080;
time_point = 128;

%% 이미지 변환
pngLong = pngLong(1 : rad_point * arc_point * time_point);
pngLong = reshape(pngLong, rad_point, arc_point, time_point);
pngLong = flip(pngLong, 3);

pngLong_land = pngLong(:, [168:215, 691:723], :);

%% Land energy level 계산
land_energy_level = pngLong_land;
land_energy_level = mean(land_energy_level);
land_energy_level = mean(land_energy_level);
land_energy_level = mean(land_energy_level);

%% 결과
disp(land_energy_level);