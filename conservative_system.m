% система для описания N консервативно-связанных идентичных осцилляторов
% x     --- вектор-столбец длины 2*N
% Osc   --- объект-осциллятор с заданными физическими параметрами
% jDC   --- вектор-столбец с токами, протекающими через осциллятор i [А/см^2]
% n     --- количество осцилляторов
% r     --- радиус осциллятора (сделанного в виде цилиндра)
% h     --- высота осциллятора (сделанного в виде цилиндра)
% d     --- расстояние между двумя ближайшими осцилляторами
% tplg  --- одно из значений 'chain','circle' или 'grid', определяющее, как
%           связаны осцилляторы: в цепочку, в кольцо, в решётку
% shape --- массив вида [r, c], r - количество строк, c - количество
%           столбцов. Используется только для tplg='grid'
function xdot = conservative_system(t, x, Osc, jDC, n, r, h, d, tplg, shape)
    if nargin==9
        x=t;
    end
    % объём осциллятора
    V0 = pi * r^2 * h;
    zeta = 2 * V0 * Osc.Bs * Osc.wdmi^2 / (d^3 * Osc.wex/(Osc.gamma));
    % величина для приведения к безразмерному виду [Гц]
    w0 = sqrt(Osc.we * Osc.wex);
    
    % матрицы размера n*n для вычисления матрицы связи
    i_ind = repmat(1:n,n,1)'; % [[1 ... 1], [2...2] ,..., [n...n]]
    j_ind = repmat(1:n,n,1);  % [[1 ... n], [1...n] ,..., [1...n]]
    
    % суммируемые (по строке, т.е. по j) нелинейные слагемые системы
    phases = x(1:2:2*n);
    cos_sum = cos(phases(i_ind) + phases(j_ind));
    sin_sum = sin(phases(i_ind) + phases(j_ind));
    sin_diff = sin(phases(i_ind) - phases(j_ind));
    
    % вычисление коэффициентов связи в зависимости от топологии tplg
    ki1 = zeros(n);
    ki2 = zeros(n);
    ki3 = zeros(n);
    switch tplg
        case 'chain'
            ki2 = (zeta./(abs(i_ind - j_ind).^3));
            ki3 = ki2;
        case 'circle'
            ki1_1 = sin(2 * pi/n.*(i_ind + j_ind));
            a = (abs(sin(pi/n.*(i_ind - j_ind)))).^3;
            ki1 = zeta * (sin(pi/n))^3./ a.*ki1_1;
            ki2 = zeta * (sin(pi/n))^3./ a;
            ki3_1 = cos(2 * pi/n.*(i_ind + j_ind));
            ki3 = zeta * (sin(pi/n))^3./ a.*ki3_1;
        case 'grid'
            % матрицы размера n*n для вычисления матрицы связи
            % [[1...c r раз 1...c], ... , [1...c r раз 1...c]]
            qcj = repmat(repmat(1:shape(2),1,shape(1)),n,1);
            % [[1...1], ... , [c ... c] r раз]
            qci = qcj';
            str = ones(1,n);
            for row = 0:shape(1)-1
                str(1+shape(2)*row:shape(2)+shape(2)*row) = (row + 1) * ones(1, shape(2));
            end
            % [[1 c раз 1 ... r c раз r] n раз]
            qrj = repmat(str,n,1);
            % [[1 ... 1] c раз ... [r ... r] c раз]
            qri = qrj'; 
            b = ((qri - qrj).^2 + (qci - qcj).^2);
            % в частном случае n=5, shape=[1,5] совпадают с цепочкой
            % вычислять ТОЛЬКО так! Не упрощать!
            ki1 = 2 * zeta./b.^(3/2).*((qri-qrj).*(qci-qcj)./b);
            ki2 = zeta./b.^(3/2);
            ki3 = zeta./b.^(3/2).*(((qci-qcj).^2-(qri-qrj).^2)./b);
    end    
    
    % нулевые элементы на диагоналях
    ki1(~isfinite(ki1)) = 0;
    ki2(~isfinite(ki2)) = 0;
    ki3(~isfinite(ki3)) = 0;
                    
    xdot(1:2:2*n,1) = x(2:2:2*n); 
    xdot(2:2:2*n,1) = -Osc.alpha * Osc.wex * x(2:2:2*n) / w0 - ...
            0.5 * Osc.we * Osc.wex * sin(2 * x(1:2:2*n)) / w0^2 - ...
            1.5 * sum(ki1 * cos_sum,2) / w0^2 + ...
            0.5 * sum(ki2 * sin_diff,2) / w0^2 - ...
            1.5 * sum(ki3 * sin_sum,2) / w0^2 + ...
            Osc.tSTT * 1e+4 * Osc.wex * jDC / w0^2;
end

