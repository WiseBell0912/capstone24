clear; close all; clc;

load('ann_gr_230623-v7_land.mat','Na','Nb','Nc','Nd','Wh','Wo','bh','bo')

load('ANN_radar_out_20_3q_230704.mat')
load buoy_201904to202105_230731.mat

% idx = floor(length(Tp)*0.7);
idx = 1;

land_avg = land_avg(idx:end);
land_max = land_max(idx:end);
land_min = land_min(idx:end);
noise = noise(idx:end);
Pdir = Pdir(idx:end);
rrdate = rrdate(idx:end);

sea_avg = sea_avg(idx:end);
sea_max = sea_max(idx:end);
sea_min = sea_min(idx:end);
signal = signal(idx:end);
SNR = SNR(idx:end);
Tp = Tp(idx:end);

NMT = 100;
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
% windMax = zeros(size(Tp));
% for ii = aa+1:length(Tp)
%    windMax(ii) = max(wspd_new(ii-aa:ii)); 
% end
% 
% windMin = zeros(size(Tp));
% for ii = aa+1:length(Tp)
%    windMin(ii) = min(wspd_new(ii-aa:ii)); 
% end

SNRs = movingA(SNRs,bb);

%% ANN input

lastidx = length(Tp);
idx1 = [1:lastidx];
idx2 = [2:lastidx, lastidx];
idx3 = [3:lastidx, lastidx, lastidx];

% ANN_SIMULATE_INPUT = [Tp(idx1)',Tp(idx2)',Tp(idx3)',...
%                       signal(idx1)',signal(idx2)',signal(idx3)',...
%                       noise(idx1)',noise(idx2)',noise(idx3)',....
%                       SNR(idx1)',SNR(idx2)',SNR(idx3)',...
%                       TpMin(idx1)',TpMin(idx2)',TpMin(idx3)',...
%                       TpMax(idx1)',TpMax(idx2)',TpMax(idx3)',...
%                       SNRMin(idx1)',SNRMin(idx2)',SNRMin(idx3)',...
%                       SNRMax(idx1)',SNRMax(idx2)',SNRMax(idx3)',...
%                       signalMin(idx1)',signalMin(idx2)',signalMin(idx3)',... 
%                       signalMax(idx1)',signalMax(idx2)',signalMax(idx3)',...
%                       noiseMin(idx1)',noiseMin(idx2)',noiseMin(idx3)',...
%                       noiseMax(idx1)',noiseMax(idx2)',noiseMax(idx3)'
%                       land_avg(idx1)', land_avg(idx2)', land_avg(idx3)',...
%                       land_min(idx1)', land_min(idx2)', land_min(idx3)',...
%                       land_max(idx1)', land_max(idx2)', land_max(idx3)'
%                       ]';

ANN_SIMULATE_INPUT = [
    Tps(idx1)',Tps(idx2)',Tps(idx3)',...
    signals(idx1)',signals(idx2)',signals(idx3)',...
    noises(idx1)',noises(idx2)',noises(idx3)',....
    SNRs(idx1)',SNRs(idx2)',SNRs(idx3)',...
    TpMin(idx1)',TpMin(idx2)',TpMin(idx3)',...
    TpMax(idx1)',TpMax(idx2)',TpMax(idx3)',...
    SNRMin(idx1)',SNRMin(idx2)',SNRMin(idx3)',...
    SNRMax(idx1)',SNRMax(idx2)',SNRMax(idx3)',...
    signalMin(idx1)',signalMin(idx2)',signalMin(idx3)',... 
    signalMax(idx1)',signalMax(idx2)',signalMax(idx3)',...
    noiseMin(idx1)',noiseMin(idx2)',noiseMin(idx3)',...
    noiseMax(idx1)',noiseMax(idx2)',noiseMax(idx3)',...
    lands(idx1)', lands(idx2)', lands(idx3)',...
    landMin(idx1)', landMin(idx2)', landMin(idx3)',...
    landMax(idx1)', landMax(idx2)', landMax(idx3)',...
    seas(idx1)', seas(idx2)', seas(idx3)',...
    seaMin(idx1)', seaMin(idx2)', seaMin(idx3)',...
    seaMax(idx1)', seaMax(idx2)', seaMax(idx3)',...
                ]';

%% ANN 
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
    tempii;
end


ANN_out_point = ANN_out;
ANN_max = movingA(movingA(max(ANN_out_point,[],1),3),3);
ANN_min = movingA(movingA(min(ANN_out_point,[],1),3),3);
ANN_out = mean(ANN_out_point,1);

%%
hs_gpd_tr = interp1(set_date,hs_gpd,rrdate,'linear');

error = ANN_out - hs_gpd_tr;

figure(1000)
set(gcf,'position',[300 300 1200 400])
hold off

plot(rrdate,ANN_out,'k-')
hold on
% plot(set_date,hs_gpd,'b');
plot(rrdate,hs_gpd_tr,'b');
% plot(rrdate_(divRidx),hs_by(divRidx),'bo');
plot(rrdate, error)

legend('RADAR', 'Bouy(경포대)')
grid on

set(gca,'fontsize',13)
xlabel('Date [mm/dd]','fontsize',13);
ylabel('Hs [m]','fontsize',13);
title(['Time Series of Significant Wave Height']);

xlim_set = [datetime(2020,11,1) datetime(2021,1,6)];
xlim(xlim_set)
ylim([0 7])

% textbox 생성
annotation(gcf,'textbox',...
    [0.065 0.075 0.05 0.05],...
    'String',{'2019'''},'LineStyle','none','FontWeight','bold','FontSize',14);


SST = sum((hs_gpd_tr - mean(hs_gpd_tr, 'omitnan')).^2, 'omitnan');
SSR = sum((hs_gpd_tr - ANN_out).^2, 'omitnan');


R2 = 1-(SSR/SST)