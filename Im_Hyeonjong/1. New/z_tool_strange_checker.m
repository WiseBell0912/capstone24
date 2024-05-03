%% 알고리즘 이상치 확인 스크립트

clear; close all; clc;

ANN_name = 'ANN_2024_04_23_03_48';

%% radar 데이터 로드 및 처리

% wave parameter
load([pwd '/2. Data/Wave Parameter/wave_parameter_combined.mat']);
% land energy
load([pwd '/2. Data/Land energy/land_energy_combined_normalized.mat']);
% land TF
load([pwd '/2. Data/Land TF/land_TF_combined_std_1.mat']);

plot_radar_date = radar_date;

%% 데이터 가공 step 1. (이동 평균, 지역 최대/최소)
% 전향 3점 이동 평균 : 1점 = 10분
% 전향 36점 지역 최대/최소 : 36점 = 360분 = 6시간

local_duration = 36;

% ------ land energy
% avg
radar_land_energy_avg = movmean(radar_land_energy, [2 0], 'omitnan');
% max
radar_land_energy_max = zeros(size(radar_land_energy_avg));
for i = local_duration + 1 : length(radar_land_energy_avg)
    radar_land_energy_max(i) = max(radar_land_energy_avg(i - local_duration : i));
end
% min
radar_land_energy_min = zeros(size(radar_land_energy_avg));
for i = local_duration + 1 : length(radar_land_energy_avg)
    radar_land_energy_min(i) = min(radar_land_energy_avg(i - local_duration : i));
end

% ------ land TF

% ------ noise
% avg
radar_noise_avg = movmean(radar_noise, [2 0], 'omitnan');
% max
radar_noise_max = zeros(size(radar_noise_avg));
for i = local_duration + 1 : length(radar_noise_avg)
    radar_noise_max(i) = max(radar_noise_avg(i - local_duration : i));
end
% min
radar_noise_min = zeros(size(radar_noise_avg));
for i = local_duration + 1 : length(radar_noise_avg)
    radar_noise_min(i) = min(radar_noise_avg(i - local_duration : i));
end

% ------ Pdir
% avg
radar_Pdir_avg = movmean(radar_Pdir, [2 0], 'omitnan');
% max
radar_Pdir_max = zeros(size(radar_Pdir_avg));
for i = local_duration + 1 : length(radar_Pdir_avg)
    radar_Pdir_max(i) = max(radar_Pdir_avg(i - local_duration : i));
end
% min
radar_Pdir_min = zeros(size(radar_Pdir_avg));
for i = local_duration + 1 : length(radar_Pdir_avg)
    radar_Pdir_min(i) = min(radar_Pdir_avg(i - local_duration : i));
end

% ------ signal
% avg
radar_signal_avg = movmean(radar_signal, [2 0], 'omitnan');
% max
radar_signal_max = zeros(size(radar_signal_avg));
for i = local_duration + 1 : length(radar_signal_avg)
    radar_signal_max(i) = max(radar_signal_avg(i - local_duration : i));
end
% min
radar_signal_min = zeros(size(radar_signal_avg));
for i = local_duration + 1 : length(radar_signal_avg)
    radar_signal_min(i) = min(radar_signal_avg(i - local_duration : i));
end

% ------ SNR
% avg
radar_SNR_avg = movmean(radar_SNR, [2 0], 'omitnan');
% max
radar_SNR_max = zeros(size(radar_SNR_avg));
for i = local_duration + 1 : length(radar_SNR_avg)
    radar_SNR_max(i) = max(radar_SNR_avg(i - local_duration : i));
end
% min
radar_SNR_min = zeros(size(radar_SNR_avg));
for i = local_duration + 1 : length(radar_SNR_avg)
    radar_SNR_min(i) = min(radar_SNR_avg(i - local_duration : i));
end

% ------ Tp
% avg
radar_Tp_avg = movmean(radar_Tp, [2 0], 'omitnan');
% max
radar_Tp_max = zeros(size(radar_Tp_avg));
for i = local_duration + 1 : length(radar_Tp_avg)
    radar_Tp_max(i) = max(radar_Tp_avg(i - local_duration : i));
end
% min
radar_Tp_min = zeros(size(radar_Tp_avg));
for i = local_duration + 1 : length(radar_Tp_avg)
    radar_Tp_min(i) = min(radar_Tp_avg(i - local_duration : i));
end


%% 데이터 가공 step 2.

