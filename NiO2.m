% параметры для осциллятора на основе оксида никеля 2 NiO2 и платины
% ТОЛЬКО для single_system и resistive_system
% dAFM --- толщина антиферромагнетика (по умолчанию)
% dNM  --- толщина нормального металла (по умолчанию)
function mtrl = NiO2(dAFM, dNM)
    if nargin < 2
        if nargin < 1
            dAFM = 5e-9;
        end
        dNM = 20e-9;
    end
    alpha_G = 6e-4;
    wex = 2 * pi * 27.5e+12;
    we = 2 * pi * 1.75e+9;
    wh = 2 * pi * 4.39e+10;
    wdmi = 0;
    
    Ms = 351e+3;
    lambda = 7.3e-9;
    rho = 4.8e-7;
    tSH = 0.1;
    
    mtrl=Params;
    mtrl=calc(mtrl,dAFM,dNM,alpha_G,wex,we,wh,wdmi,Ms,lambda,rho,tSH);
    
end