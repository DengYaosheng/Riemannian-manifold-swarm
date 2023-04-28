


% 定义Clifford扭结流形的参数
a = 0.5;
b = 0.3;
manifold = struct();  % 创建空结构体



% 创建流形结构体
manifold.Dimension = 3;  % 流形维度
manifold.Name = 'Clifford Torus';  % 流形名称

% 定义流形上的指数映射
manifold.exp = @(x, v) [
    (a + b*cos(v(1)))*cos(x(3) + v(2)); 
    (a + b*cos(v(1)))*sin(x(3) + v(2));
    b*sin(v(1))
];

% 定义流形上的对数映射
manifold.log = @(x, y) [
    acos((x(1)*y(1) + x(2)*y(2))/(sqrt(x(1)^2 + x(2)^2)*sqrt(y(1)^2 + y(2)^2))); 
    acos((a*cos(x(3))*y(1) + a*sin(x(3))*y(2) + b*y(3))/(sqrt((a*cos(x(3)))^2 + (a*sin(x(3)))^2 + b^2)*sqrt(y(1)^2 + y(2)^2 + y(3)^2))); 
    atan2(y(2), y(1)) - x(3)
];

% 定义流形上的Riemannian度量
% 定义流形上的Riemannian度量
manifold.metric = @(x, y) metricTensor(x, y);
manifold.inner = @(x, y) manifold.metric(x, y);
manifold.norm = @(x) sqrt(manifold.inner(x, x));
manifold.dist = @(x, y) manifold.norm(manifold.log(x, y));

% 定义切空间上的投影映射和并联传输
manifold.proj = @(x, v) v - x * (x.' * v);
manifold.parallel_transport = @(x1, x2, v) parallelTransport(x1, x2, v);

% 定义Exponential Map和Logarithmic Map
manifold.exp = @(x, v) exponentialMap(x, v);
manifold.log = @(x, y) logarithmicMap(x, y);

% % 生成Cl(3,0) Clifford代数流形
% manifold = clifford_create();

% 采样流形上的点
num_points = 1000;
points = zeros(num_points, 3);
for i = 1:num_points
    points(i,:) = randPoint(manifold).x;
end

% 画出流形上的点
figure;
scatter3(points(:,1), points(:,2), points(:,3), 5, 'filled');
axis equal;
xlabel('x');
ylabel('y');
zlabel('z');


%% Helper functions
function point = randPoint(manifold)
% 在克里福德扩张上生成随机点
  x = randn(3,1);
  x = x / norm(x);
  point = struct();
  point.x = x;
  point.u = randn(3,1);
  point.v = randn(3,1);
end

% function manifold = clifford_create()
%     manifold = struct();  % 创建空结构体
%     manifold.Dimension = 3;  % 流形维度
%     % 添加其他属性赋值
% end



function metric = metricTensor(x, y)
% 计算流形上的Riemannian度量张量
metric = eye(size(x, 1));
end

function v_tan = velocity2Tangent(manifold, pose, v)
% 将速度向量投影到切空间上的切向量
v_tan = manifold.proj(pose, v);
end

function pose_new = moveOnManifold(manifold, pose_old, v, dt)
% 根据速度向量在流形上更新位姿
v_tan = velocity2Tangent(manifold, pose_old, v);
pose_new = manifold.exp(pose_old, v_tan*dt);
end

function gamma = parallelTransport(x1, x2, v)
% 将从x1点切空间中的向量沿着曲线平移到x2点切空间中的向量
u = x2 - x1;
u_norm = norm(u);
if u_norm < 1e-6
    gamma = v;
else
    gamma = v - ((v.' * u) / u_norm^2) * u;
end
end

function v = exponentialMap(x, v_tan)
% Exponential Map
norm_v = norm(v_tan);
if norm_v < 1e-6
    v = x;
else
    v = x * cos(norm_v) + v_tan / norm_v * sin(norm_v);
end
end

function v_tan = logarithmicMap(x, y)
% Logarithmic Map
d = acos(dot(x, y)/norm(x)/norm(y));
if abs(d) < 1e-6
    v_tan = zeros(size(x));
else
    v_tan = (y - x*cos(d)) / sin(d) * d;
end
end
