%% 결측치를 찾아주는 스크립트
clear; close all; clc;

%% 결측치를 찾을 데이터 로드
load([pwd, '/Wave Parameter/wave_parameter_1907_2307.mat']);
date = radar_date;

%% 결측 취급 기간 설정
duration_set = duration(0, 20, 0); % 시, 분, 초

%% 결측치 확인
count = 0;
for i = 1 : (length(date) - 1)
    if (date(i+1) - date(i)) > duration_set
        count = count + 1;
        missing_date(1, count) = date(i); % 결측 시작일
        missing_date(2, count) = date(i+1); % 결측 마침일
        missing_duration(count) = date(i+1) - date(i); % 결측 기간
    end
end