clear; close all; clc;
%% 레이다 이전 자료 전부 불러오기
% load ANN_radar_out_20_3q_200905.mat;
load ANN_radar_out_20_3q_230704.mat
rrdate_ = rrdate;
rrdate = datenum(rrdate);

idx = length(Tp);

rrdate = rrdate(1:idx);
rrdate_ = rrdate_(1:idx);

Tp_surf = Tp(1:idx);
signal_surf = signal(1:idx);
noise_surf = noise(1:idx);
SNR_surf = SNR(1:idx);
Pdir_surf = Pdir(1:idx);

land_avg = land_avg(1:idx);
land_max = land_max(1:idx);
land_min = land_min(1:idx);

sea_avg = sea_avg(1:idx);
sea_max = sea_max(1:idx);
sea_min = sea_min(1:idx);

% 2019년 04월 01일 - 2021년 05월 31일
% wabs : 풍속 절대값 평균 / wspd_new : 풍속 벡터 평균 / wdir_new : 풍향 벡터 평균 
% wdir_only : 풍향만 평균  /// 모든 평균은 (계측 시작으로부터) 3분 동안 평균한 것
% prepare radar data

% idx = floor(length(Tp)*0.7);

load result1st_sea.mat

Tp = Tp(1:idx);
signal = signal(1:idx);
noise = noise(1:idx);
SNR = SNR(1:idx);
Pdir = Pdir(1:idx);

%% 경포대 부이 결과 가져오기
% load Hs_gpd.mat
% set_date = set_date';
% Hs_gpd = Hs_gpd';
load buoy_201904to202105_230731.mat

