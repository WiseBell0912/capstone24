clear; close all; clc;
%% Data load
load car_temp.mat;
img = img_cut;
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
%% 3D FFT
image_spectrum_3D = fftn(img);
image_spectrum_3D = fftshift(image_spectrum_3D);
image_spectrum_3D = abs(image_spectrum_3D / Ny / Nx / Nt).^2;
%% High pass filter
W_HP = abs(w) >= 0.1885;
K_HP = 1; %K(:, :, 1) >= 0.0112;
img_spectrum_HPF = zeros(Ny, Nx, Nt);
for i = 1:Nt
    img_spectrum_HPF(:, :, i) = image_spectrum_3D(:, :, i) .* K_HP * W_HP(i);
end
%% Band pass filter
