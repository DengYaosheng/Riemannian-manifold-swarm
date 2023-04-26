% 球面坐标系下的目标点坐标（纬度、经度）
target_lat = 30;  % 目标点纬度
target_lon = 60;  % 目标点经度

% Swarm中智能体数量
num_agents = 10;

% Swarm智能体的初始位置坐标（纬度、经度）
agent_lat = rand(num_agents, 1) * 180 - 90;  % 随机生成[-90, 90]之间的纬度
agent_lon = rand(num_agents, 1) * 360 - 180;  % 随机生成[-180, 180]之间的经度

% 智能体的初始速度和加速度
agent_v = zeros(num_agents, 2);  % 初始速度
agent_a = zeros(num_agents, 2);  % 初始加速度

% 定义potential field的参数
k_att = 0.1;  % 吸引力系数
k_rep = 0.5;  % 排斥力系数
d_rep = 10;   % 排斥力作用距离

% 开始模拟
for t = 1:1000   % 模拟1000个时间步
    % 计算每个智能体受到的虚拟力
    F_att = -k_att * (agent_lat - target_lat) -k_att * cosd(agent_lat) .* (agent_lon - target_lon);   % 吸引力
    F_rep = zeros(num_agents, 2);   % 排斥力
    for i = 1:num_agents
        for j = 1:num_agents
            if i == j
                continue;
            end
            dist = greatCircleDist([agent_lat(i), agent_lon(i)], [agent_lat(j), agent_lon(j)], 1);  % 计算两个点之间的大圆距离
            if dist < d_rep
                F_rep(i, :) = F_rep(i, :) + k_rep * (1/dist - 1/d_rep)^2 * (agent_lat(i)-agent_lat(j))/dist^2;   % 排斥力的计算公式
            end
        end
    end
    F = F_att + F_rep;   % 总虚拟力

    % 计算智能体的加速度和速度
    agent_a = F;
    agent_v = agent_v + agent_a;
    
    % 更新智能体的位置
    [agent_lat, agent_lon] = moveOnSphere(agent_lat, agent_lon, agent_v, 1);  % 通过移动球面上的点来更新智能体的位置

    % 绘制智能体位置的散点图
    figure(1);
    clf;
    scatter(agent_lon, agent_lat, 'b', 'filled');
    hold on;
    scatter(target_lon, target_lat, 'r', 'filled');

% 设置绘图参数
axis([-180 180 -90 90]);
xlabel('经度');
ylabel('纬度');
title(['时间步：', num2str(t)]);

% 暂停一段时间，以便观察结果
pause(0.01);
end

% 大圆距离的计算函数
function dist = greatCircleDist(p1, p2, r)
lat1 = deg2rad(p1(1));
lon1 = deg2rad(p1(2));
lat2 = deg2rad(p2(1));
lon2 = deg2rad(p2(2));
dlon = lon2 - lon1;
dlat = lat2 - lat1;
a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2;
c = 2 * atan2(sqrt(a), sqrt(1-a));
dist = r * c;
end

% 移动球面上的点的函数
function [new_lat, new_lon] = moveOnSphere(lat, lon, v, r)
% 将速度向量投影到球面切平面上
size(v)

size([cosd(lat) cosd(lon)])
p = v - dot(v, [cosd(lat) cosd(lon)]) .* [cosd(lat) cosd(lon)];

   % 计算球面上点的新位置
new_lat = lat + atand(p(:,2) ./ (r + p(:,1)));
new_lon = lon + atand(p(:,1) ./ (r + p(:,2))) ./ cosd(lat);
end
