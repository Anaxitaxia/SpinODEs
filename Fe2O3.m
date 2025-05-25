% параметры для осциллятора на основе гематита alpha-Fe2O3 и платины
% dAFM --- толщина антиферромагнетика (по умолчанию)
% dNM  --- толщина нормального металла (по умолчанию)
function mtrl = Fe2O3()
    if nargin < 2
        if nargin < 1
            dAFM = 5e-9;
        end
        dNM = 20e-9;
    end
    alpha_G = 6e-4;
    wex = 2 * pi * 24.67e+12;
    we = 2 * pi * 2.8e+6;
    wh = 2 * pi * 5.59e+9;
    wdmi = 2 * pi * 6.16e+10;
    
    Ms = 840e+3;
    lambda = 7.3e-9;
    rho = 4.8e-7;
    tSH = 0.1;
    
    mtrl=Params;
    mtrl=calc(mtrl,dAFM,dNM,alpha_G,wex,we,wh,wdmi,Ms,lambda,rho,tSH);
end