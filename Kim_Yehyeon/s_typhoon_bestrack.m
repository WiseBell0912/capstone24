clear; close all; clc;
%%
% date type
% data loading
% interpolation
% reshape

%%
load ann_out_230706_sea_land.mat
%%
bst = readmatrix('bst_all.txt');
bst = bst(66990:end, :);

idx_6 = find(bst(:, 1) == 66666);
header = bst(idx_6, :);
bst_cell = {};

% error = ANN_out - hs_tr;
% rrdate_ = datetime(rrdate, "ConvertFrom", "datenum");

for i = 1:length(idx_6)
    if i == 99
        bst_cell{i,1} = bst(idx_6(i)+1:end, [1, 4:5]);
        break
    end
    bst_cell{i,1} = bst(idx_6(i)+1:idx_6(i+1)-1, [1, 4:5]);
end

% 1:29 2019
% 30:52 2020
% 53:74 2021
% 75:99 2022

bst_list = [5, 8, 10, 17, 18, 34, 38, 39];

for i = 1:length(bst_list)
    geoplot(bst_cell{bst_list(i)}(:, 2)*0.1, bst_cell{bst_list(i)}(:, 3)*0.1, ...
        'DisplayName',sprintf('%d', header(bst_list(i),2)))
    hold on
end
hold off
legend
exportgraphics(gcf, 'bst_track.PNG', 'resolution',300)

typoon_best = bst_cell(bst_list);

%%
bst_1905 = bst_cell{5};
bst_1905_N = interp1(datetime(num2str(bst_1905(:,1)), 'InputFormat', 'yyMMddHH'), bst_1905(:,2), rrdate_)*0.1;
bst_1905_W = interp1(datetime(num2str(bst_1905(:,1)), 'InputFormat', 'yyMMddHH'), bst_1905(:,3), rrdate_)*0.1;

bst_1908 = bst_cell{8};
bst_1908_N = interp1(datetime(num2str(bst_1908(:,1)), 'InputFormat', 'yyMMddHH'), bst_1908(:,2), rrdate_)*0.1;
bst_1908_W = interp1(datetime(num2str(bst_1908(:,1)), 'InputFormat', 'yyMMddHH'), bst_1908(:,3), rrdate_)*0.1;

bst_1910 = bst_cell{10};
bst_1910_N = interp1(datetime(num2str(bst_1910(:,1)), 'InputFormat', 'yyMMddHH'), bst_1910(:,2), rrdate_)*0.1;
bst_1910_W = interp1(datetime(num2str(bst_1910(:,1)), 'InputFormat', 'yyMMddHH'), bst_1910(:,3), rrdate_)*0.1;

bst_1917 = bst_cell{17};
bst_1917_N = interp1(datetime(num2str(bst_1917(:,1)), 'InputFormat', 'yyMMddHH'), bst_1917(:,2), rrdate_)*0.1;
bst_1917_W = interp1(datetime(num2str(bst_1917(:,1)), 'InputFormat', 'yyMMddHH'), bst_1917(:,3), rrdate_)*0.1;

bst_1918 = bst_cell{18};
bst_1918_N = interp1(datetime(num2str(bst_1918(:,1)), 'InputFormat', 'yyMMddHH'), bst_1918(:,2), rrdate_)*0.1;
bst_1918_W = interp1(datetime(num2str(bst_1918(:,1)), 'InputFormat', 'yyMMddHH'), bst_1918(:,3), rrdate_)*0.1;

bst_2005 = bst_cell{34};
bst_2005_N = interp1(datetime(num2str(bst_2005(:,1)), 'InputFormat', 'yyMMddHH'), bst_2005(:,2), rrdate_)*0.1;
bst_2005_W = interp1(datetime(num2str(bst_2005(:,1)), 'InputFormat', 'yyMMddHH'), bst_2005(:,3), rrdate_)*0.1;

bst_2009 = bst_cell{38};
bst_2009_N = interp1(datetime(num2str(bst_2009(:,1)), 'InputFormat', 'yyMMddHH'), bst_2009(:,2), rrdate_)*0.1;
bst_2009_W = interp1(datetime(num2str(bst_2009(:,1)), 'InputFormat', 'yyMMddHH'), bst_2009(:,3), rrdate_)*0.1;

bst_2010 = bst_cell{39};
bst_2010_N = interp1(datetime(num2str(bst_2010(:,1)), 'InputFormat', 'yyMMddHH'), bst_2010(:,2), rrdate_)*0.1;
bst_2010_W = interp1(datetime(num2str(bst_2010(:,1)), 'InputFormat', 'yyMMddHH'), bst_2010(:,3), rrdate_)*0.1;

%% 1908
inis_1908 = ~isnan(bst_1908_N);

error_1908 = error(inis_1908);
date_1908 = rrdate_(inis_1908);

bst_1908_n = bst_1908_N(inis_1908);
bst_1908_w = bst_1908_W(inis_1908);

starts = 808;
% 19-08-06 15:10
ends = 1070;
% 19-08-08 11:00

subplot(2, 1, 1)
geoplot(bst_1908_n, bst_1908_w)
hold on;
geoplot(bst_1908_n(starts:ends), bst_1908_w(starts:ends), 'r', 'LineWidth', 1.5)

