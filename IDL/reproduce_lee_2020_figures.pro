PRO REPRODUCE_LEE_2020_FIGURES

  ; Establish current directory to restore after finished
  cd, current=current_dir
  ; Establish cloned directory so relative paths work
  repo_dir = file_dirname(routine_filepath())
  cd, repo_dir

  for i=0,2 do begin
    muv_figures_2020paper, source=i
  endfor
  
  plot_muv_pops

  ; Restore user's working directory
  cd, current_dir

END