FUNCTION LEGEND_LOC,xrange,yrange,corner=corner,pad=pad,xlog=xlog,ylog=ylog,nobox=nobox,outside=outside
;+
; For nicely placing the legend box in a plot
; 
; :Params:
;   xrange: in, required, type=double
;     The range of x-values in the form [xmin, xmax]
;   yrange: in, required, type=double
;     The range of y-values in the form [ymin, ymax]
;   
; :Keywords:
;   corner: in, default=1, type=int
;     The corner to orient the legend to. Corresponds with the alignment keyword, [0:3] = [Top Left, Top Right, Bottom Right, Bottom Left]
;   pad: in, default=0.03, type=double
;     How much to pad from the corner as a percent.
;   xlog: in, default=0, type=bool
;     Indicate that the x-axis is of logarithmic type (i.e. /xlog used)
;   ylog: in, default=0, type=bool
;     Indicate that the y-axis is of logarithmic type (i.e. /ylog used)
;   nobox: in, default=0, type=bool
;     If not using a box around the legend, adjust padding
;   outside: in, default=0, type=bool
;     If the legend is outside of the data box
;     
; :Examples:
;   Legend_Loc,[0,10],[1e6,1e9],corner=1,pad=0.05,/ylog
;   
; :Author:
;   Victoir Veibell, CPI
;   
; :History:
;   10 May, 2017: Documented. Written at some point in the previous week
;   
;-

if n_elements(corner) eq 0 then corner=1
if n_elements(pad) eq 0 then pad=[0.03, 0.03]
if n_elements(pad) eq 1 then pad=[pad, pad]
if n_elements(xlog) eq 0 then xlog=0
if n_elements(ylog) eq 0 then ylog=0
if n_elements(nobox) eq 0 then nobox=0
if n_elements(outside) eq 0 then outside=0

if nobox then pad = pad + [0.01, 0.03]

B=1.0-pad[1]
S=0.0+pad[0]

if ylog then YB = 10^((alog10(yrange[1])-alog10(yrange[0]))*B+alog10(yrange[0])) else YB = (yrange[1]-yrange[0])*B+yrange[0]
if ylog then YS = 10^((alog10(yrange[1])-alog10(yrange[0]))*S+alog10(yrange[0])) else YS = (yrange[1]-yrange[0])*S+yrange[0]

if outside then B=1.0+pad[1]
if xlog then XB = 10^((alog10(xrange[1])-alog10(xrange[0]))*B+alog10(xrange[0])) else XB = (xrange[1]-xrange[0])*B+xrange[0]
if xlog then XS = 10^((alog10(xrange[1])-alog10(xrange[0]))*S+alog10(xrange[0])) else XS = (xrange[1]-xrange[0])*S+xrange[0]

  
  case corner of
    0: LegendLoc=[XS, YB] 
    1: LegendLoc=[XB, YB]
    2: LegendLoc=[XB, YS]
    3: LegendLoc=[XS, YS]
    ELSE: LegendLoc=[XB, YB]
  endcase

  return,LegendLoc
  
  END
