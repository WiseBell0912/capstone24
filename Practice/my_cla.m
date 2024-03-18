clear; close all; clc;
%% Data load
load car_temp.mat;
img = img_cut;
figure(1)
set(gcf, 'position', [300 0 121*4 211*4]);
surf(img(:, :, 60))
xlim([1 121]); ylim([1 211]);
view(2)
%% Variable setting
g = 9.81;
h = 30;
dt = 1.43;

[Ny, Nx, Nt] = size(img);

Lx = 360;
Ly = 630;
Lt = Nt*dt;

kx = 0 : 1/Lx : (Nx-1)/Lx;      kx = kx - kx(round(end/2)+1);       kx = 2*pi*kx;
ky = 0 : 1/Ly : (Ny-1)/Ly;      ky = ky - ky(round(end/2)+1);       ky = 2*pi*ky;
w = 0 : 1/Lt : (Nt-1)/Lt;       w = w - w(round(end/2)+1);          w = 2*pi*w;
[Kx, Ky, W] = meshgrid(kx, ky, w);
Kx = single(Kx);    Ky = single(Ky);    W = single(W);
K = sqrt(Kx.^2 + Ky.^2);
%% Image normalisation
% 각 픽셀에 대하여 시간에 대한 평균 값을 감산해줌
norm_factor = mean(img, 3);
img_norm = zeros(Ny, Nx, Nt);
for i = 1:Nt
    img_norm(:, :, i) = img(:, :, i) - norm_factor;
end
%% Window function
window_K = hann(Ny) * hann(Nx)';
window_T = hann(Nt);
window = zeros(Ny, Nx, Nt);
for i = 1:Nt
    window(:, :, i) = window_K * window_T(i);
end
img_wind = img_norm .* window;
%% 3D FFT
image_spectrum_3D = fftn(img_wind);
image_spectrum_3D = fftshift(image_spectrum_3D);
image_spectrum_3D = abs(image_spectrum_3D / Ny / Nx / Nt).^2;
%% High pass filter
W_HP = abs(w) >= 0.35; %0.1885;
K_HP = K(:, :, 1) >= 0.03; %0.0112;
img_spectrum_HPF = zeros(Ny, Nx, Nt);
for i = 1:Nt
    img_spectrum_HPF(:, :, i) = image_spectrum_3D(:, :, i) .* K_HP * W_HP(i);
end
%% Determine current velocity
EKx2 = image_spectrum_3D .* Kx.^2;
EKy2 = image_spectrum_3D .* Ky.^2;
EKxKy = image_spectrum_3D .* Kx .* Ky;
Ex = image_spectrum_3D .* ( W - sqrt(g.*K).*Kx );
Ey = image_spectrum_3D .* ( W - sqrt(g.*K).*Ky );
EKx2 = sum(sum(sum(EKx2)));
EKy2 = sum(sum(sum(EKy2)));
EKxKy = sum(sum(sum(EKxKy)));
Ex = sum(sum(sum(Ex)));
Ey = sum(sum(sum(Ey)));
A = [EKx2 EKxKy
    EKxKy EKy2];
B = [Ex
    Ey];
U = A \ B;
Ux = abs(U(1));
Uy = abs(U(2));
%% BPF
criteria1 = sqrt(g.*K.*tanh(K.*h)) + Kx*Ux + Ky*Uy;
criteria2 = -sqrt(g.*K.*tanh(K.*h)) + Kx*Ux + Ky*Uy;
BPV = 2 * (Nt/32) * 2*pi/Lt;
idx = ~((criteria1 - BPV < W & W < criteria1 + BPV) | (criteria2 - BPV < W & W < criteria2 + BPV));
img_spectrum_BPF = image_spectrum_3D .* idx;