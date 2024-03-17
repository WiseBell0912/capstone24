clear; close all; clc;
% 2024/03/05 15:12 수정


%% 레이더 결과 가져오기
% 2018.11.23 19:20 ~ 2019.07.01 00:00 (20 min)
% 2019.07.01 00:00 ~ 2020.09.05 12:00 (10 min)

load([pwd, '/Radar/ANN_radar_out_20_3q_200905.mat']);
% set_date --> yyyy-mm-dd hh:mm:ss
% enoise_1st --> Noise
% esig_1st --> Signal
% snr_1st --> SNR
% tpMs --> Peak period
% pdir_1st --> Wave direction
% wspd_new --> Wind

radar_date_datetime = set_date;
radar_date_double = datenum(radar_date_datetime);

radar_noise = enoise_1st;
radar_signal = esig_1st;
radar_SNR = snr_1st;
radar_Tp = tpMS;
radar_Pdir = pdir_1st;
radar_wind = wspd_new;

clear enoise_1st esig_1st snr_1st tpMS pdir_1st wspd_new set_date;


%% 경포대 부이 결과 가져오기
% 2018.11.23 00:00 ~ 2020.09.30 23:50 (10 min)

load([pwd, '/DATA/Bouy/bouy_201811to202009.mat']);
% set_date --> yyyy-mm-dd hh:mm:ss
% hmax_gpd
% hs_gpd --> Significant wave height
% pdir_gpd
% Ts_gpd

bouy_date_datetime = set_date;
bouy_date_double = datenum(bouy_date_datetime);
%bouy_date_double = interp1(bouy_date_datetime, bouy_date_double, radar_date_datetime, 'linear');

bouy_Hs_original = hs_gpd;
bouy_Hs_interpol = interp1(bouy_date_datetime, bouy_Hs_original, radar_date_datetime, 'linear');

clear hmax_gpd hs_gpd pdir_gpd Ts_gpd set_date;


%% 오셔닉 ADCP 결과 가져오기 (2019/01/24 ~ 2019/02/22)
% 2019.01.24 12:00 ~ 2019.02.22 12:00 (60 min)

load_ADCP;
% date_w01 --> yyyy-mm-dd hh:mm:ss
% dir_w01
% H10_w01
% Hs_w01 --> Significant wave height
% tm_w01
% tp_w01

ADCP_date_datetime = date_w01';
ADCP_date_double = datenum(ADCP_date_datetime);

ADCP_Hs = Hs_w01';

clear date_w01 dir_w01 H10_w01 Hs_w01 tm_w01 tp_w01;


%% 오셔닉 AWAC 결과 가져오기 (2019/09/?? ~ 2020/01/??)
% 2019.09.27 11:00 ~ 2020.01.16 09:00 (60 min)

AWAC_raw = readcell([pwd, '/DATA/기타/안인파랑관측_201909-202001.to.Gopher.xlsx'], Range="A2:D2664");
% 1st column : date --> yyyy-mm-dd hh:mm:ss
% 2nd column : Hs --> Significant wave height
% 3rd column : 
% 4th column : Pdir

AWAC_date_datetime = [AWAC_raw{:, 1}];
AWAC_date_double = datenum(AWAC_date_datetime);

AWAC_Hs = [AWAC_raw{:, 2}];

clear AWAC_raw;


%% ADCP & AWAC 결과 병합

SUM_date_datetime = [ADCP_date_datetime, ADCP_date_datetime(end)+caldays(1), AWAC_date_datetime];
SUM_date_double = [ADCP_date_double, ADCP_date_double(end)+1, AWAC_date_double];

SUM_Hs_original = [ADCP_Hs, NaN, AWAC_Hs];
SUM_Hs_interpol = interp1(SUM_date_double, SUM_Hs_original, radar_date_double, 'linear');


%%

z_original_size = length(radar_date_datetime);

idx = ~isnan(SUM_Hs_interpol);

z_date_datetime = radar_date_datetime(idx);
z_date_double = datenum(z_date_datetime);

z_SUM_Hs = SUM_Hs_interpol(idx);
z_bouy_Hs = bouy_Hs_interpol;

clear idx;


%% 추가적인 데이터 처리

aa = 36; % 12시간
bb = 3; % 1시간


% ------- Noise
zz_noise_move_avg = movmean(radar_noise, [2, 0], 'omitnan');
zz_noise_max = zeros(size(radar_noise));
for ii = aa+1 : length(radar_noise)
    zz_noise_max(ii) = max(zz_noise_move_avg(ii-aa : ii));
end
zz_noise_min = zeros(size(radar_noise));
for ii = aa+1 : length(radar_noise)
    zz_noise_min(ii) = min(zz_noise_move_avg(ii-aa : ii));
end


% ------- Signal
zz_signal_move_avg = movmean(radar_signal, [2, 0], 'omitnan');
zz_signal_max = zeros(size(radar_signal));
for ii = aa+1 : length(radar_signal)
    zz_signal_max(ii) = max(zz_signal_move_avg(ii-aa : ii));
