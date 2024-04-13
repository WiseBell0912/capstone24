%% pngLong 을 pngPPI 로 변환하는 스크립트

clear; close all; clc;

%% pngLong 을 읽어드림
pngLong = imread('D:/PNG_2107_2306/AIB_20220517_0050.png');

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
figure(1);

for i = 1 : time_point
    surf(X, Y, pngLong(:, :, i), 'EdgeAlpha', 0);
    hold on;
    %surf(X(:, [1 2]), Y(:, [1 2]), pngLong(:, [1 2], i));
    surf(X([1 2 511 512], [691 692 722 723]), Y([1 2 511 512], [691 692 722 723]), pngLong([1 2 511 512], [691 692 722 723], i));
    surf(X([1 2 511 512], [168 169 214 215]), Y([1 2 511 512], [168 169 214 215]), pngLong([1 2 511 512], [168 169 214 215], i));
    hold off;

    axis equal;
    axis([-rad_out rad_out -rad_out rad_out]);
    view(0, 90);

    pause(0.1);
end