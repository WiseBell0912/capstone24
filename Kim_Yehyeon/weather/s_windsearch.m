clear; close all; clc;

%%
load wind_data_230712.mat
load ANN_OUT_230706_None.mat

rrdate = datetime(rrdate, "ConvertFrom", 'datenum');
wwdate = datetime(windsp(:, 1), "ConvertFrom", 'datenum');

wspd = windsp(:, 3);
wspd = normalize(movingA(wspd, 60));

error = normalize(ANN_out - hs_tr);

hs_tr = normalize(hs_tr);

% plot(rrdate, ANN_out)
% hold on
plot(rrdate, hs_tr)
hold on
plot(wwdate, wspd)
plot(rrdate, error)

legend('hs', 'wind', 'error')
xlim_set = [datetime(2020,01,1) datetime(2020,02,01)];
xlim(xlim_set)