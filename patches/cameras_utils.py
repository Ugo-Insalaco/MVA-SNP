import numpy as np
import matplotlib.pyplot as plt

def compute_pos_base(extr):
    point = np.zeros(3)
    e = np.eye(3)
    Rc = extr[:3, :3]
    tc = extr[:3, 3]
    posc = np.linalg.solve(Rc, point - tc)
    ep = Rc @ e
    return posc, ep

def plot_cameras(extr, add_center=False, add_median=False):
    pos = []
    eps = []
    if add_center:
        pos.append(np.zeros(3))
        eps.append(np.eye(3))
    for i in range(len(extr)):
        posc, ep = compute_pos_base(extr[i])
        pos.append(posc)
        eps.append(ep)
    pos = np.stack(pos)
    eps = np.stack(eps, axis = 0)
    
    fig = plt.figure()
    ax = fig.add_subplot(projection='3d')
    ax.set_xlim([-6, 6])
    ax.set_ylim([-6, 6])
    ax.set_zlim([-6, 6])
    
    if add_median: 
        barycenter = pos[1:].mean(axis = 0)
        dists=np.linalg.norm(pos[1:] - barycenter, axis = 1)
        med_index = np.argmin(dists)
        median = pos[med_index]
        ax.scatter(median[0], median[1], median[2], color = "yellow")
    if add_center: 
        ax.scatter(pos[0, 0], pos[0, 1], pos[0, 2], color= "red")
        ax.scatter(pos[1:, 0], pos[1:, 1], pos[1:, 2])
    else: 
        if add_median: 
            ax.scatter(pos[np.arange(len(pos))!=med_index, 0], pos[np.arange(len(pos))!=med_index, 1], pos[np.arange(len(pos))!=med_index, 2])
        else:
            ax.scatter(pos[:, 0], pos[:, 1], pos[:, 2])
    ax.quiver(pos[:, 0], pos[:, 1], pos[:, 2], eps[:, 0, 0], eps[:, 0, 1], eps[:,0, 2], color = "red", length=.5, normalize=True)
    ax.quiver(pos[:, 0], pos[:, 1], pos[:, 2], eps[:, 1, 0], eps[:, 1, 1], eps[:,1, 2], color = "green", length=.5, normalize=True)
    ax.quiver(pos[:, 0], pos[:, 1], pos[:, 2], eps[:, 2, 0], eps[:, 2, 1], eps[:,2, 2], color = "blue", length=15, normalize=True)
    return pos, eps

def get_circle_on_plane(N, radius, ref_point, ref_basis):
    theta = np.linspace(0, 2*np.pi, N, endpoint=False)
    circle = radius*np.stack((np.sin(theta), np.cos(theta)), axis=1)
    circle_on_plane = ref_point + circle[:, 0, None]*ref_basis[None, 0]+circle[:, 1, None]*ref_basis[None, 1] # N x 3
    return circle_on_plane

def plot_circle_on_plane(circle_on_plane, ref_point, ref_basis):
    fig = plt.figure()
    ax = fig.add_subplot(projection='3d')
    ax.scatter(circle_on_plane[:, 0], circle_on_plane[:, 1], circle_on_plane[:, 2])
    ax.scatter(ref_point[0], ref_point[1], ref_point[2], color = "red")
    ax.quiver(ref_point[0], ref_point[1], ref_point[2], ref_basis[0, 0], ref_basis[0, 1], ref_basis[0, 2], color = "red", length=.2, normalize=True)
    ax.quiver(ref_point[0], ref_point[1], ref_point[2], ref_basis[1, 0], ref_basis[1, 1], ref_basis[1, 2], color = "green", length=.2, normalize=True)
    ax.quiver(ref_point[0], ref_point[1], ref_point[2], ref_basis[2, 0], ref_basis[2, 1], ref_basis[2, 2], color = "blue", length=.2, normalize=True)

