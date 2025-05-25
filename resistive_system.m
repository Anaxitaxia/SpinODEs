% система для описания N резистивно-связанных идентичных осцилляторов
% x   --- вектор-столбец длины 2*N
% Osc --- объект-осциллятор с заданными физическими параметрами
% jDC --- вектор-столбец с токами, протекающими через осциллятор i [А/см^2]
% n   --- количество осцилляторов
function xdot = resistive_system(t, x, Osc, jDC, n)
    if nargin==4
        x=t;
    end
    % величина для приведения к безразмерному виду [Гц]
    w0 = sqrt(Osc.we * Osc.wex);
    % коэффициент связи
    kappa = Osc.tSP / n;
    % влияние связи на затухание
    Osc.alpha = Osc.alpha + kappa;
    
    xdot(1:2:2*n,1) = x(2:2:2*n);
    xdot(2:2:2*n,1) = -Osc.alpha * Osc.wex.* x(2:2:2*n) / w0 - ...
            0.5 * Osc.we * Osc.wex.* sin(2.* x(1:2:2*n)) / w0^2 + ...
            Osc.tSTT * 1e+4 * Osc.wex.* jDC / w0^2 - ...
            kappa * Osc.wex.* sum(x(2:2:2*n)) / w0 + ...
            kappa * Osc.wex.* x(2:2:2*n) / w0;
end

