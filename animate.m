% то же, что circle_animate, но также с анимацией выходного сигнала
function [] = animate(t, y, N, filename, h)

if nargin < 5
    h = 20;
end

figure('Color', 'white');
subplot(1,2,1)

% Статическая единичная окружность
th = 0:0.01:2*pi;
plot(cos(th), sin(th), 'k--', 'LineWidth', 0.8);

% Текстовое поле для отображения времени с поддержкой LaTeX
timeTxt = text(0.05, 1.05, '', 'Units', 'normalized', ...
    'FontSize', 12, ...
    'Color', 'black', ...
    'Interpreter', 'latex', ...
    'String', '$t = 0.00$');

% Подготовка цветов для разных осцилляторов
colors = lines(N);

% Создаём animatedline для каждого осциллятора
h_lines = gobjects(1, N);
for i = 1:N
    h_lines(i) = animatedline('Color', colors(i,:), ...
        'Marker', 'o', 'MarkerFaceColor', colors(i,:), ...
        'MarkerSize', 8);
end

% Настройки DPI и задержки
% dpi = 600;
delayTime = 0.05;

% Узнаем шаг по времени
t_step = t(2)-t(1);

% Цикл анимации + запись кадров в GIF
for step = [1:h:length(t) length(t)]
    subplot(1,2,1)
    for i = 1:N
        phi_i = y(step, 2*i - 1);  % Фаза i-го осциллятора
        x_coord = cos(phi_i);
        y_coord = sin(phi_i);
        
        clearpoints(h_lines(i));
        addpoints(h_lines(i), x_coord, y_coord);
    end
    drawnow limitrate;
    axis off; 
    axis equal;
    
    subplot(1,2,2)
    for i = 1:N
        dphi_i = y(1:step, 2*i);  % Частота i-го осциллятора
        plot(t(1:step),dphi_i,'Color',colors(i,:))
        hold on
    end  
    xlim([t(step)-10*h*t_step t(step)])
    
    % Обновление текста с временем
    set(timeTxt, 'String', sprintf('t = %.2f', t(step)));
    % axis off; 
    % axis equal;
    drawnow limitrate;
    pause(delayTime);  % Замедление анимации для наглядности
    
    % Захватываем текущий график как изображение
    frame = getframe(gcf);
    im = frame2im(frame);                 % Преобразуем в изображение
    [imind, cm] = rgb2ind(im, 256);       % Конвертируем в индексированное изображение
    
    % Сохраняем кадр в GIF
    if step == 1
        imwrite(imind, cm, [filename,'.gif'], 'gif', 'LoopCount', inf, 'DelayTime', delayTime);
    else
        imwrite(imind, cm, [filename,'.gif'], 'gif', 'WriteMode', 'append', 'DelayTime', delayTime);
    end
end

disp(['Анимация успешно сохранена в ', filename]);

end

