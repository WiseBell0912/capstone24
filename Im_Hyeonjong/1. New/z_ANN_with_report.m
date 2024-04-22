%% 인공 신경망을 사용한 유의파고 추정 스크립트

clear; close all; clc;


%% radar 데이터 로드 및 처리

% wave parameter
load([pwd '/2. Data/Wave Parameter/wave_parameter_1907_2012.mat']);
% land energy
load([pwd '/2. Data/Land energy/land_energy_1907_2012_normalized.mat']);
% land TF
load([pwd '/2. Data/Land TF/land_TF_1907_2012_std_1.mat']);


%% bouy 데이터 로드 및 처리

% bouy Hs
load([pwd '/2. Data/Bouy/bouy_Hs_1907_2012_movmeaned.mat']);

% radar 와 기간을 맞추기 위해 보간
bouy_Hs_interpol = interp1(bouy_date, bouy_Hs, radar_date, 'linear');


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


%% 데이터 가공 step 3.

step3_radar_date_num = datenum(radar_date);

step3_local_period = 0.5;
step3_local_step = step3_radar_date_num(2) - step3_radar_date_num(1);
step3_local_count = ceil(step3_local_period / step3_local_step);
step3_total_count = floor(length(step3_radar_date_num) / step3_local_count);
step3_checker = false(size(step3_radar_date_num));

for i = 1 : step3_total_count
    step3_idx = (i - 1) * step3_local_count + 1 : i * step3_local_count;
    step3_temp = bouy_Hs_interpol(step3_idx);
    [step3_temp_max step3_idx_max] = max(step3_temp);
    [step3_temp_min step3_idx_min] = min(step3_temp);
    step3_checker([ (i-1)*step3_local_count+step3_idx_max , (i-1)*step3_local_count+step3_idx_min ]) = true;
end

clear i step3_idx step3_idx_max step3_idx_min step3_local_count step3_local_period step3_local_step step3_radar_date_num step3_temp step3_temp_max step3_temp_min step3_total_count


%% ANN 훈련

Neuron_hidden = 12;
net = 0;
NMT = 100;

ANN_TRAINING_INPUT = ANN_INPUT_DATA(:, step3_checker);
ANN_TRAINING_OUTPUT = bouy_Hs_interpol(:, step3_checker);

for i = 1 : NMT
   net = feedforwardnet(Neuron_hidden);
   net = initlay(net);

   net.divideFcn = 'dividerand';
   net.divideParam.trainRatio = 0.7;
   net.divideParam.valRatio = 0.15;
   net.divideParam.testRatio = 0.15;

   net.trainFcn = 'trainlm';

   net.trainParam.epochs = 1000;

   net = train(net, ANN_TRAINING_INPUT, ANN_TRAINING_OUTPUT, 'useGPU', 'no');

   hidden_weight{i} = net.IW{1};
   output_weight{i} = net.LW{2};
   
   hidden_bias{i} = net.b{1};
   output_bias{i} = net.b{2};

   gain_input{i} = net.input.processSettings{1}.gain;
   offset_input{i} = net.input.processSettings{1}.xoffset;

   gain_output{i} = net.output.processSettings{1}.gain;
   offset_output{i} = net.output.processSettings{1}.xoffset;

   clear net;
   
   disp('training'); disp(i);
end


%% ANN 시뮬레이션

ANN_RESULT = zeros(NMT, size(ANN_INPUT_DATA, 2));

for i = 1 : NMT
    
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


%% 작업 공간 정리

clear actvation_function i ii Neuron_hidden NMT preprocess_input step3_checker


%% 결과 저장

ANN_RESULT_FINAL = mean(ANN_RESULT, 1);

save ANN_2024_04_23_03_48.mat ...
    hidden_weight hidden_bias ...
    output_weight output_bias ...
    gain_input gain_output ...
    offset_input offset_output ...
    bouy_date ...
    bouy_Hs ...
    radar_date ...
    bouy_Hs_interpol ...
    ANN_RESULT_FINAL;


%% 결과 비교 (년도별)

