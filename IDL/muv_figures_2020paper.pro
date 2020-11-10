PRO muv_figures_2020paper, source=source, mask_in=mask_in
;+
;  Routine for reproducing Figures 4 and 5 in Lee et al. (2020)
; 
; :Params:
;   source: in, optional, type=int, default=0
;     Selecting the data source. 0 = 100eV, 1 = 30eV, 2 = 15eV
;   mask_in: in, optional, type=array, default=[1750, 2700]
;
; :Examples:
;   muv_figures_2020paper, source=0, mask_in=[1750, 2700]
;
; :Author:
;   Victoir Veibell, CPI
;
; :History:
;   8 Nov, 2020: Adapted for public release
;-

  if ~isa(source) then source = 0
  if ~isa(mask_in) then mask_in=[1750,2700]

  case source of    
    0: begin
      restore,'../Sav/co_100eV_round6_MUV_test1_2_3_low_press_1000pixels_16june2019.idl'
      data_wave = wavecal_co_100ev
      data_int = cal_total_co_100ev
      data_title = 'CO 100eV Total'
    end
    1: begin
      restore,'../Sav/co_30eV_round7_MUV_test4_5_6_hi_press_1000pixels_6aug2019.idl'
      data_wave = wavecal_co_30ev_r7
      data_int = cal_total_co_30ev_r7
      data_title = 'CO 30eV Total'
    end
    2: begin
      restore,'../Sav/co_15eV_round7_MUV_test1_2_3_hi_press_1000pixels_4aug2019.idl'
      data_wave = wavecal_co_15ev_r7
      data_int = cal_total_co_15ev_r7      
      data_title = 'CO 15eV Total'
    end
  endcase

  
  
  restore, '../Sav/MUV_fit_'+strtrim(string(source),2)+'.sav'
  ; Saved contents:
  ; data_wave: wavelength grid of measured data
  ; data_int: Intensity of measured data
  ; fit_coef: fit coefficient per source
  ; X: each template as passed into the fit, convolved with the PSF
  ; name_vector: vector of template labels corresponding to rows in X, elements in fit_coef
  ; psf: Point spread function used for convolution
  ; fit: Final model to measured data


  w = where(data_wave ge mask_in[0] and data_wave le mask_in[1])
  All = total(X[w,*],1,/nan)*fit_coef
  Fourpg = where(name_vector eq 'CO 4PG' or name_vector eq 'CO 4PG Thick')
  Cameron = where(strpos(name_vector, 'Cameron') ne -1)
  NG = where(strpos(name_vector, '1NG') ne -1)
  Cross = total(All[Fourpg])/total(All[Cameron])

  CamPop = fit_coef[Cameron]/total(fit_coef[Cameron])
  NGPop = fit_coef[NG]/total(fit_coef[NG])
  
  print, '------------'
  print, 'Results for data set: ' + data_title
  print, '4PG Cross section: ' + strtrim(string(Cross),2)
  print, 'Cameron populations:'
  print, CamPop, format='(12(F6.3,","))'
  print, '1NG populations:'
  print, NGPop, format='(12(F6.3,","))'
  print, ''


  colorvec=['blue','red','Coral','Cornflower Blue','Dark Salmon','Cyan','Dark Green','Purple','Deep Pink',$
    'Lawn Green','Lavender','Green Yellow','Maroon','Slate Gray','PUR8','Cadet Blue','Bisque','Charcoal',$
    'CG8','Aquamarine','Pink','BLU8','BLU6','CG1','CG2','CG3','CG4','CG5','CG6','CG7','CG8']


  data_wave /= 10. ; Angstrom to nm

  xrange=[170,270]
  w = where(data_wave ge xrange[0] and data_wave le xrange[1])
  yrange=[0,max(data_int[w])*1.2]
  ytitle='Intensity'
  cgps_open,'../Plots/MUV_comp_'+strtrim(string(source),2)+'.ps'
  cgplot, data_wave, data_int, yrange=yrange, xrange=xrange, xtitle='Wavelength (nm)',ytitle=ytitle,title=data_title,POSITION=[0.15, 0.15, 0.95, 0.9]
  cgplot, data_wave, fit, color='red', /overplot
  
  for i=0,n_elements(fit_coef)-1 do begin
    cgplot, data_wave,X[*,i]*fit_coef[i],color=colorvec[i],/overplot
  endfor

  Contrib = total(X,1,/nan)*fit_coef
  MostContrib=(sort(Contrib))[-1:-9:-1]
  MostContrib=MostContrib[where(Contrib[MostContrib] gt 0)]

  cglegend,color=['black',colorvec[MostContrib]],title=['IUVS BB',name_vector[MostContrib]],$
    /box,/data,alignment=1,location=Legend_loc(xrange,yrange,corner=1),vspace=1.4,length=0.02,/center_sym,charsize=1.3,thick=6
  
  cgps_close,/nofix



  xrange=[170,280]
  yrange=[0,max(data_int[w])*1.2]
  cgps_open,'../Plots/MUV_'+strtrim(string(source),2)+'.ps'
  cgplot,data_wave,data_int,yrange=yrange,xrange=xrange,xtitle='Wavelength (nm)',ytitle=ytitle,title=data_title,POSITION=[0.15, 0.15, 0.95, 0.9]
  cgplot, data_wave, fit, color='red', /overplot

  annotate_spectra_brightest,source='4pg',xvals=data_wave,yvals=data_int,yrange=yrange,xrange=xrange,/nm, number=4, width=5, top=0.85, /scale
  annotate_spectra_brightest,source='cameron',xvals=data_wave,yvals=data_int,yrange=yrange,xrange=xrange,/nm, number=6, width=5, top=0.65, /scale
  annotate_spectra_brightest,source='1ng',xvals=data_wave,yvals=data_int,yrange=yrange,xrange=xrange,/nm, number=8, width=3, top=0.45, /scale
  
  cglegend,color=['black','red'],title=['IUVS BB','Fit'],$
    /box,/data,alignment=1,location=Legend_loc(xrange,yrange,corner=1),vspace=1.4,length=0.02,/center_sym,charsize=1.3,thick=6

  cgps_close,/nofix


END