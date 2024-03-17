clear; close all; clc;

load car_temp.mat;

[Ny, Nx, Nt] = size(img_cut);
Ly = 630;   Lx = 360;   Lt = Nt*1.43;

dy = Ly/Ny;
dx = Lx/Nx;
dt = Lt/Nt;

FFT = fftn(img_cut);
FFT = fftshift(FFT);
FFT = abs(FFT) / Ny / Nx / Nt;

energy_density_2D = 1/(Nt/dt) * sum(FFT, 3);

figure(1);
kx = linspace()
mesh(energy_density_2D);