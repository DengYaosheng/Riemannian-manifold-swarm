classdef DifferentialGeometry
    properties
        n           % 坐标系的维度
        coordinate  % 表示坐标系的符号数组
        X           % 定义曲面或流形的坐标函数
        g           % 定义度量张量的符号数组
        connection  % 定义联络的符号数组
        R           % Riemann 曲率张量
        Rm          % 与度量张量相联系的 Riemann 曲率张量
        Ric         % Ricci 张量
        R_scalar    % 标量曲率
        K           % 高斯曲率
        FaceColor   % 绘制曲面时的颜色
        Alpha       % 绘制曲面时的透明度
        scale       % 平行移动向量的比例尺
    end
    
    methods
        function obj = DifferentialGeometry(n, coordinate, X, g, connection)
            % 构造函数
            obj.n = n;
            obj.coordinate = coordinate;
            obj.X = X;
            obj.g = g;
            obj.connection = connection;
            
            % 计算曲率和高斯曲率
            R = sym('R%d%d%d%d', [n n n n]);
            Rm = sym('Rm%d%d%d%d', [n n n n]);
            Ric = sym('Ric%d%d', [n n]);
            R_scalar = sym('R_scalar');
            K = sym('K');
            for i = 1:n
                for j = 1:n
                    for k = 1:n
                        for l = 1:n
                            R(i,j,k,l) = diff(connection(i,j,l), obj.coordinate(k)) - diff(connection(i,j,k), obj.coordinate(l)) ...
                                + connection(i,m,k)*connection(m,j,l) - connection(i,m,l)*connection(m,j,k);
                            Rm(i,j,k,l) = R(i,j,k,l) + g(i,m)*R(m,j,k,l);
                        end
                    end
                end
            end
            for i = 1:n
                for j = 1:n
                    Ric(i,j) = sum(Rm(i,m,j,m), [m 1 n]);
                end
            end
            R_scalar = sum(sum(g.*Ric));
            K = R_scalar / det(g);
            
            obj.R = R;
            obj.Rm = Rm;
            obj.Ric = Ric;
            obj.R_scalar = R_scalar;
            obj.K = K;
            
            % 设置默认绘图参数
            obj.FaceColor = 'red';
            obj.Alpha = 0.5;
            obj.scale = 0.2;
        end
        
        function geodesic(obj, interval, Init, interval_num)
            % 计算并绘制测地线
            syms t real
            eqs = sym('eq%d', [1 obj.n]);
            for i = 1:obj.n
                eqs(i) = diff(obj.X(i), t, 2) + sum(sum(obj.connection(i,j,k)*diff(obj.X(j), t)*diff(obj.X(k), t), [j 1 obj.n]), [k 1 obj.n]);
            end
            [T, Y] = ode45(@(t,y) double(subs(eqs, [sym('t'), obj.coordinate], [t, y])), interval, Init);
    X = zeros(length(T), obj.n);
    for i = 1:obj.n
        X(:,i) = Y(:,i);
    end
    plot3(X(:,1), X(:,2), X(:,3), 'LineWidth', 2);
        end
    end 
end
