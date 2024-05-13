%% wave parameter를 구하기 위해 이미지 자르는 스크립트
clear; close all; clc;

%% pngLong 불러오기
pngname = '/Users/imhyeonjong/Documents/POL/AIB_20210610_0000.png';
rdata = imread(pngname);

%% date 저장
date = datetime(pngname(end-16:end-4), 'Inputformat', 'yyyyMMdd_HHmm');

%% pngLong 기본 정보
png_count = 128;

r_count = 512;
r_in = 800;
r_out = 2333;
r_delta = 3;

th_count = 1080;
th_modify = 62; % modification factor for north correction

%% pngLong 을 위한 그리드 생성
r = r_in : r_delta : r_out;

th = linspace(0, 2*pi, th_count);

[Th,R] = meshgrid(th,r);

X = R .* cos(Th + deg2rad(th_modify));
Y = R .* sin(Th + deg2rad(th_modify));

%% 타임 시퀀스에 맞게 pngLong 수정
rdata = rdata(1 : r_count*th_count*png_count);
rdata = reshape(rdata, r_count, th_count, png_count);
rdata = flip(rdata,3);
rdata = flip(rdata,2);

%% 출력 확인
figure(1);
set(gcf,'position', [500 100 800 600]);
k = surf(X, Y, rdata(:, :, 1), 'EdgeAlpha', 0);
axis equal; axis([-2336 2336 -2336 2336]); 
view(0,90); 
hold on;
%k.FaceAlpha = 0.5;
%I = imread([pwd '/check1.png']); 
%h = image(xlim,-ylim,I); 
%uistack(h,'bottom')
%surf(X(:, 1:2), Y(:, 1:2), rdata(:, 1:2, 1));

%% box 기본 정보 1
box_deg = (90 - th_modify + 14) - 121;
box_rad = deg2rad(box_deg);
box_x = 630;
box_y = 360;
box_center = 900 + box_x/2;

%% box 를 위한 그리드 생성 1
x = -box_x/2 : r_delta : box_x/2;
y = -box_y/2 : r_delta : box_y/2;
[Xc,Yc] = meshgrid(x,y);

Xtemp = Xc*cos(box_rad) - Yc*sin(box_rad);
Ytemp = Xc*sin(box_rad) + Yc*cos(box_rad);

Xc = Xtemp + box_center*cos(box_rad);
Yc = Ytemp + box_center*sin(box_rad);

%% 박스 경계 1
cut_x = x([1, end]);
cut_y = y([1, end]);
[cut_Xc, cut_Yc] = meshgrid(cut_x, cut_y);

cut_Xtemp = cut_Xc*cos(box_rad) - cut_Yc*sin(box_rad);
cut_Ytemp = cut_Xc*sin(box_rad) + cut_Yc*cos(box_rad);

cut_Xc = cut_Xtemp + box_center*cos(box_rad);
cut_Yc = cut_Ytemp + box_center*sin(box_rad);

surf(cut_Yc, cut_Xc, [100, 100; 100, 100], 'FaceAlpha', 0, 'EdgeColor', 'r', 'LineWidth', 2);

%% box 추출 1
img_cut_surf = single( zeros(size(Xc,1), size(Xc,2), png_count) );

temp = Xc + Yc * 1i;
temp_r = abs(temp);
temp_th = angle(temp);
temp_th = mod(deg2rad(90 - th_modify) - temp_th, 2*pi);

for ii = 1:1
    img_temp = rdata(:,:,ii);
    
    idx_Tc = floor(temp_th/abs(th(2)-th(1))) + 1;
    idx_Rc = floor((temp_r - r_in)/r_delta) + 1;
    idx = (idx_Rc + r_count * (idx_Tc - 1));
    temp = img_temp(idx);
    img_cut_surf(:,:,ii) = temp;
end

%% box 기본 정보 2
box_deg = (90 - th_modify + 14) - 84;
box_rad = deg2rad(box_deg);
box_x = 630;
box_y = 360;
box_center = 1150 + box_x/2;

%% box 를 위한 그리드 생성 2
x = -box_x/2 : r_delta : box_x/2;
y = -box_y/2 : r_delta : box_y/2;
[Xc,Yc] = meshgrid(x,y);

Xtemp = Xc*cos(box_rad) - Yc*sin(box_rad);
Ytemp = Xc*sin(box_rad) + Yc*cos(box_rad);

Xc = Xtemp + box_center*cos(box_rad);
Yc = Ytemp + box_center*sin(box_rad);

%% 박스 경계 2
cut_x = x([1, end]);
cut_y = y([1, end]);
[cut_Xc, cut_Yc] = meshgrid(cut_x, cut_y);

cut_Xtemp = cut_Xc*cos(box_rad) - cut_Yc*sin(box_rad);
cut_Ytemp = cut_Xc*sin(box_rad) + cut_Yc*cos(box_rad);

cut_Xc = cut_Xtemp + box_center*cos(box_rad);
cut_Yc = cut_Ytemp + box_center*sin(box_rad);

surf(cut_Yc, cut_Xc, [100, 100; 100, 100], 'FaceAlpha', 0, 'EdgeColor', 'r', 'LineWidth', 2);

%% box 추출 2
img_cut_wave = single( zeros(size(Xc,1), size(Xc,2), png_count) );

temp = Xc + Yc * 1i;
temp_r = abs(temp);
temp_th = angle(temp);
temp_th = mod(deg2rad(90 - th_modify) - temp_th, 2*pi);

for ii = 1:1
    img_temp = rdata(:,:,ii);
    
    idx_Tc = floor(temp_th/abs(th(2)-th(1))) + 1;
    idx_Rc = floor((temp_r - r_in)/r_delta) + 1;
    idx = (idx_Rc + r_count * (idx_Tc - 1));
    temp = img_temp(idx);
    img_cut_wave(:,:,ii) = temp;
    
end

%figure(2);
%surf(Yc, Xc, img_cut(:, :, 1), 'EdgeAlpha', 0);
%set(gcf,'position', [500 100 800 600]);
%axis equal; axis([-2336 2336 -2336 2336]); 
%view(0,90);

