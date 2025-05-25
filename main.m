% MATLAB R2018a
clearvars;
close all;
clc;

set(0,'DefaultAxesFontSize',14,'DefaultAxesFontName','Arial Cyr'); 
set(0,'DefaultTextFontSize',14,'DefaultTextFontName','Arial Cyr');
LW = 'LineWidth';
lw = 1.5;

%% Integration Parameters
tspan = 0:1e-2:1e+3;

%% Single oscillator
IC = [0; 0];
jDC = 2e+8;

[t, xs] = ode15s(@(t, x) single_system(t,x,NiO2(),jDC), tspan, IC);

figure('Color','White');  
plot(t,xs(:,2), 'b', LW, lw)

%% Resistively Coupled Oscillators
N = 5;
rng('default')
IC = zeros(2 * N,1);
% можно исследовать поведение системы с разными токами
jDC = [4.95; 4.975; 5; 5.025; 5.05]*1e+8;
% а можно исследовать поведение системы с разными н.у.
% IC(1:2:2*N,1) = random('Normal',0,0.2*pi,N,1);
% jDC = ones(N,1) * 5e+8;
% а можно и с тем, и с другим

[t, xs] = ode15s(@(t, x) resistive_system(t,x,NiO2(),jDC,N), tspan, IC);

% animate(t, xs, N, 'probe',500) % очень медленно
circle_animate(t, xs, N, 'probe',500)


%% Chain of Conservatively Coupled Oscillators
N = 5;
rng('default')
IC = zeros(2 * N,1);
IC(1:2:2*N,1) = random('Normal',0,0.2*pi,N,1);
jDC = ones(N,1) * 3e+8;

r = 10e-9;
h = 20e-9;
d = 20e-9;
[t, xs] = ode15s(@(t, x) conservative_system(t,x,Fe2O3(),jDC,N,r,h,d,'chain',[1,5]), tspan, IC);

circle_animate(t, xs, N, 'probe',500)

%% Circle of Conservatively Coupled Oscillators
N = 5;
rng('default')
IC = zeros(2 * N,1);
IC(1:2:2*N,1) = random('Normal',0,0.2*pi,N,1);
jDC = ones(N,1) * 3e+8;

r = 10e-9;
h = 20e-9;
d = 20e-9;
[t, xs] = ode15s(@(t, x) conservative_system(t,x,Fe2O3(),jDC,N,r,h,d,'circle',N), tspan, IC);

circle_animate(t, xs, N, 'probe',500)

%% Grid of Conservatively Coupled Oscillators
N = 6;
rng('default')
IC = zeros(2 * N,1);
IC(1:2:2*N,1) = random('Normal',0,0.2*pi,N,1);
jDC = ones(N,1) * 3e+8;

r = 10e-9;
h = 20e-9;
d = 20e-9;
[t, xs] = ode15s(@(t, x) conservative_system(t,x,Fe2O3(),jDC,N,r,h,d,'grid',[2,3]), tspan, IC);

circle_animate(t, xs, N, 'probe',500)

%% Chain of Conservatively and Resistively Coupled Oscillators
N = 5;
rng('default')
IC = zeros(2 * N,1);
IC(1:2:2*N,1) = random('Normal',0,0.2*pi,N,1);
jDC = ones(N,1) * 3e+8;

r = 10e-9;
h = 20e-9;
d = 20e-9;
[t, xs] = ode15s(@(t, x) mixed_system(t,x,Fe2O3(),jDC,N,r,h,d,'chain'), tspan, IC);

circle_animate(t, xs, N, 'probe',500)