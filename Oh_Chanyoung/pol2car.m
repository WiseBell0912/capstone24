clear; close; clc;

load polar_temp.mat

ryear = fname0(5:8);
rmon = fname0(9:10);
rday = fname0(11:12);
rhour = fname0(14:15);
rmin = fname0(16:17);

%%%%%%%%%%%%% cut info 
alpha_deg = 329;% box position rotation degree
% beta_deg = 329;% box rotation degree
mdeg = 76;% modification factor for north correction
Ly = 630;%radial direction length / Ly
Lx = 360;%perpendicular direction length / Lx
rcenter = 800+630/2;% radar center to box center range

alpha = deg2rad(90 - alpha_deg);
beta = alpha;

%%%%%%%%%%%%% cut info

%% polar coordinate info

%%%%%%%%%%%%%%
sdrng = 800; %[m]
dr = 3; %[m]
nr = 512;%

nimg = 128;
nbearing = 1080;

theta = linspace(0,2*pi,nbearing);

%%%%%%%%%%%%%%

%% divide radar image
%%%%%%%%%%%%%%%%%%%%%%%%% cut process
%%%%%%%%%% cut 
x = -Lx/2:dr:Lx/2;
y = -Ly/2:dr:Ly/2;
[Xc,Yc] = meshgrid(x,y);

Xtemp = Yc*cos(beta) - Xc*sin(beta);
Ytemp = Yc*sin(beta) + Xc*cos(beta);

Xc = Xtemp + rcenter*cos(alpha);
Yc = Ytemp + rcenter*sin(alpha);

img_cut = single(zeros(size(Xc,1),size(Xc,2),nimg));

% cut range for plot
cutx = Lx*[-0.5 0.5 0.5 -0.5 -0.5];
cuty = Ly*[0.5 0.5 -0.5 -0.5 0.5];

cutxx = cuty*cos(beta) - cutx*sin(beta);
cutyy = cuty*sin(beta) + cutx*cos(beta);

cutX = cutxx + rcenter*cos(alpha);
cutY = cutyy + rcenter*sin(alpha);

%%%%%%%%%% cut 

%%% idx mapping
temp = Xc + Yc*1i;
temp_r = abs(temp);
temp_t = angle(temp);
temp_t = mod( pi/2 - temp_t - deg2rad(mdeg),2*pi);

for ii = 1:nimg
    img_temp = rdata(:,:,ii);

    idx_Tc = floor(temp_t/abs(theta(2)-theta(1))) + 1;
    idx_Rc = floor((temp_r - sdrng)/dr) + 1;
    idx = (idx_Rc + nr * (idx_Tc - 1));
    temp = img_temp(idx);
    vq = griddata(X, Y, double(img_temp), Xc, Yc);
    img_int_cut(:, :, ii) = vq;
    img_cut(:,:,ii) = temp;
end

%% plot

for ii = 1%:nimg
figure(10)
hold off
set(gcf,'position', [500 100 800 600])

surf(X, Y, rdata(:,:,ii), 'edgealpha',0);  
hold on
plot3(cutX,cutY, 500*ones(length(cutX)),'r-','linewidth',2)

axis equal; axis([-2336 2336 -2336 2336]); view(0,90); 
colormap default;    caxis([0 100]);    set(gca,'fontsize',13); grid on; 

xlabel('X [m]');ylabel('Y [m]');title(['RADAR image (ANIN, ' ryear '/'...
        rmon '/' rday ' ' rhour ':' rmin ')'])  
end

% %% image cut plot
% for ii = 1:5%:nimg
% figure(20)
% hold off
% set(gcf,'position', [100 100 800 600])
% surf(Xc, Yc, img_cut(:,:,ii),'edgealpha',0); 
% 
% 
% axis equal
% view(0,90); 
% 
% axis equal; axis([-2336 2336 -2336 2336]); view(0,90); 
% colormap default;    caxis([0 100]);    set(gca,'fontsize',13); grid on; 
% 
% xlabel('X [m]');ylabel('Y [m]');title(['RADAR image (ANIN cut, ' ryear '/'...
%         rmon '/' rday ' ' rhour ':' rmin ')'])  
% end
% 
% %% interpolation plot
% for ii = 1:5%:nimg
% figure(20)
% hold off
% set(gcf,'position', [100 100 800 600])
% surf(Xc, Yc, new_interpolation,'edgealpha',0); 
% 
% 
% axis equal
% view(0,90); 
% 
% axis equal; axis([-2336 2336 -2336 2336]); view(0,90); 
% colormap default;    caxis([0 100]);    set(gca,'fontsize',13); grid on; 
% 
% xlabel('X [m]');ylabel('Y [m]');title(['RADAR image (ANIN cut, ' ryear '/'...
%         rmon '/' rday ' ' rhour ':' rmin ')'])  
% end
% 

%% save cartesian data
save('interpolation_uint8.mat','new_interpolation')
