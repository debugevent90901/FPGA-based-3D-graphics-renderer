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

x1, y1, z1 = 2.203125, 4.0859375, 3.5859375
view_matrix = get_view_matrix(x1, y1, z1)
# print("The view matrix is:\n")
# print(view_matrix)
# print("\n\n################\n\n")
x2, y2, z2 = 5.0859375, 2.203125, 8.5859375
angle = 0.78539815
scale = 1.4609375
model_matrix = get_model_matrix(angle, scale, x2, y2, z2)
# print("The model matrix is:\n")
# print(model_matrix)
# print("\n\n################\n\n")

projection_matrix = get_projection_matrix(1.04719753, 1.6789, 2.203125, 4.0859375)
# print("The projection matrix is:\n")
# print(projection_matrix)
# print("\n\n################\n\n")

PxV = np.dot(projection_matrix, view_matrix)
mvp = np.dot(PxV, model_matrix)
print("The mvp matrix is:\n")
print(mvp)
print("\n\n################\n\n")

ptA = np.array([3.1, 0, 0, 1])
ptB = np.array([0, 2.9, 0, 1])
ptC = np.array([0, 0, 4.5, 1])

v1 = np.dot(mvp, ptA)
v2 = np.dot(mvp, ptB)
v3 = np.dot(mvp, ptC)

for i in [v1, v2, v3]:
    i[0] /= i[3]
    i[1] /= i[3]
    i[2] /= i[3]
    i[3] = 1

f1 = (50 - 0.1) / 2.0
f2 = (50 + 0.1) / 2.0

width = 30
height = 40
""" 
print(v1)
print(v2)
print(v3) """

for i in [v1, v2, v3]:
    i[0] = 0.5 * width * (i[0]+1)
    i[1] = 0.5 * height * (i[1]+1)
    i[2] = i[2] * f1 + f2


print(v1)
print(v2)
print(v3)
