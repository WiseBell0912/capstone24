%% <섹션 실행으로 코드 실행 필수>
clear; close all; clc;
%% D 드라이브에 있는 레이더 이미지의 date 를 확인

file_list = dir("D:/PNG_2107_2306/*.png"); % 바꾸기!!!

for i = 1 : length(file_list)
    date_datetime(i, 1) = datetime(file_list(i).name(5:17), 'InputFormat', 'yyyyMMdd_HHmm', 'Format', 'yyyyMMddHHmm');
    date_datenum(i, 1) = datenum(date_datetime(i, 1));
end

j = 0;
for i = 1 : length(file_list) - 1
    if date_datetime(i+1) - date_datetime(i) ~= date_datetime(2) - date_datetime(1)
        j = j + 1;
        strange_datetime(j, 1) = date_datetime(i);
        strange_duration(j, 1) = date_datetime(i+1) - date_datetime(i);
        strange_index(j, 1) = i;
    end
end

clear file_list i j
disp(date_datetime(1));
disp(date_datetime(end));
%% 저장
save radar_png_check_202107010000_202307010000 % 바꾸기!!!