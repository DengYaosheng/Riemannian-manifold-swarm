% 定义粒子在流形上的初始位置和速度
x0 = [1; 2; 3];
v0 = [0.1; -0.2; 0.3];

% 定义粒子在流形上运动的时间
t = linspace(0, 10, 1000);
% 计算粒子在四维空间中的位置和速度
y = zeros(4, length(t));
v = zeros(4, length(t));
y(:, 1) = embedding_function(x0);
v(:, 1) = embedding_function(v0);
for i = 2:length(t)
    dt = t(i) - t(i-1);
    x = y(1:3, i-1);
    v_prev = v(:, i-1);
    y(:, i) = embedding_function(x + dt * v_prev(1:3));
    v(:, i) = [v_prev(1:3); 2 * x(1) * v_prev(1) + 2 * x(2) * v_prev(2) + 2 * x(3) * v_prev(3) + v_prev(4)];
end

% 绘制粒子在流形上的运动轨迹
figure;
plot3(y(1,:), y(2,:), y(3,:), 'LineWidth', 2);
grid on;
xlabel('x');
ylabel('y');
zlabel('z');
title('Particle motion on a manifold');



function y = embedding_function(x)
% 定义流形嵌入函数
% 输入参数：
% x - 一个长度为 3 的列向量，表示在三维空间中的位置
% 输出参数：
% y - 一个长度为 4 的列向量，表示在四维空间中的位置
    y = [x(1); x(2); x(3); x(1)^2 + x(2)^2 + x(3)^2];
end
function y = embedding_function2(x)
% 定义流形嵌入函数
% 输入参数：
% x - 一个长度为 3 的列向量，表示在三维空间中的位置
% 输出参数：
% y - 一个长度为 4 的列向量，表示在四维空间中的位置
    y = [x(1); x(2); x(3); x(1)^2 + x(2)^2 + x(3)^2];
end
