# python simulation of draw.sv

import numpy as np

def get_model_matrix(angle, scale, x, y, z):
    R = np.array([[np.cos(angle), 0, np.sin(angle), 0], [0, 1, 0, 0], [-1*np.sin(angle), 0, np.cos(angle), 0], [0, 0, 0, 1]])
    S = np.array([[scale, 0, 0, 0], [0, scale, 0, 0], [0, 0, scale, 0], [0, 0, 0, 1]])
    T = np.array([[1, 0, 0, x], [0, 1, 0, y], [0, 0, 1, z], [0, 0, 0, 1]])
    TxR = np.dot(T, R)
    TxRxS = np.dot(TxR, S)
    return TxRxS


def get_view_matrix(x, y, z):
    view_matrix = np.array([[1, 0, 0, -1*x], [0, 1, 0, -1*y], [0, 0, 1, -1*z], [0, 0, 0, 1]])
    return view_matrix


def get_projection_matrix(eye_fov, aspect_ratio, z_near, z_far):
    b = 1 / np.tan(eye_fov / 2)
    a = b / aspect_ratio
    z_near = -1 * z_near
    z_far = -1 * z_far
    k = 1 / (z_near-z_far)
    c = (z_near+z_far)*k
    d = 2*z_near*z_far*k
    projection_matrix = np.array([[a, 0, 0, 0], [0, b, 0, 0], [0, 0, c, d], [0, 0, 1, 0]])
    return projection_matrix


pt0 = np.array([0, 0, 0, 1])
pt1 = np.array([0, 0, 1, 1])
pt2 = np.array([0, 1, 0, 1])
pt3 = np.array([0, 1, 1, 1])
pt4 = np.array([1, 0, 0, 1])
pt5 = np.array([1, 0, 1, 1])
pt6 = np.array([1, 1, 0, 1])
pt7 = np.array([1, 1, 1, 1])

angle = 140 * np.pi / 180
eye_fov = 45 * np.pi / 180

model_matrix = get_model_matrix(angle, 2.5, 0, 0, 0)
view_matrix = get_view_matrix(0, 0, 10)
projection_matrix = get_projection_matrix(eye_fov, 1, 0.1, 50)

PxV = np.dot(projection_matrix, view_matrix)
mvp = np.dot(PxV, model_matrix)


v0 = np.dot(mvp, pt0)
v1 = np.dot(mvp, pt1)
v2 = np.dot(mvp, pt2)
v3 = np.dot(mvp, pt3)
v4 = np.dot(mvp, pt4)
v5 = np.dot(mvp, pt5)
v6 = np.dot(mvp, pt6)
v7 = np.dot(mvp, pt7)

for i in [v0, v1, v2, v3, v4, v5, v6, v7]:
    i[0] /= i[3]
    i[1] /= i[3]
    i[2] /= i[3]
    i[3] = 1

f1 = (50 - 0.1) / 2.0
f2 = (50 + 0.1) / 2.0

width = 640
height = 480

for i in[v0, v1, v2, v3, v4, v5, v6, v7]:
    i[0] = 0.5 * width * (i[0]+1)
    i[1] = 0.5 * height * (i[1]+1)
    i[2] = i[2] * f1 + f2

print(v0)
print("\n")
print(v1)
print("\n")
print(v2)
print("\n")
print(v3)
print("\n")
print(v4)
print("\n")
print(v5)
print("\n")
print(v6)
print("\n")
print(v7)