for year = 2019:2023
    figure(1);
    set(gcf, 'position', [0 0 1800 900])
    hold on;

    % Radar Hs 
    a1 = plot(radar_date, ANN_RESULT_FINAL, 'r-', 'LineWidth', 1);
    a1.Color(4) = 0.5;
    % Bouy Hs
    a2 = plot(bouy_date, bouy_Hs, 'b-', 'LineWidth', 1);
    a2.Color(4) = 0.5;
    % 속성
    title('Significant Wave Height (Hs)', 'FontSize', 15);
    xlabel('Date [mm/dd]', 'FontSize', 13);
    ylabel('Hs [m]', 'FontSize', 13);
    legend('RADAR', 'BOUY', 'Location', 'northeast');
    grid on;
    % 부분만 보기
    xlim([datetime(year, 1, 1) datetime(year, 12, 31)]);
    ylim([0, 7]);

    hold off;

    name = [num2str(year) '_0.png'];
    saveas(gcf,name);
end

%% 결과 비교 (월별)

for year = 2019:2023
    for month = 1 : 12
        figure(1);
        set(gcf, 'position', [0 0 1800 900])
        hold on;

        % Radar Hs 
        a1 = plot(radar_date, ANN_RESULT_FINAL, 'r-', 'LineWidth', 1);
        a1.Color(4) = 0.5;
        % Bouy Hs
        a2 = plot(bouy_date, bouy_Hs, 'b-', 'LineWidth', 1);
        a2.Color(4) = 0.5;
        % 속성
        title('Significant Wave Height (Hs)', 'FontSize', 15);
        xlabel('Date [mm/dd]', 'FontSize', 13);
        ylabel('Hs [m]', 'FontSize', 13);
        legend('RADAR', 'BOUY', 'Location', 'northeast');
        grid on;
        % 부분만 보기
        xlim([datetime(year, month, 1) datetime(year, month, 31)]);
        ylim([0, 7]);

        hold off;

        name = [num2str(year) '_' num2str(month) '.png'];
        saveas(gcf,name);
    end
end

%% 오차 확인

figure(2);
set(gcf, 'position', [0 0 900 900])
hold on;

% Radar vs Bouy
b1 = plot(ANN_RESULT_FINAL, bouy_Hs_interpol, '.', 'MarkerSize', 0.3);
% 비교 선
b2 = plot([0, 10], [0, 10], 'r-');
b2.Color(4) = 0.5;
b3 = plot([0, 10], [-1, 9], 'r--');
b3.Color(4) = 0.5;
b4 = plot([0, 10], [1, 11], 'r--');
b4.Color(4) = 0.5;
legend('error', 'X = Y', '1m error', 'Location', 'southeast');
% 속성
title('Error of ANN, R^2 = 0.901', 'FontSize', 15);
xlabel('Radar Hs [m]', 'FontSize', 13);
ylabel('Bouy Hs [m]', 'FontSize', 13);
% 부분만 보기
xlim([0, 6]);
ylim([0, 6]);
% 오차 수치
text(4.9, 0.8, ['1.0m error : 0.251%' newline '0.5m error : 1.710%']);

saveas(gcf, 'error.png');


%% 오차 수치화

error = ANN_RESULT_FINAL - bouy_Hs_interpol;
% + - 1m error
count = 0;
for i = 1 : length(error)
    if error(i) < -1 || 1 < error(i)
        count = count + 1;
    end
end
error_persentage = count / length(error) * 100;
disp('+ - 1m error'); disp(error_persentage);
% + - 0.5m error
count = 0;
for i = 1 : length(error)
    if error(i) < -0.5 || 0.5 < error(i)
        count = count + 1;
    end
end
error_persentage = count / length(error) * 100;
disp('+ - 0.5m error'); disp(error_persentage);


%% 결정 계수

% 임의의 관측값과 예측값 예제
y_obs = bouy_Hs_interpol;
y_pred = ANN_RESULT_FINAL;

% 결정계수 계산
R_squared = calculateR2(y_obs, y_pred);
fprintf('결정계수(R^2): %.3f\n', R_squared);

function R2 = calculateR2(y_obs, y_pred)
    % y_obs : 관측된 데이터
    % y_pred : 모델에 의해 예측된 데이터
    
    % 잔차 제곱합 (SSE)
    residuals = y_obs - y_pred;
    SSE = sum(residuals.^2, 'omitnan');
    
    % 총 변동 (SST)
    mean_y_obs = mean(y_obs, 'omitnan');
    SST = sum((y_obs - mean_y_obs).^2, 'omitnan');
    
    % 결정계수 (R-squared)
    R2 = 1 - SSE/SST;
end


