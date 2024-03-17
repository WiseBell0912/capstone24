clear; close all; clc;
%%
% 30분 간격 1488 5분 간격 8640 (2018년 10월, 11월 기준)
fdir = '/Users/kimyehyun/Documents/Thousand/PRI/Gyeongpo_Buoy/';
flist = dir([fdir '*.txt']);
fsize = size(flist);

hs_gpd_raw = [];

for ii = 1:fsize
    raw = readmatrix(sprintf("%s/%s", flist(ii).folder, flist(ii).name), 'OutputType','string');
    hs_gpd_raw = [hs_gpd_raw; raw];
end

% time_10 = datetime(Hs_gpd(1, 1)):minutes(10):datetime(Hs_gpd(end, 1))';

% 확인결과 5분 간격으로 누락 없이 측정되었음

set_date = datetime(hs_gpd_raw(:, 1));
hs_gpd = double(hs_gpd_raw(:, 7));

idx_0 = hs_gpd == 0;
hs_gpd(idx_0) = NaN;
hs_gpd(172926:174406) = NaN;
hs_gpd(269979:271475) = NaN;
hs_gpd = movingA(hs_gpd, 6);
set_date_2 = set_date;

% save Hs_gpd.mat Hs_gpd_raw Hs_gpd set_date
save bouy_201904to202105_230731.mat hs_gpd set_date

%%
load bouy_201811to202009.mat
hs_gpd = hs_gpd';
set_date_1 = set_date';


clearvars hmax_gpd pdir_gpd set_date Ts_gpd

clear hs_gpd_raw set_date

load ANN_radar_out_20_3q_200905.mat;
set_date = set_date';

clear esig_1st enoise_1st pdir_1st tpMS wspd_new snr_1st

hs_gpd_tr = interp1(set_date_2,hs_gpd,set_date,'linear');

hs_tr = interp1(set_date_1',hs_gpd,set_date,'linear');

plot(set_date, hs_tr)
hold on;
plot(set_date, hs_gpd_tr)
plot(set_date_2, hs_gpd)
hold on;
% plot(set_date_1, hs_gpd)

legend('10min', '5min', 'original')

xlim([datetime('2020-01-01') datetime('2020-01-15')])


