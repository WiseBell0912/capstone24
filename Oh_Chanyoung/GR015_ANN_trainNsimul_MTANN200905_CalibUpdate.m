clear; close all; clc;
%% 레이다 이전 자료 전부 불러오기
load([pwd, '/선행연구_오찬영/ANN_radar_out_20_3q_200905.mat']);
% wabs : 풍속 절대값 평균 / wspd_new : 풍속 벡터 평균 / wdir_new : 풍향 벡터 평균 
% wdir_only : 풍향만 평균  /// 모든 평균은 (계측 시작으로부터) 3분 동안 평균한 것

% prepare radar data

SNR = snr_1st;
Tp = tpMS;
signal = esig_1st;
noise = enoise_1st;
Pdir = pdir_1st;
wspd_new = wspd_new;

rrdate = datenum(set_date);
rrdate_ = set_date;
size(rrdate)

%% 경포대 부이 결과 가져오기
load([pwd, '/선행연구_김예현/data/bouy_201811to202009.mat']);

% hs_gpd / hmax_gpd / pdir_gpd / set_date / Ts_gpd
hs_gpd_tr = interp1(set_date,hs_gpd,rrdate_,'linear');
% hs_gpd_tr = [hs_gpd_pre,hs_gpd_tr'];
%% load data : 오셔닉 adcp(19/01/24 ~ 19/02/22)
% % load oceanic adcp wave data - Wave_data_W01_cm(WIN).dat
loadw01%date_w01 / Hs_w01
date_w01a = datetime(date_w01,'convertFrom','datenum');
Hs_w01a = Hs_w01;
%% load data : 오셔닉 awac(19년 9월 ~ 20년 1월)
[~, ~, raw, dates] = xlsread([pwd, '/train_data/안인파랑관측_201909-202001.to.Gopher.xlsx'],'Sheet1','A2:D2664','basic',@convertSpreadsheetExcelDates);
raw = raw(:,[2,3,4]);
dates = dates(:,1);

data = reshape([raw{:}],size(raw));

date_w01b = datetime([dates{:,1}].', 'ConvertFrom', 'Excel');
Hs_w01b = data(:,1);

date_w01 = [date_w01a',date_w01a(end)+1, date_w01b'];
Hs_w01 = [Hs_w01a',nan, Hs_w01b'];

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

windMax = zeros(size(Tp));
for ii = aa+1:length(Tp)
   windMax(ii) = max(wspd_new(ii-aa:ii)); 
end

windMin = zeros(size(Tp));
for ii = aa+1:length(Tp)
   windMin(ii) = min(wspd_new(ii-aa:ii)); 
end


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


ANN_SIMULATE_INPUT = [Tp',Tp(idx2)',Tp(idx3)',...
        signal(idx1)',signal(idx2)',signal(idx3)',...
        noise(idx1)',noise(idx2)',noise(idx3)',....
            SNR(idx1)',SNR(idx2)',SNR(idx3)',...
    TpMin(idx1)',TpMin(idx2)',TpMin(idx3)',...
    TpMax(idx1)',TpMax(idx2)',TpMax(idx3)',...
        SNRMin(idx1)',SNRMin(idx2)',SNRMin(idx3)',...
    SNRMax(idx1)',SNRMax(idx2)',SNRMax(idx3)',...
       signalMin(idx1)',signalMin(idx2)',signalMin(idx3)',... 
         signalMax(idx1)',signalMax(idx2)',signalMax(idx3)',...
        noiseMin(idx1)',noiseMin(idx2)',noiseMin(idx3)',...
    noiseMax(idx1)',noiseMax(idx2)',noiseMax(idx3)',...
            ]';


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

  save([pwd '/ann_gr_200905-v7_temp.mat'],...
    'Wh','Wo','bh','bo','Na','Nb','Nc','Nd','-v7');
ANN_out = ANN_out(1:sizOri);
rrdate_ = rrdate_(1:sizOri);
rrdate = rrdate(1:sizOri);
hs_by = hs_by(1:sizOri);

signal = signal(1:sizOri);
TpMin = TpMin(1:sizOri);
wspd_new = wspd_new(1:sizOri);
noise = noise(1:sizOri);
Pdir = Pdir(1:sizOri);
SNR = SNR(1:sizOri);

%% report plot
% hs
figure(1000)
set(gcf,'position',[300 300 1200 400])
hold off

plot(rrdate_,ANN_out,'k-')
hold on
plot(date_w01,Hs_w01,'r-');
plot(set_date,hs_gpd,'b');
% plot(rrdate_(divRidx),hs_by(divRidx),'bo');

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











