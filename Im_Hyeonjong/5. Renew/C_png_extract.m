clear; close all; clc;

%% 레이더 이미지 중 필요한 것만 따로 저장

path_1 = '/Users/imhyeonjong/Documents/POL/'; % 레이더 이미지의 위치
path_2 = ''; % 따로 저장할 위치

file_list = dir([path_1, '*.png']);

png_year = '0000'; % year (5:8)
png_month = '00'; % month (9:10)
png_day = '00'; % day (11:12)
png_hour = '00'; % hour (14:15)
png_minute = '00'; % minute (16:17)

for i = 1 : length(file_list)
    name = file_list(i).name;
    if name(5:8) == png_year & name(9:10) == png_month & name(11:12) == png_day & name(16:17) == png_minute
        png = [file_list(i).folder '/' file_list(i).name];
        copyfile(png, path_2);
    end
end