subplot(2, 1, 2)
plot(date_1908, error_1908)
hold on
plot(date_1908(starts:ends), error_1908(starts:ends), 'r')

% exportgraphics(gcf, '1908.PNG', 'resolution',300)
%% 1910
inis_1910 = ~isnan(bst_1910_N);

error_1910 = error(inis_1910);
date_1910 = rrdate_(inis_1910);

bst_1910_n = bst_1910_N(inis_1910);
bst_1910_w = bst_1910_W(inis_1910);

starts = 1353;
% 19:08-14 09:50
ends = 1666;
% 19-08-16 14:10

subplot(2, 1, 1)
geoplot(bst_1910_n, bst_1910_w)
hold on
geoplot(bst_1910_n(starts:ends), bst_1910_w(starts:ends), 'r', 'LineWidth', 1.5)

subplot(2, 1, 2)
plot(date_1910, error_1910)
hold on
plot(date_1910(starts:ends), error_1910(starts:ends), 'r')

exportgraphics(gcf, '1910.PNG', 'resolution',300)
%% 1917
inis_1917 = ~isnan(bst_1917_N);

error_1917 = error(inis_1917);
date_1917 = rrdate_(inis_1917);

bst_1917_n = bst_1917_N(inis_1917);
bst_1917_w = bst_1917_W(inis_1917);

subplot(2, 1, 1)
geoplot(bst_1917_n, bst_1917_w)
hold on
geoplot(bst_1917_n(749:893), bst_1917_w(749:893), 'r', 'LineWidth', 1.5)

subplot(2, 1, 2)
plot(date_1917, error_1917)
hold on
plot(date_1917(749:893), error_1917(749:893), 'r')

% exportgraphics(gcf, '1917.PNG', 'resolution',300)
%% 1918
inis_1918 = ~isnan(bst_1918_N);

error_1918 = error(inis_1918);
date_1918 = rrdate_(inis_1918);

bst_1918_n = bst_1918_N(inis_1918);
bst_1918_w = bst_1918_W(inis_1918);

starts = 1196;
% 19-10-02 20:20
ends = 1436;
% 19-10-04 12:20

subplot(2, 1, 1)
geoplot(bst_1918_n, bst_1918_w)
hold on
geoplot(bst_1918_n(starts:ends), bst_1918_w(starts:ends), 'r', 'LineWidth', 1.5)

subplot(2, 1, 2)
plot(date_1918, error_1918)
hold on
plot(date_1918(starts:ends), error_1918(starts:ends), 'r')

% exportgraphics(gcf, '1918.PNG', 'resolution',300)
%% 2005
inis_2005 = ~isnan(bst_2005_N);

error_2005 = error(inis_2005);
date_2005 = rrdate_(inis_2005);

bst_2005_n = bst_2005_N(inis_2005);
bst_2005_w = bst_2005_W(inis_2005);

starts = 609;
% 20-08-10 23:30 
ends = 689;
% 20-08-11 12:50

subplot(2, 1, 1)
geoplot(bst_2005_n, bst_2005_w)
hold on
geoplot(bst_2005_n(starts:ends), bst_2005_w(starts:ends), 'r', 'LineWidth', 1.5)

subplot(2, 1, 2)
plot(date_2005, error_2005)
hold on
plot(date_2005(starts:ends), error_2005(starts:ends), 'r')

% exportgraphics(gcf, '2005.PNG', 'resolution',300)
%% 2009
inis_2010= ~isnan(bst_2009_N);

error_2010 = error(inis_2010);
date_2010 = rrdate_(inis_2010);

bst_2010_n = bst_2009_N(inis_2010);
bst_2010_w = bst_2009_W(inis_2010);

subplot(2, 1, 1)
geoplot(bst_2010_n, bst_2010_w)
hold on;
geoplot(bst_2010_n(1007:1150), bst_2010_w(1007:1150), 'r', 'LineWidth', 1.5)

subplot(2, 1, 2)
plot(date_2010, error_2010)
hold on
plot(date_2010(1007:1150), error_2010(1007:1150), 'r')

% exportgraphics(gcf, '2009.PNG', 'resolution',300)
%% 2010
inis_2010= ~isnan(bst_2010_N);

error_2010 = error(inis_2010);
date_2010 = rrdate_(inis_2010);

bst_2010_n = bst_2010_N(inis_2010);
bst_2010_w = bst_2010_W(inis_2010);

starts = 1076;
% 20-09-06 23:10 
ends = 1252;
% 20-09-08 04:30

subplot(2, 1, 1)
geoplot(bst_2010_n, bst_2010_w)
hold on;
geoplot(bst_2010_n(starts:1252), bst_2010_w(starts:1252), 'r', 'LineWidth', 1.5)

subplot(2, 1, 2)
plot(date_2010, error_2010)
hold on
plot(date_2010(starts:1252), error_2010(starts:1252), 'r')

% exportgraphics(gcf, '2010.PNG', 'resolution',300)

%% save
bst_date = [date_1908, date_1910, date_1917, date_1918, date_2005, date_2010]';
bst_nw = [bst_1908_n, bst_1910_n, bst_1917_n, bst_1918_n bst_2005_n, bst_2010_n;
    bst_1908_w, bst_1910_w, bst_1917_w, bst_1918_w, bst_2005_w, bst_2010_w]';


save typhoon_best_track bst_date bst_nw