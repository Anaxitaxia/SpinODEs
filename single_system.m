% система для описания единичного осциллятора
% x   --- вектор-столбец длины 2
% Osc --- объект-осциллятор с заданными физическими параметрами
% jDC --- значение тока, протекающего через осциллятор [А/см^2]
function sol = single_system(t, x, Osc, jDC)
    if nargin==3
        x=t;
    end
    % величина для приведения к безразмерному виду [Гц]
    w0 = sqrt(Osc.we * Osc.wex);
    dx1 = x(2);
    dx2 = -Osc.alpha * Osc.wex * x(2) / w0 - ...
        0.5 * Osc.we * Osc.wex * sin(2 * x(1)) / w0^2 + ...
        Osc.tSTT * 1e+4 * Osc.wex * jDC / w0^2;
    sol = [dx1; dx2];
end

