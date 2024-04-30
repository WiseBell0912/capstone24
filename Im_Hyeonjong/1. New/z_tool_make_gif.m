%%
clear; close all; clc;

pngLong = imread('C:\Users\Administrator\Desktop\PNG\AIB_20211201_1000.png' );

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

X = R .* cos(deg2rad(119) + T);
Y = R .* sin(deg2rad(119) + T);

%%
file_list = dir('C:/Users/Administrator/Desktop/eee/*.png');

for i = 1 : length(file_list)

    pngname = [file_list(i).folder '\' file_list(i).name];
    pngLong = imread(pngname);
    pngLong = pngLong(1 : rad_point * arc_point * time_point);
    pngLong = reshape(pngLong, rad_point, arc_point, time_point);
    pngLong = flip(pngLong, 3);

    vidObj = VideoWriter(file_list(i).name(1:17), 'Motion JPEG AVI');
    vidObj.Quality = 100;
    vidObj.FrameRate = 3.14;
    open(vidObj);

    for j = 1: 128
        figure(1);
        set(gcf, 'position', [0 0 900 900])
        surf(X, Y, pngLong(:, :, j), 'EdgeAlpha', 0);
        title(['Radar Image : ' file_list(i).name(5:8) '/' file_list(i).name(9:10) '/' file_list(i).name(11:12) ' (frame number : ' num2str(j) ')']);
        axis equal;
        axis([-rad_out rad_out -rad_out rad_out]);
        view(0, 90);

        currFrame = getframe(1);
        writeVideo(vidObj,currFrame);

    end

    close(vidObj);

end