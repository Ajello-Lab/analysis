# Analysis
This software package has been put together to reproduce Figures 4, 5, and 7 in Lee et al. (2020): _Laboratory Study of the Cameron Bands, the First Negative Bands, and Fourth Positive Bands in the Middle Ultraviolet 180–280 nm by Electron Impact upon CO._

## Usage
It is recommended users clone this repository and expand their IDL path to include it:

    IDL> !PATH = Expand_Path('+<clone_base>/analysis/') + ':' + !PATH

From there, reproduction of all four figures is as simple as calling

    IDL> reproduce_lee_2020_figures

This will recreate all plots in the 'Plots' directory, as well as print relevant cross sections and populations.

## Requirements
For Figures 4 and 5:
* IDL (tested in 8.5)
* [Coyote Graphics Library](http://www.idlcoyote.com/documents/cg_programs.php)

For reproducing optimization of Figure 7:
* Python 2.7
  * Numpy
  * Matplotlib
  * Scipy.optimize
