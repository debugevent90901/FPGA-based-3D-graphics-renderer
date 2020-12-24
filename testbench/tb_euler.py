import numpy as np 

def get_euler(alpha, beta, gamma):
    index0 = np.cos(alpha)*np.cos(gamma) - np.cos(beta)*np.sin(alpha)*np.sin(gamma)
    # print(np.cos(alpha)*np.cos(gamma))
    # print(np.cos(beta)*np.sin(alpha)*np.sin(gamma))
    # print(index0)
    index1 = np.sin(alpha)*np.cos(gamma) + np.cos(beta)*np.cos(alpha)*np.sin(gamma)
    index2 = np.sin(beta)*np.sin(gamma)

    index4 = -1*np.cos(alpha)*np.sin(gamma) - np.cos(beta)*np.sin(alpha)*np.cos(gamma)
    index5 = -1*np.sin(alpha)*np.sin(gamma) + np.cos(beta)*np.cos(alpha)*np.cos(gamma)
    index6 = np.sin(beta)*np.cos(gamma)

    index8 = np.sin(beta)*np.sin(alpha)
    index9 = -1*np.sin(beta)*np.cos(alpha)
    index10 = np.cos(beta)

    return np.array([[index0, index1, index2, 0], [index4, index5, index6, 0], [index8, index9, index10, 0], [0, 0, 0, 1]])

    # alpha = 12'h181;
    # beta = 12'h286;
    # gamma = 12'h345;

if __name__ == "__main__":
    alpha = 1.50390625
    beta = 2.5234375
    gamma = 3.26953125

    R = get_euler(alpha, beta, gamma)
    S = np.array([[1.4609375, 0, 0, 0], [0, 1.4609375, 0, 0], [0, 0, 1.4609375, 0], [0, 0, 0, 1]])
    T = np.array([[1, 0, 0, 2.203125], [0, 1, 0, 4.0859375], [0, 0, 1, 3.5859375], [0, 0, 0, 1]])

    TxR = np.dot(T, R)
    TxRxS = np.dot(TxR, S)
    # print("T is: ")
    # print(T)
    # print("\nS is: ")
    # print(S)
    # print(TxR)
    print(TxRxS)