end
zz_signal_min = zeros(size(radar_signal));
for ii = aa+1 : length(radar_signal)
    zz_signal_min(ii) = min(zz_signal_move_avg(ii-aa : ii));
end


% ------- SNR
zz_SNR_move_avg = movmean(radar_SNR, [2, 0], 'omitnan');
zz_SNR_max = zeros(size(radar_SNR));
for ii = aa+1 : length(radar_SNR)
    zz_SNR_max(ii) = max(zz_SNR_move_avg(ii-aa : ii));
end
zz_SNR_min = zeros(size(radar_SNR));
for ii = aa+1 : length(radar_SNR)
    zz_SNR_min(ii) = min(zz_SNR_move_avg(ii-aa : ii));
end


% ------- Peak period
zz_Tp_move_avg = movmean(radar_Tp, [2, 0], 'omitnan');
zz_Tp_max = zeros(size(radar_Tp));
for ii = aa+1 : length(radar_Tp)
    zz_Tp_max(ii) = max(zz_Tp_move_avg(ii-aa : ii));
end
zz_Tp_max(zz_Tp_max <= 3) = NaN;
zz_Tp_min = zeros(size(radar_Tp));
for ii = aa+1 : length(radar_Tp)
    zz_Tp_min(ii) = min(zz_Tp_move_avg(ii-aa : ii));
end
zz_Tp_min(zz_Tp_min <= 3) = NaN;


% ------- Wind
zz_wind_move_avg = movmean(radar_wind, [2, 0], 'omitnan');
zz_wind_max = zeros(size(radar_wind));
for ii = aa+1 : length(radar_wind)
    zz_wind_max(ii) = max(zz_wind_move_avg(ii-aa : ii));
end
zz_wind_min = zeros(size(radar_wind));
for ii = aa+1 : length(radar_wind)
    zz_wind_min(ii) = min(zz_wind_move_avg(ii-aa : ii));
end


%% ANN

Nh = 12;
net = 0;
NMT = 100;

for ii = 1 : NMT


    zzz_bouy_Hs = z_bouy_Hs;

    zzz_last_idx = length(radar_Tp);
    zzz_idx1 = [1:zzz_last_idx];
    zzz_idx2 = [2:zzz_last_idx, zzz_last_idx];
    zzz_idx3 = [3:zzz_last_idx, zzz_last_idx, zzz_last_idx];

    zzz_ANN_INPUT = [
        radar_noise(zzz_idx1) ; radar_noise(zzz_idx2) ; radar_noise(zzz_idx3) ; 
        zz_noise_max(zzz_idx1) ; zz_noise_max(zzz_idx2) ; zz_noise_max(zzz_idx3) ;
        zz_noise_min(zzz_idx1) ; zz_noise_min(zzz_idx2) ; zz_noise_min(zzz_idx3) ;
        radar_signal(zzz_idx1) ; radar_signal(zzz_idx2) ; radar_signal(zzz_idx3) ; 
        zz_signal_max(zzz_idx1) ; zz_signal_max(zzz_idx2) ; zz_signal_max(zzz_idx3) ;
        zz_signal_min(zzz_idx1) ; zz_signal_min(zzz_idx2) ; zz_signal_min(zzz_idx3) ;
        radar_SNR(zzz_idx1) ; radar_SNR(zzz_idx2) ; radar_SNR(zzz_idx3) ;
        zz_SNR_max(zzz_idx1) ; zz_SNR_max(zzz_idx2) ; zz_SNR_max(zzz_idx3) ;
        zz_SNR_min(zzz_idx1) ; zz_SNR_min(zzz_idx2) ; zz_SNR_min(zzz_idx3) ;
        radar_Tp(zzz_idx1) ; radar_Tp(zzz_idx2) ; radar_Tp(zzz_idx3) ;
        zz_Tp_max(zzz_idx1) ; zz_Tp_max(zzz_idx2) ; zz_Tp_max(zzz_idx3) ;
        zz_Tp_min(zzz_idx1) ; zz_Tp_min(zzz_idx2) ; zz_Tp_min(zzz_idx3)
        ];

   
   % Divided local min/max
   % (datenum)1 = 1 day
   date_local_period = 0.5;
   date_local_step = radar_date_double(2) - radar_date_double(1);
   date_local_count = ceil(date_local_period / date_local_step);
   date_local_period_count = floor(length(radar_date_double) / date_local_count);
   date_local_checker = false(size(radar_date_double));
   for iii = 1 : date_local_period_count
       idx = (iii - 1) * date_local_count + 1 : (iii) * date_local_count;
       temp = zzz_bouy_Hs(idx);
       [tempMax idxMax] = max(temp);
       [tempMin idxMin] = min(temp);
       date_local_checker([ (iii -  1) * date_local_count + idxMax , (iii -  1) * date_local_count + idxMin ]) = true;
   end
   date_local_min_max = radar_date_double(date_local_checker);
   bouy_Hs_local_min_max = zzz_bouy_Hs(date_local_checker);
   clear date_local_period date_local_step temp tempMax tempMin idx idxMax idxMin iii;


   % Training
   zzz_ANN_TRAINING_INPUT = zzz_ANN_INPUT(:, date_local_checker);
   zzz_ANN_TRAINING_OUTPUT = zzz_bouy_Hs(:, date_local_checker);

   net = feedforwardnet(Nh);
   net = initlay(net);

   net.divideFcn = 'dividerand';
   net.divideParam.trainRatio = 0.7;
   net.divideParam.valRatio = 0.15;
   net.divideParam.testRatio = 0.15;

   net.trainFcn = 'trainlm';

   net.trainParam.epochs = 1000;

   net = train(net, zzz_ANN_TRAINING_INPUT, zzz_ANN_TRAINING_OUTPUT, 'useGPU', 'no');

   hidden_weight{ii} = net.IW{1};
   output_weight{ii} = net.LW{2};
   
   hidden_bias{ii} = net.b{1};
   output_bias{ii} = net.b{2};

   gain_input{ii} = net.input.processSettings{1}.gain;
   offset_input{ii} = net.input.processSettings{1}.xoffset;

   gain_output{ii} = net.output.processSettings{1}.gain;
   offset_output{ii} = net.output.processSettings{1}.xoffset;

   clear net;
   disp('training'); disp(ii);
    

