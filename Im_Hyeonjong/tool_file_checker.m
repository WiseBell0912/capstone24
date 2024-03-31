%% <섹션 실행으로 코드 실행 필수>
clear; close all; clc;
%% D 드라이브에 있는 레이더 이미지의 date 를 확인

file_list = dir("D:/POL_2202/*.pol"); % 바꾸기!!!

for i = 1 : length(file_list)
    date_datetime1(i, 1) = datetime(file_list(i).name(5:17), 'InputFormat', 'yyyyMMdd_HHmm', 'Format', 'yyyyMMddHHmm');
    date_datenum1(i, 1) = datenum(date_datetime1(i, 1));
end

j = 0;
for i = 1 : length(file_list) - 1
    if date_datetime1(i+1) - date_datetime1(i) ~= date_datetime1(2) - date_datetime1(1)
        j = j + 1;
        strange_datetime(j, 1) = date_datetime1(i);
        strange_duration(j, 1) = date_datetime1(i+1) - date_datetime1(i);
        strange_index(j, 1) = i;
    end
end

clear file_list i j
%% 저장
save radar_HDD_2021-06-10_2022-02-28 % 바꾸기!!!