% hs_gpd / hmax_gpd / pdir_gpd / set_date / Ts_gpd
hs_gpd_tr = interp1(set_date,hs_gpd,rrdate_,'linear');
% hs_gpd_tr = [hs_gpd_pre,hs_gpd_tr'];
%% load data : 오셔닉 adcp(19/01/24 ~ 19/02/22)
% load oceanic adcp wave data - Wave_data_W01_cm(WIN).dat
loadw01%date_w01 / Hs_w01
date_w01a = date_w01;
Hs_w01a = Hs_w01;
%% load data : 오셔닉 awac(19년 9월 ~ 20년 1월)
loadw02
date_w02 = date_w02;
Hs_w02 = Hs_w02;

date_w01 = [date_w01a',date_w01a(end)+1, date_w02'];
Hs_w01 = [Hs_w01a',nan, Hs_w02'];

Hs_w01_tr = interp1(date_w01,Hs_w01,rrdate_,'linear');

% 임시 변수 지우기
clearvars data raw dates;


%%%%
sizOri = length(rrdate_);

idx = ~isnan(Hs_w01_tr);
Hs_w01_tr = Hs_w01_tr(idx);
date_w01_tr = rrdate_(idx);

rrdate = datenum(rrdate_);
hs_tr = hs_gpd_tr;

%%
lastidx = length(rrdate);
idx1 = [1:lastidx];
idx2 = [2:lastidx, lastidx];
idx3 = [3:lastidx, lastidx, lastidx];

aa = 36;
bb = 3;

hs_tr = movingA(hs_gpd_tr, 3);

Tps = movingA(Tp,bb);
TpMax = zeros(size(Tp));
for ii = aa+1:length(Tp)
   TpMax(ii) = max(Tps(ii-aa:ii)); 
end
TpMax(TpMax<=3) = nan;
TpMin = zeros(size(Tp));
for ii = aa+1:length(Tp)
   TpMin(ii) = min(Tps(ii-aa:ii)); 
end
TpMin(TpMin<=3) = nan;

SNRs = movingA(SNR,bb);
SNRMax = zeros(size(SNR));
for ii = aa+1:length(Tp)
   SNRMax(ii) = max(SNRs(ii-aa:ii)); 
end
SNRMin = zeros(size(SNR));
for ii = aa+1:length(SNR)
   SNRMin(ii) = min(SNRs(ii-aa:ii)); 
end

signals = movingA(signal,bb);
signalMax = zeros(size(Tp));
for ii = aa+1:length(Tp)
   signalMax(ii) = max(signals(ii-aa:ii)); 
end
signalMin = zeros(size(Tp));
for ii = aa+1:length(Tp)
   signalMin(ii) = min(signals(ii-aa:ii)); 
end
% signalMin = signalMax - signalMin; 

noises = movingA(noise,bb);
noiseMax = zeros(size(Tp));
for ii = aa+1:length(Tp)
   noiseMax(ii) = max(noises(ii-aa:ii)); 
end
noiseMin = zeros(size(Tp));
for ii = aa+1:length(Tp)
   noiseMin(ii) = min(noises(ii-aa:ii)); 
end
% noiseMin = noiseMax - noiseMin;

lands = movingA(land_avg,bb);
landMax = zeros(size(Tp));
for ii = aa+1:length(Tp)
   landMax(ii) = max(lands(ii-aa:ii)); 
end
landMin = zeros(size(Tp));
for ii = aa+1:length(Tp)
   landMin(ii) = min(lands(ii-aa:ii)); 
end

seas = movingA(sea_avg,bb);
seaMax = zeros(size(Tp));
for ii = aa+1:length(Tp)
   seaMax(ii) = max(seas(ii-aa:ii)); 
end
seaMin = zeros(size(Tp));
for ii = aa+1:length(Tp)
   seaMin(ii) = min(seas(ii-aa:ii)); 
end

LSR = lands./seas;
LSRs = movingA(LSR,bb);
LSRMax = zeros(size(Tp));
for ii = aa+1:length(Tp)
   LSRMax(ii) = max(LSRs(ii-aa:ii)); 
end
LSRMin = zeros(size(Tp));
for ii = aa+1:length(Tp)
   LSRMin(ii) = min(LSRs(ii-aa:ii)); 
end

%%

Tps_surf = movingA(Tp_surf,bb);
TpMax_surf = zeros(size(Tp_surf));
for ii = aa+1:length(Tp_surf)
   TpMax_surf(ii) = max(Tps_surf(ii-aa:ii)); 
end
TpMax_surf(TpMax_surf<=3) = nan;
TpMin_surf = zeros(size(Tp_surf));
for ii = aa+1:length(Tp_surf)
   TpMin_surf(ii) = min(Tps_surf(ii-aa:ii)); 
end
TpMin_surf(TpMin_surf<=3) = nan;

SNRs_surf = movingA(SNR_surf,bb);
SNRMax_surf = zeros(size(SNR_surf));
for ii = aa+1:length(Tp_surf)
   SNRMax_surf(ii) = max(SNRs_surf(ii-aa:ii)); 
end
SNRMin_surf = zeros(size(SNR_surf));
for ii = aa+1:length(SNR_surf)
   SNRMin_surf(ii) = min(SNRs_surf(ii-aa:ii)); 
end

signals_surf = movingA(signal_surf,bb);
signalMax_surf = zeros(size(Tp_surf));
for ii = aa+1:length(Tp_surf)
   signalMax_surf(ii) = max(signals_surf(ii-aa:ii)); 
end
signalMin_surf = zeros(size(Tp_surf));
for ii = aa+1:length(Tp_surf)
   signalMin_surf(ii) = min(signals_surf(ii-aa:ii)); 
end
% signalMin = signalMax - signalMin; 

noises_surf = movingA(noise_surf,bb);
noiseMax_surf = zeros(size(Tp_surf));
for ii = aa+1:length(Tp_surf)
   noiseMax(ii) = max(noises(ii-aa:ii)); 
end
noiseMin_surf = zeros(size(Tp_surf));
for ii = aa+1:length(Tp_surf)
   noiseMin_surf(ii) = min(noises_surf(ii-aa:ii)); 
end
% noiseMin = noiseMax - noiseMin;

% windMax = zeros(size(Tp));
% for ii = aa+1:length(Tp)
%    windMax(ii) = max(wspd_new(ii-aa:ii)); 
% end
% 
% windMin = zeros(size(Tp));
% for ii = aa+1:length(Tp)
%    windMin(ii) = min(wspd_new(ii-aa:ii)); 
% end
%% ANN 
    %Nh = Ns / alpha(Ni+No) / 히든뉴런 = 샘플갯수 / 2-10(인풋뉴런갯수 + 아웃풋뉴런갯수)
    Nh = 12;%round( length(ANN_TRAINING_INPUT) / ( 2*( sum(ANN_TRAINING_INPUT(:,1)~=0) + 1) ) )
    net = 0;
    NMT = 100;

for tempii = 1:NMT
% hs_by = Hs_ocn_tr;
hs_by = hs_tr;
% hs_by = hs_by_pre;

lastidx = length(Tp);
idx1 = [1:lastidx];
idx2 = [2:lastidx, lastidx];
idx3 = [3:lastidx, lastidx, lastidx];

ANN_SIMULATE_INPUT = [
    Tps(idx1)',Tps(idx2)',Tps(idx3)',...
    TpMin(idx1)',TpMin(idx2)',TpMin(idx3)',...
    TpMax(idx1)',TpMax(idx2)',TpMax(idx3)',...
    SNRs(idx1)',SNRs(idx2)',SNRs(idx3)',...
    SNRMin(idx1)',SNRMin(idx2)',SNRMin(idx3)',...
    SNRMax(idx1)',SNRMax(idx2)',SNRMax(idx3)',...
    signals(idx1)',signals(idx2)',signals(idx3)',...
    signalMin(idx1)',signalMin(idx2)',signalMin(idx3)',... 
    signalMax(idx1)',signalMax(idx2)',signalMax(idx3)',...
    noises(idx1)',noises(idx2)',noises(idx3)',....
    noiseMin(idx1)',noiseMin(idx2)',noiseMin(idx3)',...
    noiseMax(idx1)',noiseMax(idx2)',noiseMax(idx3)',...
    LSRs(idx1)',LSRs(idx2)',LSRs(idx3)',...
    LSRMax(idx1)',LSRMax(idx2)',LSRMax(idx3)',...
    LSRMin(idx1)',LSRMin(idx2)',LSRMin(idx3)',...
    lands(idx1)', lands(idx2)', lands(idx3)',...
    landMin(idx1)', landMin(idx2)', landMin(idx3)',...
    landMax(idx1)', landMax(idx2)', landMax(idx3)',...
    seas(idx1)', seas(idx2)', seas(idx3)',...
    seaMin(idx1)', seaMin(idx2)', seaMin(idx3)',...
    seaMax(idx1)', seaMax(idx2)', seaMax(idx3)',...
    Tps_surf(idx1)',Tps_surf(idx2)',Tps_surf(idx3)',...
    SNRs_surf(idx1)',SNRs_surf(idx2)',SNRs_surf(idx3)',...
    signals_surf(idx1)',signals_surf(idx2)',signals_surf(idx3)',...
    noises_surf(idx1)',noises_surf(idx2)',noises_surf(idx3)',....
                ]';
%     signalMin_surf(idx1)',signalMin_surf(idx2)',signalMin_surf(idx3)',... 
%     signalMax_surf(idx1)',signalMax_surf(idx2)',signalMax_surf(idx3)',...
%     noiseMin_surf(idx1)',noiseMin_surf(idx2)',noiseMin_surf(idx3)',...
%     noiseMax_surf(idx1)',noiseMax_surf(idx2)',noiseMax_surf(idx3)'
%     SNRMin_surf(idx1)',SNRMin_surf(idx2)',SNRMin_surf(idx3)',...
%     SNRMax_surf(idx1)',SNRMax_surf(idx2)',SNRMax_surf(idx3)',...
%     TpMin_surf(idx1)',TpMin_surf(idx2)',TpMin_surf(idx3)',...
%     TpMax_surf(idx1)',TpMax_surf(idx2)',TpMax_surf(idx3)',...

%%%%%%%%%%%%%%%%%%%%%% pick divided local maxima
%%%%%% oneDay = (datenum) 1 : datenum에서 1일은 숫자 1로 표현됨
divDtSet = 1/2;

Ddate = (rrdate(2)-rrdate(1));
divDidx = ceil(divDtSet/Ddate);
divDt = divDidx*Ddate;
divN = floor(length(rrdate) / divDidx);

divRidx = false(size(rrdate));

for ii = 1:divN
    %구간1  
    idx = (ii - 1) * divDidx + 1 : (ii) * divDidx;
    temp = hs_by(idx);
    [tempMax idxMax] = max(temp);
    [tempMin idxMin] = min(temp);
    
    divRidx([(ii - 1)*divDidx+idxMax (ii - 1)*divDidx+idxMin]) = true;
%     divRidx([(ii - 1)*divDidx+idxMax]) = true;
%     divRidx([(ii - 1)*divDidx+idxMin]) = true;
end


%% 추가 구간 설정

rrdate_localMM = rrdate(divRidx);
hs_by_localMM = hs_by(divRidx);

clear Ddate divDtSet tempMax tempMin temp idx ii
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    ANN_TRAINING_INPUT = ANN_SIMULATE_INPUT(:,divRidx);
        
    siz = size(hs_by(divRidx));
    ANN_TRAINING_OUTPUT = hs_by(divRidx);
     
    net = feedforwardnet(Nh);
    net = initlay(net);
    
    net.divideFcn = 'dividerand';
    net.divideParam.trainRatio = 0.7;
    net.divideParam.valRatio = 0.15;
    net.divideParam.testRatio = 0.15;

    if false%mod(tempii,2)
        net.trainFcn = 'trainrp';
    else
        net.trainFcn = 'trainlm';
    end
    
    net.trainParam.epochs = 1000;
    net.trainParam.showWindow = false;

    
    for ii = 1%:5
    [net, tr] = train(net, ANN_TRAINING_INPUT, ANN_TRAINING_OUTPUT,'useGPU','no');

    end

% simulate net
    Wh{tempii} = net.IW{1};
    Wo{tempii} = net.LW{2};
    bh{tempii} = net.b{1};
    bo{tempii} = net.b{2};
    
    Na{tempii} = net.input.processSettings{1}.gain;
    Nb{tempii} = net.input.processSettings{1}.xoffset;     
    
    Nc{tempii} = net.output.processSettings{1}.gain;
    Nd{tempii} = net.output.processSettings{1}.xoffset;
    clear net
    tempii
end


%%
ANN_out = zeros(NMT,size(ANN_SIMULATE_INPUT,2));

for tempii = 1:NMT
    
for ii = 1:size(ANN_SIMULATE_INPUT,2)
    pN(:,ii) = Na{tempii}.*(ANN_SIMULATE_INPUT(:,ii) - Nb{tempii}) - 1;
end
    
for ii = 1:size(pN,2)   
    temp = Wh{tempii} * pN(:,ii) + bh{tempii};
    HL_out = 2./(1+exp(-2*temp))-1;
    ANN_out_temp{tempii}(ii) = Wo{tempii} * HL_out + bo{tempii};
end
    ANN_out(tempii,:) = (ANN_out_temp{tempii} + 1) / Nc{tempii} + Nd{tempii};
    tempii
end

ANN_out_point = ANN_out;
ANN_max = movingA(movingA(max(ANN_out_point,[],1),3),3);
ANN_min = movingA(movingA(min(ANN_out_point,[],1),3),3);
ANN_out = mean(ANN_out_point,1);

  save([pwd '/ann_gr_230623-v7_land.mat'],...
    'Wh','Wo','bh','bo','Na','Nb','Nc','Nd','-v7');
ANN_out = ANN_out(1:sizOri);
rrdate_ = rrdate_(1:sizOri);
rrdate = rrdate(1:sizOri);
hs_by = hs_by(1:sizOri);

signal = signal(1:sizOri);
TpMin = TpMin(1:sizOri);
noise = noise(1:sizOri);
Pdir = Pdir(1:sizOri);
SNR = SNR(1:sizOri);
% wspd_new = wspd_new(1:sizOri);

%%

% len = length(ANN_SIMULATE_INPUT);
% 
% train = ANN_SIMULATE_INPUT(:, 1:floor(len*0.7));
% test = ANN_SIMULATE_INPUT(:, floor(len*0.7)+1:end);
% 
% rng('default')
% t = templateTree('Reproducible',true);
% 
% Mdl1 = fitrensemble(train', hs_tr(1:floor(len*0.7), :),'OptimizeHyperparameters','auto','Learners', t, ...
%     'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName','expected-improvement-plus'));
% 
% ANN_out = predict(Mdl1,test');

%% report plot
% hs
figure(1000)
set(gcf,'position',[300 300 1200 400])
hold off
hold on
plot(rrdate_,hs_gpd_tr,'k');
plot(rrdate_,ANN_out1,'r');
plot(rrdate_,ANN_out,'b')


% plot(date_w01,Hs_w01,'r-');
% plot(set_date,hs_gpd,'b');

% plot(rrdate_,error,'.');

% plot(rrdate_(divRidx),hs_by(divRidx),'bo');

legend('buoy(observed)','without correction','with correction')
grid off
box on
ax = gca;
ax.LineWidth = 1.5

set(gca,'fontsize',13)
xlabel('Date [yy-mm-dd]','fontsize',13);
ylabel('Hs [m]','fontsize',13);
title(['Time Series of Significant Wave Height'], 'FontSize', 18);
xtickformat('yy-MM-dd')

xlim_set = [datetime(2019, 09, 20) datetime(2019, 10, 21)];
xlim(xlim_set)
ylim([0 5])

exportgraphics(gcf, 'result.PNG', 'Resolution', 600)

% textbox 생성
annotation(gcf,'textbox',...
    [0.065 0.075 0.05 0.05],...
    'String',{'2019'''},'LineStyle','none','FontWeight','bold','FontSize',14);

error = ANN_out - hs_tr;

% plot(rrdate_, error, '-' )
% 
figure(10)
x = 0:10;
y = 0:10; 
hold on;
plot(ANN_out, hs_tr, 'k.')
plot(x, y, '-');
plot(x-1, y, 'r--')
plot(x, y-1, 'r--')

axis equal; box on;
xlim([0 6])
ylim([0 6])
xlabel('Estimated Hs[m]','fontsize',13);
ylabel('Observed Hs[m]','fontsize',13);
title('Results of the previous ANN model', 'fontsize', 18)
legend({'without correction', 'X = Y', '1m error'}, 'Location','southeast')

ax = gca;
ax.LineWidth = 1.5;

exportgraphics(gcf, 'R2_1.PNG', 'Resolution', 800)

SST = sum((hs_tr - mean(hs_tr, 'omitnan')).^2, 'omitnan');
SSR = sum((hs_tr - ANN_out).^2, 'omitnan');

R2 = 1-(SSR/SST)