idx_last = length(radar_date);
idx1 = [1:idx_last];
idx2 = [1, 1:idx_last-1];
idx3 = [1, 1, 1:idx_last-2];

ANN_INPUT_DATA = [
    radar_land_energy(idx1) ; radar_land_energy(idx2) ; radar_land_energy(idx3) ;
    radar_land_energy_max(idx1) ; radar_land_energy_max(idx2) ; radar_land_energy_max(idx3) ;
    radar_land_energy_min(idx1) ; radar_land_energy_min(idx2) ; radar_land_energy_min(idx3) ;

    radar_land_TF(idx1) ; radar_land_TF(idx2) ; radar_land_TF(idx3) ;
    
    radar_noise(idx1) ; radar_noise(idx2) ; radar_noise(idx3) ;
    radar_noise_max(idx1) ; radar_noise_max(idx2) ; radar_noise_max(idx3) ;
    radar_noise_min(idx1) ; radar_noise_min(idx2) ; radar_noise_min(idx3) ;

    radar_Pdir(idx1) ; radar_Pdir(idx2) ; radar_Pdir(idx3) ;
    radar_Pdir_max(idx1) ; radar_Pdir_max(idx2) ; radar_Pdir_max(idx3) ;
    radar_Pdir_min(idx1) ; radar_Pdir_min(idx2) ; radar_Pdir_min(idx3) ;

    radar_signal(idx1) ; radar_signal(idx2) ; radar_signal(idx3) ;
    radar_signal_max(idx1) ; radar_signal_max(idx2) ; radar_signal_max(idx3) ;
    radar_signal_min(idx1) ; radar_signal_min(idx2) ; radar_signal_min(idx3) ;

    radar_SNR(idx1) ; radar_SNR(idx2) ; radar_SNR(idx3) ;
    radar_SNR_max(idx1) ; radar_SNR_max(idx2) ; radar_SNR_max(idx3) ;
    radar_SNR_min(idx1) ; radar_SNR_min(idx2) ; radar_SNR_min(idx3) ;

    radar_Tp(idx1) ; radar_Tp(idx2) ; radar_Tp(idx3) ;
    radar_Tp_max(idx1) ; radar_Tp_max(idx2) ; radar_Tp_max(idx3) ;
    radar_Tp_min(idx1) ; radar_Tp_min(idx2) ; radar_Tp_min(idx3) ;
    ];

clear i idx1 idx2 idx3 idx_last local_duration


%% 알고리즘 불러오기

load([pwd '/4. Result/' ANN_name '/', ANN_name, '.mat']);


%% 알고리즘 수행

ANN_RESULT = zeros(100, size(ANN_INPUT_DATA, 2));

for i = 1 : 100
    
    for ii = 1 : size(ANN_INPUT_DATA, 2)
        preprocess_input(:, ii) = gain_input{i} .* (ANN_INPUT_DATA(:, ii) - offset_input{i}) - 1;
    end

    for ii = 1 : size(preprocess_input, 2)
        weighted_input = hidden_weight{i} * preprocess_input(:, ii) + hidden_bias{i};
        actvation_function = 2 ./ (1 + exp(-2 * weighted_input)) - 1;
        weighted_output{i}(ii) = output_weight{i} * actvation_function + output_bias{i};
    end

    ANN_RESULT(i, :) = (weighted_output{i} + 1) / gain_output{i} + offset_output{i};
    disp(i);

end

plot_ANN_RESULT_FINAL = mean(ANN_RESULT, 1);


%% 부이 데이터 로드

load([pwd '/2. Data/Bouy/bouy_Hs_2019_2023_combined_movmeaned.mat']);

plot_bouy_date = bouy_date;
plot_bouy_Hs = bouy_Hs;
plot_bouy_Hs_interpol = interp1(plot_bouy_date, plot_bouy_Hs, plot_radar_date, 'linear');


%% 데이터 정리

clearvars -except plot_radar_date plot_ANN_RESULT_FINAL plot_bouy_date plot_bouy_Hs plot_bouy_Hs_interpol ANN_name


%% 이상치 탐색

clear strange_date

count = 0;
for i = 1 : length(plot_radar_date)
    if abs(plot_bouy_Hs_interpol(i) - plot_ANN_RESULT_FINAL(i)) > 0.3
        count = count + 1;
        strange_date(count) = plot_radar_date(i);
    end
end

strange_date = strange_date';

%%