#!/usr/bin/python
import matplotlib.pyplot as plt
import numpy as np
from scipy.optimize import least_squares

def fun_final(vp, Es):
    Er = 13.61
    Eth = vp[8]
    sigma = Es * 0.0
    for i in range(len(Es)):
        E=Es[i]
        sigma[i] = vp[0] * ((E - Eth)/Er)**vp[1] / (1.+((E - Eth)/vp[2])**(vp[1]+vp[3])) + vp[4] * ((E - Eth)/Er)**vp[5] / (1.+((E - Eth)/vp[6])**(vp[5]+vp[7]))
 
    return sigma

def fun(vp, Es, cross):
    Er = 13.61
    Eth = vp[8]
    sigma = Es * 0.0
    for i in range(len(Es)):
        E=Es[i]
        sigma[i] = vp[0] * ((E - Eth)/Er)**vp[1] / (1.+((E - Eth)/vp[2])**(vp[1]+vp[3])) + vp[4] * ((E - Eth)/Er)**vp[5] / (1.+((E - Eth)/vp[6])**(vp[5]+vp[7]))
    
    return abs(cross-sigma)

Es=np.array([15.,20.,30.,40.,100.])
cross = [5.794, 6.773, 5.773, 5.15, 3.560] #4PG
cross = [76.5,15.58,4.77,5.8,7.67] #Cameron

#1NG
#Es=np.array([20.,30.,40.,100.])
#cross = [0.173, 5.88, 7.0, 12.63]

x0=[1., 1., 1., 1., 1., 1., 1., 1., 1.]
bounds = [[-np.inf, -np.inf,-np.inf,-np.inf,-np.inf,-np.inf,-np.inf,-np.inf,-np.inf],[np.inf,np.inf,np.inf,np.inf,np.inf,np.inf,np.inf,np.inf,np.inf]]
res = least_squares(fun, x0, bounds=bounds, loss='soft_l1', f_scale=0.1, args=(Es, cross))

resy = fun_final(res.x, Es)
print(res)
print(resy)

Es2 = np.arange(15.,100.,1.)
resfull = fun_final(res.x, Es2)

plt.plot(Es, cross, label='data')
plt.plot(Es, resy, label='fit')
plt.plot(Es2, resfull, label='fitfull')
plt.legend();
plt.show()
