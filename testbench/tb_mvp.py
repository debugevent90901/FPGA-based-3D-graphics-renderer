# python simulation of mvp transformation

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
    b = 1 / np.tan(eye_fov / 180 * np.pi * 0.5)
    a = b / aspect_ratio
    z_near *= -1
    z_far *= -1
    k = 1 / (z_near-z_far)
    c = (z_near+z_far)*k
    d = 2*z_near*z_far*k
    projection_matrix = np.array([[a, 0, 0, 0], [0, b, 0, 0], [0, 0, c, d], [0, 0, 1, 0]])
    return projection_matrix


if __name__ == "__main__":
    """ x1, y1, z1 = 2.203125, 4.0859375, 3.5859375
    view_matrix = get_view_matrix(x1, y1, z1)
    print("The view matrix is:\n")
    print(view_matrix)
    print("\n\n################\n\n")
 """
    x2, y2, z2 = 2.203125, 4.0859375, 3.5859375
    angle = 0.78539815
    scale = 1.4609375
    model_matrix = get_model_matrix(angle, scale, x2, y2, z2)
    print("The model matrix is:\n")
    print(model_matrix)
    print("\n\n################\n\n")

    """ projection_matrix = get_projection_matrix(90, 1.2, 5, 10)
    print("The projection matrix is:\n")
    print(projection_matrix)
    print("\n\n################\n\n") """
