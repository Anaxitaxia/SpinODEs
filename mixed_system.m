% система для описания N смешанно-связанных идентичных осцилляторов
% x     --- вектор-столбец длины 2*N
% Osc   --- объект-осциллятор с заданными физическими параметрами
% jDC   --- вектор-столбец с токами, протекающими через осциллятор i [А/см^2]
% n     --- количество осцилляторов
% r     --- радиус осциллятора (сделанного в виде цилиндра)
% h     --- высота осциллятора (сделанного в виде цилиндра)
% d     --- расстояние между двумя ближайшими осцилляторами
% tplg  --- сейчас только 'chain'. Формулы для других значений неизвестны
function xdot = mixed_system(t, x, Osc, jDC, n, r, h, d, tplg) % shape
    if nargin==8 % 9
        x=t;
    end
    
    V0 = pi * r^2 * h;
    zeta = 2 * V0 * Osc.Bs * Osc.wdmi^2 / (d^3 * Osc.wex/(Osc.gamma));
    w0 = sqrt(Osc.we * Osc.wex);
    kappa = Osc.tSP / n;
    Osc.alpha = Osc.alpha + kappa;
    
    i_ind = repmat(1:n,n,1)';
    j_ind = repmat(1:n,n,1);
    
    phases = x(1:2:2*n);
    cos_sum = cos(phases(i_ind) + phases(j_ind));
    sin_sum = sin(phases(i_ind) + phases(j_ind));
    sin_diff = sin(phases(i_ind) - phases(j_ind));

    ki1 = zeros(n);
    ki2 = zeros(n);
    ki3 = zeros(n);
    switch tplg
        case 'chain'
            ki2 = (zeta./(abs(i_ind - j_ind).^3));
            ki3 = ki2;
    end    
    
    ki1(~isfinite(ki1)) = 0;
    ki2(~isfinite(ki2)) = 0;
    ki3(~isfinite(ki3)) = 0;
                    
    xdot(1:2:2*n,1) = x(2:2:2*n); 
    xdot(2:2:2*n,1) = -Osc.alpha * Osc.wex * x(2:2:2*n) / w0 - ...
            0.5 * Osc.we * Osc.wex * sin(2 * x(1:2:2*n)) / w0^2 - ...
            1.5 * sum(ki1 * cos_sum,2) / w0^2 + ...
            0.5 * sum(ki2 * sin_diff,2) / w0^2 - ...
            1.5 * sum(ki3 * sin_sum,2) / w0^2 + ...
            Osc.tSTT * 1e+4 * Osc.wex * jDC / w0^2 - ...
            kappa * Osc.wex.* sum(x(2:2:2*n)) / w0 + ...
            kappa * Osc.wex.* x(2:2:2*n) / w0;
end

