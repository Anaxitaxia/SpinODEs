% вычисление параметров осциллятора
classdef Params

    properties
        alpha;
        wex;
        we;
        wh;
        wdmi;
        tSTT;
        gamma;
        Bs;
        tSP;
        d;
    end
    methods
        function obj = calc(obj, dAFM,dNM,alpha_G,omega_ex,omega_e,omega_h,omega_dmi,Ms,lambda,rho,tSH)
            mu_0=1.26e-6; %магнитная постоянная Н/А^2
            hbar=1.054571817e-34; %Дж*с
            gr = 6.9e+18; % 1/м^2
            qe = 1.602176634e-19; %Кулон
            obj.gamma = 2 * pi * 28E+9;
            obj.wex = omega_ex;
            obj.we = omega_e;
            obj.wh = omega_h;
            obj.wdmi = omega_dmi;
            obj.d = dAFM;
            
            obj.tSTT = tSH * gr * qe * obj.gamma * lambda * rho...
                / (4 * pi * Ms * dAFM) * tanh(dNM/(2 * lambda));
            obj.tSP = obj.gamma * hbar * gr / (8 * pi * Ms * dAFM);
            obj.alpha = alpha_G + obj.tSP;

            obj.Bs = mu_0 * Ms; % Тл           
        end
    end
end

