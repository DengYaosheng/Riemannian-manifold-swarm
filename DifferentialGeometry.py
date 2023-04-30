import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D


class DifferentialGeometry:
    def __init__(self, n, coordinate, X, g, connection):
        self.n = n
        self.coordinate = coordinate
        self.X = X
        self.g = g
        self.connection = connection
        self.Riemann_curvature_tensor = None
        self.Riemann_curvature_metric_tensor = None
        self.Ricci_tensor = None
        self.Scalar_curvature = None
        self.Gauss_curvature = None
        self.FaceColor = 'blue'
        self.alpha = 1.0
        self.scale = 1.0

    def geodesic(self, interval, Init, interval_num):
        t = np.linspace(interval[0], interval[1], interval_num)
        X = np.zeros((interval_num, self.n))
        X[0] = Init
        for i in range(interval_num - 1):
            V = np.zeros(self.n)
            for j in range(self.n):
                for k in range(self.n):
                    V[j] += self.connection[k][j][j](X[i]) * self.X[k].diff(self.coordinate[j]).subs(
                        [(self.coordinate[l], X[i][l]) for l in range(self.n)])
                V[j] = V[j].subs([(self.coordinate[l], X[i][l]) for l in range(self.n)])
            X[i + 1] = X[i] + t[1] * V
        fig = plt.figure()
        ax = fig.add_subplot(111, projection='3d')
        ax.plot(X[:, 0], X[:, 1], X[:, 2])
        plt.show()

    def parallel_transport(self, u, interval, Init, interval_num):
        t = np.linspace(interval[0], interval[1], interval_num)
        X = np.zeros((interval_num, self.n))
        X[0] = Init
        V = np.zeros(self.n)
        V[0] = 1.0
        for i in range(interval_num - 1):
            for j in range(self.n):
                for k in range(self.n):
                    V[j] += self.connection[k][j][j](X[i]) * V[k] * t[1]
                V[j] = V[j].subs([(self.coordinate[l], X[i][l]) for l in range(self.n)])
            X[i + 1] = X[i] + t[1] * V
        fig = plt.figure()
        ax = fig.add_subplot(111, projection='3d')
        ax.plot(X[:, 0], X[:, 1], X[:, 2])
        plt.show()

    def drawmesh(self, uinterval, vinterval, draw_curvature, interval_num):
        u = np.linspace(uinterval[0], uinterval[1], interval_num)
        v = np.linspace(vinterval[0], vinterval[1], interval_num)
        U, V = np.meshgrid(u, v)
        X = np.zeros((interval_num, interval_num, self.n))
        for i in range(interval_num):
            for j in range(interval_num):
                X[i][j] = [self.X[k].subs([(self.coordinate[l], [U[i][j], V[i][j]]) for l in range(2)]) for k in
                           range(self.n)]
        fig = plt.figure()
        ax = fig.add_subplot(111, projection='3d')
        if draw_curvature:
            if self.n != 3:
                raise ValueError("Can only draw curvature for 3D surfaces")
            if self.Gauss_curvature is None:
                self.calculate_curvature()
            colors = self.Gauss_curvature.ravel()
            cmap = plt.get_cmap('coolwarm')
            surface = ax.plot_surface(X[:, :, 0], X[:, :, 1], X[:, :, 2], facecolors=cmap(colors), shade=False)
            surface.set_facecolor((0,0,0,0))
            m = cm.ScalarMappable(cmap=cmap)
            m.set_array(colors)
            cbar = plt.colorbar(m)
            cbar.ax.set_ylabel('Gaussian Curvature')
        else:
            facecolor = self.FaceColor
            alpha = self.alpha
            surface = ax.plot_surface(X[:, :, 0], X[:, :, 1], X[:, :, 2], facecolors=facecolor, alpha=alpha)
        ax.set_xlabel(self.coordinate[0])
        ax.set_ylabel(self.coordinate[1])
        ax.set_zlabel(self.coordinate[2])
        ax.set_title('Surface')
        scale = self.scale
        if scale != 1:
            X = np.array(X)
            X[:, :, 2] *= scale
        plt.show()

