%%
clear; close all; clc;
%% Transform land energy level to logical form by interpolation
load land_energy_level_avg.mat
load([pwd, '\train_data\ANN_radar_out_20_3q_200905.mat']);
% wabs : 풍속 절대값 평균 / wspd_new : 풍속 벡터 평균 / wdir_new : 풍향 벡터 평균 
% wdir_only : 풍향만 평균  /// 모든 평균은 (계측 시작으로부터) 3분 동안 평균한 것

energy_tr = interp1(energy_time, energy_level(:, 4), set_date,'linear');

energy_logic = logical(energy_tr >= 110.1974);

energy_time = energy_time';