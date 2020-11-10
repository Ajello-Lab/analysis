PRO ANNOTATE_SPECTRA_BRIGHTEST,source=source,xvals=xvals,yvals=yvals,scale=scale,xrange=xrange,yrange=yrange,nm=nm,top=top,width=width,depth=depth,number=number
  ;+
  ; Adds spectra annotations to an existing cgplot for band templates
  ;
  ; :Params:
  ;   source: in, required, type=string
  ;    '1ng', '4pg', or 'cameron'
  ;   xvals: in, semi-optional, type=array
  ;    x values for the plot, typically wavelength, required if using scaling
  ;   yvals: in, semi-optional, type=array
  ;    y values for the plot, typically intensity, required if using scaling
  ;   scale: in, optional, type=bool
  ;    Whether or not to scale FCF order by measured brightness (from yvals) 
  ;   xrange: in, required, type=array
  ;    Used to constrain sources to those that fit within the plot
  ;   yrange: in, required, type=array
  ;    Used to define height of the plot to know where to put annotations
  ;   nm: in, optional, type=bool
  ;    Flag if plotting wavelength in nanometers to scale values from file (which are in Angstroms)
  ;   top: in, optional, type=float
  ;    Set where top of line should be in normalized y coordinates (i.e. [0-1] with 1 at very top of plot)
  ;   width: in, optional, type=int
  ;    How many v' levels to include, if you want to limit that    
  ;   depth: in, optional, type=int
  ;    How many v'' levels to include, if you want to limit that
  ;   number: in, optional, type=int
  ;    How many total sources to include, if you want to limit that  
  ;
  ; :Examples:
  ;   X=[2000:2500]
  ;   Y=sin(X)
  ;   cgplot, X, Y
  ;   annotate_spectra_brightest,source='Cameron', xvals=X, yvals=Y, /scale, xrange=[2000, 2500], yrange=[0, 1], number=5 
  ;
  ; :Uses:
  ;   cgplot
  ;
  ; :Author:
  ;   Victoir Veibell, CPI
  ;
  ; :History:
  ;   1 Nov, 2019: Documented
  ;
  ;-

  if n_elements(number) eq 0 then number=6
  if n_elements(top) eq 0 then top=0.73
  if n_elements(scale) eq 0 then scale = 0
  if n_elements(width) eq 0 then width=10
  if n_elements(depth) eq 0 then depth=10

  csize=0.7
  LineThick = 4

  if strpos(strlowcase(source),'1ng') ge 0 then begin
    name = 'CO+ 1NG'
    savname = '../Sav/1NG.sav'
  endif
  if strpos(strlowcase(source),'4pg') ge 0 then begin
    name = 'CO 4PG'
    savname = '../Sav/4PG.sav'
  endif
 if strpos(strlowcase(source),'cameron') ge 0 then begin
    name = 'Cameron'
    savname = '../Sav/Cameron.sav'
  endif
  
  restore, savname
  
  if isa(nm) && nm then vals=vals/10.
  
  s=size(brights,/dim)
  if s[0] gt width then brights[width:-1,*] = brights[width:-1,*] * 0.
  if s[1] gt depth then brights[*,depth:-1] = brights[*,depth:-1] * 0.
  
  if scale then begin
    scaleval = vals*0.
    s = size(vals, /dim)
    for i = 0, s[0]-1 do begin
      for j = 0, s[1]-1 do begin
        ignore = min(abs(xvals - vals[i,j]), minat)
        scaleval[i,j] = yvals[minat]
      endfor
    endfor
    brights = scaleval * (brights^2)
  endif
  
  brights[where(vals le xrange[0] or vals ge xrange[1])]= 0.

  brightest = (reverse(sort(brights)))[0:number-1]
  brightestat = array_indices(brights,brightest)


  s=size(vals,/dimensions)

  L= top+0.04 ;0.75
  U= top+0.07 ;0.777
  A= top+0.08
  T= top ; 0.73
  step = 0.035
  ypointl=(yrange[1]-yrange[0])*L+yrange[0]
  ypointu=(yrange[1]-yrange[0])*U+yrange[0]
  ypointa=(yrange[1]-yrange[0])*A+yrange[0]
  ypointt=(yrange[1]-yrange[0])*T+yrange[0]
  ybar=[ypointl,ypointu]

  s=size(vals,/dimensions)

  for k=0, number-1 do begin
    i=brightestat[0,k]
    j=brightestat[1,k]
    if vals[i,j] gt xrange[0] and vals[i,j] lt xrange[1] then begin

      cgplot,[vals[i,j],vals[i,j]],ybar,/overplot
      mytext=strtrim(string(fix(i)),2)+','+strtrim(string(fix(j)),2)
      cgtext,vals[i,j],ypointt,mytext,charsize=csize, orientation=90

    endif
  endfor

  highest = max(vals[brightest])
  lowest = min(vals[brightest])

  cgtext,lowest,ypointa,name,charsize=csize

  cgplot,[lowest,highest],[ybar[1],ybar[1]],/overplot


END