end

% Simulate
zzz_ANN_OUTPUT = zeros(NMT, size(zzz_ANN_TRAINING_INPUT,2));

for ii = 1 : NMT

    for iii = 1 : size(zzz_ANN_TRAINING_INPUT, 2)
        preprocess_input(:, iii) = gain_input{ii} .* (zzz_ANN_TRAINING_INPUT(:, iii) - offset_input{ii}) - 1;
    end

    for iii = 1 : size(zzz_ANN_TRAINING_INPUT, 2)
        weighted_input = hidden_weight{ii} * preprocess_input(:, iii) + hidden_bias{ii};
        actvation_function = 2 ./ (1 + exp(-2 * weighted_input)) - 1;
        weighted_output{ii}(iii) = output_weight{ii} * actvation_function + output_bias{ii};
    end

    zzz_ANN_RESULT(ii, :) = (weighted_output{ii} + 1) / gain_output{ii} + offset_output{ii};
    disp(ii);

end

%% Save Result
zzz_ANN_max = max(zzz_ANN_RESULT, [], 1);
zzz_ANN_max = movmean(zzz_ANN_max, [2, 0], 'omitnan');
zzz_ANN_max = movmean(zzz_ANN_max, [2, 0], 'omitnan');

zzz_ANN_min = min(zzz_ANN_RESULT, [], 1);
zzz_ANN_min = movmean(zzz_ANN_min, [2, 0], 'omitnan');
zzz_ANN_min = movmean(zzz_ANN_min, [2, 0], 'omitnan');

zzz_ANN_FINAL_RESULT = mean(zzz_ANN_RESULT, 1);

save([pwd '/ann_240317.mat'], ...
    'hidden_weight', 'hidden_bias', ...
    'output_weight', 'output_bias', ...
    'gain_input', 'gain_output', ...
    'offset_input', 'offset_output');

zzz_ANN_RESULT = zzz_ANN_RESULT(1:z_original_size);
radar_date_datetime = radar_date_datetime(1:z_original_size);
radar_date_double = radar_date_double(1:z_original_size);
zzz_bouy_Hs = zzz_bouy_Hs(1:z_original_size);

radar_noise = radar_noise(1:z_original_size);
radar_signal = radar_signal(1:z_original_size);
radar_SNR = radar_SNR(1:z_original_size);
radar_Pdir = radar_Pdir(1:z_original_size);
radar_wind = radar_wind(1:z_original_size);
zz_Tp_min = zz_Tp_min(1:z_original_size);

%% Report
figure(1);
set(gcf, 'position', [300 300 1200 400]);
hold off;

plot(radar_date_datetime, zzz_ANN_RESULT, 'k-');
hold on;
plot(ADCP_date_datetime, ADCP_Hs, 'r-');
plot(bouy_date_datetime, bouy_Hs_original, 'b');

legend('RADAR','W-01','Bouy(경포대)')

grid on

set(gca,'fontsize',13)
xlabel('Date [mm/dd]','fontsize',13);
ylabel('Hs [m]','fontsize',13);
title(['Time Series of Significant Wave Height']);

xlim_set = [datetime(2018,11,1) datetime(2020,9,6)];
xlim(xlim_set)
ylim([0 7])


% textbox 생성
annotation(gcf,'textbox',...
    [0.065 0.075 0.05 0.05],...
    'String',{'2019'''},'LineStyle','none','FontWeight','bold','FontSize',14);