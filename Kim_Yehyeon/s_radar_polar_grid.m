clc; clear; close all;
%%
% This script is to make grid data for polar display
% Consume that Radar is rotated 61 degree from original location to face north

%%%%%%%%%%%%%%
sdrng = 800; %[m]
dr = 3; %[m]
nr = 512;
mdeg = 29;% modification factor for north correction

rr = sdrng:dr:sdrng+dr*(nr-1);

nimg = 128;
nbearing = 1080;

theta = linspace(0,2*pi,nbearing);

[Th,R] = meshgrid(theta,rr);

X = R.*cos( deg2rad(90) - Th - deg2rad(mdeg));
Y = R.*sin( deg2rad(90) - Th - deg2rad(mdeg));
%%%%%%%%%%%%%%

save('Grid data', 'X', 'Y')