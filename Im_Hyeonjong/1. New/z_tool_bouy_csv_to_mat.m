%% csv 형태의 부이 데이터를 mat 형태의 데이터로 변경해주는 스크립트
clear; close all; clc;

%% csv 형태의 부이 데이터 로드 (로드 파일명 수정 필요)
filename = "2. Data/Bouy/bouy_Hs_2023_07.csv";

% 데이터 로드 옵션 감지
opts = detectImportOptions(filename);

% 감지된 열 이름 출력
disp('Detected column names:');
disp(opts.VariableNames);

% 감지된 열 이름 수정
opts.VariableNames = [{'date'}, {'Hs'}];

% 감지된 구별 문자 수정
opts.Delimiter = {','};

% 감지된 날짜 형식에 맞춰 수정
opts = setvartype(opts, 'date', 'datetime');
opts = setvaropts(opts, 'date', 'InputFormat', 'yyyy/MM/dd HH:mm:ss'); % csv에 쓰인 형식에 맞춰 변경 필요

% 변경 된 옵션으로 데이터 로드
data = readtable(filename, opts);

%% 날짜와 유의파고 별개 추출
date = data.date';
Hs = data.Hs';

%% 저장 (저장 파일명 수정 필요)
save bouy_Hs_2023_07 date Hs