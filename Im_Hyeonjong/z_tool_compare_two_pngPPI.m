%% pngPPI 두 개를 비교하는 스크립트

clear; close all; clc;

%% pngLong 을 읽어드림
pngLong = imread([pwd, '/PNG/AIB_20190815_0450.png']);

%% 초기 설정
rad_in = 800; % = 800m
rad_out = 2336; % ~= 2300m
rad_point = 512;
rad_step = 3; % = 3m

arc_point = 1080;

time_step = 3;
time_point = 128;

%% 극좌표계 그리드 생성
rad_grid = (rad_in) : (rad_step) : (rad_out - rad_step);
arc_grid = linspace(0, 2*pi, arc_point);

[T, R] = meshgrid(arc_grid, rad_grid);

pngLong = pngLong(1 : rad_point * arc_point * time_point);
pngLong = reshape(pngLong, rad_point, arc_point, time_point);
pngLong = flip(pngLong, 3);

X = R .* cos(T);
Y = R .* sin(T);

%% figure 표시
figure(2);
tiledlayout(1, 2);

pngLong = imread([pwd, '/PNG4/AIB_20190711_1940.png']);
pngLong = pngLong(1 : rad_point * arc_point * time_point);
pngLong = reshape(pngLong, rad_point, arc_point, time_point);
pngLong = flip(pngLong, 3);
nexttile;
surf(X, Y, pngLong(:, :, 1), 'EdgeAlpha', 0);
hold on;
surf(X([1 512], [691 723]), Y([1 512], [691 723]), pngLong([1 512], [691 723]));
surf(X([1 512], [168 215]), Y([1 512], [168 215]), pngLong([1 512], [168 215]));
hold off;
title('not rainy', 'energy level = 59.8781', 'FontSize', 30);
axis equal;
axis([-rad_out rad_out -rad_out rad_out]);
view(0, 90);

pngLong = imread([pwd, '/PNG/AIB_20190815_0450.png']);
pngLong = pngLong(1 : rad_point * arc_point * time_point);
pngLong = reshape(pngLong, rad_point, arc_point, time_point);
pngLong = flip(pngLong, 3);
nexttile;
surf(X, Y, pngLong(:, :, 1), 'EdgeAlpha', 0);
hold on;
surf(X([1 512], [691 723]), Y([1 512], [691 723]), pngLong([1 512], [691 723]));
surf(X([1 512], [168 215]), Y([1 512], [168 215]), pngLong([1 512], [168 215]));
hold off;
title('rainy', 'energy level = 81.1913', 'FontSize', 30);
axis equal;
axis([-rad_out rad_out -rad_out rad_out]);
view(0, 90);