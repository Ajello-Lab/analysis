PRO PLOT_MUV_POPS
; Figure 7: cross sections
; See python script for optimizing functional parameters

EN = [15, 20, 40, 50, 100]
CO4PG = [5.794, 6.773, 5.773, 5.15, 3.560]
CO1NG = [!Values.F_NAN, 0.173, 5.88, 7.0, 12.63]
CAM = [76.5,15.58,4.77,5.8,7.67]

CamC = [ 4.83497296,  0.23759851, 24.79729277, -5.92992946, 19.21491531,  -3.77626951,  0.99844007, -1.21329713,  5.55959295]
CO1NGC = [ 3.24519415, -0.37309179,  4.81256033, -3.26290876,  3.17299904, 0.69275059,  4.86492068, -3.27571586, 18.38449589]
CO4PGC = [ 2.21315129, -0.55801149,  2.20183792, -3.75983148,  5.72917887,  -0.35737769,  6.99961615, -0.74287281, 12.67047322]

FitX = [15:100:1.]

CO4PGFit = MUV_POP_FUNCTIONAL(CO4PGC, Es=FitX)
CO1NGFit = MUV_POP_FUNCTIONAL(CO1NGC, Es=FitX)
CamFit = MUV_POP_FUNCTIONAL(CamC, Es=FitX)

xrange=[10,110]
yrange=[1e-19,1e-16]

cgps_open,'../Plots/Muv_cross.ps'
cgplot,0,0,/nodata,xrange=xrange,yrange=yrange,ytitle='Cross Section (cm!u2!n)',xtitle='Energy (eV)',/ylog, POSITION=[0.15, 0.2, 0.95, 0.9]
cgplot, EN, CO4PG*1e-18, color='blue',psym=1, symsize=1.6, /overplot
cgplot, EN, CO1NG*1e-18, color='black', psym=2, symsize=1.6, /overplot
cgplot, EN, CAM*1e-18, color='red', psym=4, symsize=1.6, /overplot

cgplot, FitX, CO4PGFit*1e-18, color='blue',psym=-3, symsize=1.6, /overplot
cgplot, FitX, CO1NGFit*1e-18, color='black', psym=-3, symsize=1.6, /overplot
cgplot, FitX, CAMFit*1e-18, color='red', psym=-3, symsize=1.6, /overplot

cglegend,color=['black','red','blue'],title=['CO+ 1NG','CO Cameron','CO 4PG'],psym=[2,4,1],$
  /box,/data,alignment=1,location=Legend_loc(xrange,yrange,corner=1,/ylog),vspace=1.6,length=0.0,/center_sym,charsize=1.5,thick=6
cgps_close,/nofix

END