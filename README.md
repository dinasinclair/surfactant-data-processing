This is the MATLAB code use to process the data outputed from the clawpack implicit solver 2d Surfactant simulation. Once you've run the desired simulation, you can convert the output files to .m files by running the following in the Surfactant/_plots folder:
  python format_forts.py ../_output/fort.q*
  python format_times.py ../_output/fort.t*
This presumes you have the format_forts.py and format_times.py files in the _plots directory already. If you don't, copy them there.

Next, you can run 
plot_maker.m 
to get movies of both surfactant and height data, as well as a 3d image of the initial conditions. If plot_maker is to fancy, you can change the settings using 
set_plotter.m
or just run
plot_maker_short.m

The rest of the files are needed to run plot_maker. I've once gotten an error because tnf.m (which contains the total number of frames) wasn't updated properly. If for whatever reason, plot_maker is getting stuck after a specific frame, make sure tnf contains the correct number.

important_graphs contains plots of both the multilayer and experimental equation of state, as well as many surfactant and height profiles graphed in matlab using plot_grapher.m. 
