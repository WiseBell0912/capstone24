clear; close all; clc

load result1st2019.mat 
noise_2019 = noise;
Pdir_2019 = Pdir;
signal_2019 = signal;
SNR_2019 = SNR;
Tp_2019 = Tp;

load result1st2020.mat 
noise_2020 = noise;
Pdir_2020 = Pdir;
signal_2020 = signal;
SNR_2020 = SNR;
Tp_2020 = Tp;

load result1st2021.mat 
noise_2021 = noise;
Pdir_2021 = Pdir;
signal_2021 = signal;
SNR_2021 = SNR;
Tp_2021 = Tp;

noise = [noise_2019,noise_2020,noise_2021];
Pdir = [Pdir_2019,Pdir_2020,Pdir_2021];
signal = [signal_2019,signal_2020,signal_2021];
SNR = [SNR_2019,SNR_2020,SNR_2021];
Tp = [Tp_2019,Tp_2020,Tp_2021];

save 'result1st_new.mat' noise Pdir signal SNR Tp



