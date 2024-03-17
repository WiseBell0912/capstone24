function fun_anin_display(data, nimg, i)
% DATA를 극좌표로 보여주는 함수
% Input은 선택 데이터
% nimage 보여줄 이미지 장수(최대 129)
% i 보여줄 시간대 (1시간 기준 1-6 사이)


%%%%%%%%%%%%%%
sdrng = 800; %[m]
dr = 3; %[m]
nr = 512;

rr = sdrng:dr:sdrng+dr*(nr-1);

nbearing = 1080;

theta = linspace(0,2*pi,nbearing);

[Th,R] = meshgrid(theta,rr);

X = R.*cos(deg2rad(14) - Th);
Y = R.*sin(deg2rad(14) - Th);
%%%%%%%%%%%%%%

for ii = 1:nimg%nimg

figure(ii)
hold off
set(gcf,'position', [100 100 1200 800])

surf(X, Y, data(:,:,ii, i), 'edgealpha',0);  

axis equal; axis([-2350 2350 -2350 2350]); 
view(0,90); 
colormap jet;    clim([0 255]);    set(gca,'fontsize',13); grid on; 
end