def get_circle_basis(depth, circle_on_plane, ref_point, ref_basis):
    # ref_basis: n_vectors x d
    N = circle_on_plane.shape[0]
    focus = ref_point+depth*ref_basis[2]
    circle_z = focus[None, :] - circle_on_plane
    circle_z = circle_z/np.linalg.norm(circle_z, axis=1)[:, None]
    circle_y = np.repeat(ref_basis[None, 1], N, axis = 0)
    circle_x = np.cross(circle_y, circle_z, axis =1)
    circle_x = circle_x / np.linalg.norm(circle_x, axis=1)[:, None]
    circle_y = np.cross(circle_z, circle_x, axis = 1)
    circle_y = circle_y / np.linalg.norm(circle_y, axis=1)[:, None]
    circle_basis = np.stack((circle_x, circle_y, circle_z), axis = 1)
    return circle_basis

def plot_circle_basis(circle_on_plane, circle_basis, ref_point, ref_basis):
    fig = plt.figure()
    ax = fig.add_subplot(projection='3d')
    ax.scatter(circle_on_plane[:, 0], circle_on_plane[:, 1], circle_on_plane[:, 2])
    ax.scatter(ref_point[0], ref_point[1], ref_point[2], color = "red")
    ax.quiver(ref_point[0], ref_point[1], ref_point[2], ref_basis[0, 0], ref_basis[0, 1], ref_basis[0, 2], color = "red", length=.5, normalize=True)
    ax.quiver(ref_point[0], ref_point[1], ref_point[2], ref_basis[1, 0], ref_basis[1, 1], ref_basis[1, 2], color = "green", length=.5, normalize=True)
    ax.quiver(ref_point[0], ref_point[1], ref_point[2], ref_basis[2, 0], ref_basis[2, 1], ref_basis[2, 2], color = "blue", length=.5, normalize=True)
    ax.quiver(circle_on_plane[:, 0], circle_on_plane[:, 1], circle_on_plane[:, 2], circle_basis[:, 0, 0], circle_basis[:, 0, 1], circle_basis[:,0, 2], color = "red", length=0.2, normalize=True)
    ax.quiver(circle_on_plane[:, 0], circle_on_plane[:, 1], circle_on_plane[:, 2], circle_basis[:, 1, 0], circle_basis[:, 1, 1], circle_basis[:,1, 2], color = "green", length=0.2, normalize=True)
    ax.quiver(circle_on_plane[:, 0], circle_on_plane[:, 1], circle_on_plane[:, 2], circle_basis[:, 2, 0], circle_basis[:, 2, 1], circle_basis[:,2, 2], color = "blue", length=0.2, normalize=True)

def best_rigid_transform(data, ref):
    '''
    Computes the least-squares best-fit transform that maps corresponding points data to ref.
    Inputs :
        data = (d x N) matrix where "N" is the number of points and "d" the dimension
         ref = (d x N) matrix where "N" is the number of points and "d" the dimension
    Returns :
           R = (d x d) rotation matrix
           T = (d x 1) translation vector
           Such that R * data + T is aligned on ref
    '''

    # YOUR CODE
    R = np.eye(data.shape[0]) # d x d
    T = np.zeros((data.shape[0],1)) # d x 1

    pm = ref.mean(axis = 1, keepdims = True) # d x 1
    pmp = data.mean(axis = 1, keepdims = True) # d x 1

    Q = ref - pm # d x n
    Qp = data - pmp # d x n

    H = Qp @ Q.T # (d x n) @ (n x d) = d x d

    U, _, Vh = np.linalg.svd(H) # (d x d), d, (d x d)
    R = Vh.T @ U.T # (d x d)

    if np.linalg.det(R) < 0:
        U[:, -1] = U[:, -1]*(-1)
        R = Vh.T @ U.T

    T = pm - R @ pmp # (d x 1) - (d x d) @ (d x 1) = d x 1


    return R, T

def get_cameras_from_circle(circle_on_plane, circle_basis):
    N = circle_on_plane.shape[0]
    extr = []
    e = np.eye(3)
    for i in range(N):
        ref = circle_on_plane[None, i]+circle_basis[i]
        ref = np.swapaxes(ref, 0, 1)
        data = np.copy(e)
        R, T = best_rigid_transform(ref, data)
        
        v = np.zeros((4, 4))
        v[-1, -1] = 1
        v[:3, :3] = R
        v[:3, 3] = T[:, 0]
        extr.append(v)
    extr = np.stack(extr)
    return extr