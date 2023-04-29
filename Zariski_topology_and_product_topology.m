% Code to answer the question on https://math.stackexchange.com/questions/3587032/zariski-topology-and-product-topology
% Define the set V(xy) as the union of the x-axis and y-axis
[x, y] = meshgrid(-2:0.1:2);
V_xy = double((x == 0) | (y == 0));

% Plot V(xy) in the product topology (using meshgrid)
figure;
surf(x, y, V_xy);
xlabel('x');
ylabel('y');
zlabel('V(xy)');
title('V(xy) in the product topology');

% Plot V(xy) in the Zariski topology (using contour)
figure;
contour(x, y, V_xy, [1, 1]);
xlabel('x');
ylabel('y');
title('V(xy) in the Zariski topology');
