clear; close all; clc;

file_list = dir('E:/PNG_2009_2012/*.png');

rad_point = 512;
arc_point = 1080;
time_point = 128;

for ii = 1:length(file_list)
    pngname = ['E:/PNG_2009_2012/' file_list(ii).name];

    date(ii) = datetime(file_list(ii).name(5:end-4), 'InputFormat', 'yyyyMMdd_HHmm');


    pngLong = imread(pngname);
    
    pngLong = pngLong(1 : rad_point * arc_point * time_point);
    pngLong = reshape(pngLong, rad_point, arc_point, time_point);
    pngLong = flip(pngLong, 3);

    pngLong_land = pngLong(:, [168:215, 691:723], :);

    land_energy_level = pngLong_land;
    land_energy_level = mean(land_energy_level);
    land_energy_level = mean(land_energy_level);
    land_energy_level = mean(land_energy_level);

    energy_level(ii) = land_energy_level;

    t = now;
    d = datetime(t,'ConvertFrom','datenum');

    disp([date(ii) d]);
end