% set_plotter.m
%
% Created by: Eric A. Autry
% Date: 06/14/2011
%
% This file stores the changable values for the plot3d, plot_maker, and the
% plot_surfactant functions.

%%%%% CHANGEABLE PARAMETERS %%%%%
% Set verbosity to 1 to have the program output messages.  Set it to 0 to 
% supress these messages:
verbosity = 1;

% Set the font size in all of the figures (using the standard font sizes):
font_size = 18;

% Set fig_verbosity to 1 to have the program display figures every time it 
% creates an image (note, this means that a new window opens every time a 
% new picture is created, meaning that it may be very difficult to do 
% anything else while plot_maker is running).  Set it to 0 to supress these
% figures:
fig_verbosity = 0;

% Set the picture output types here.  It should be a cell array of strings 
% with the proper abbreviations for the file types you want.  So acceptable
% types to use are png, eps, epsc, bmp, jpeg, pdf, etc.  They must be 
% matlab friendly.  For more on this, see matlab's documentation on 
% printing and the proper formats at:
% http://www.mathworks.com/help/techdoc/ref/print.html
% Note, you don't need the -d flag part added to the fron of it. Also note,
% you can have it output, for example, both eps and pdf by setting this to 
% {'eps' 'pdf'}.  Set it to {} to just output png.  However, it must always
% output a png last, so the line underneath the definition of pic_out_type 
% guarentees that - SO DO NOT CHANGE THAT LINE:
pic_out_type = {'eps'};
%%%%%%%%%%% DO NOT MODIFY! %%%%%%%%%%%
pic_out_type = [pic_out_type {'png'}];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set print_fig to also save each frame's figure as a Matlab .fig file:
print_fig = 1;

% Set make_height_profile to 1 to make the height profile movie:
make_height_profile = 1;

% Set make_surf_profile to 1 to make the surfactant profile movie:
make_surf_profile = 1;

% Set linear_plot to 1 to make the linear plots.  Note that both of the 
% above must also be set to 1 for this to occur:
linear_plot = 1;

% Set make_log_profile to 1 to make the log height profile movie:
make_log_profile = 0;

% Set the form of the log height profile movie:
% 0 means it'll be a 3D plot.
% 1 means it'll be a 2D plot of the middle slice along the y-axis.
% 2 means it'll be a 2D plot of the mi0dle slice along the x-axis.
log_plot_option = 0;

% Set the marker size for the maxima vs time plot (comes with the log 
% video).  The size is points^2.  Recommended value is 4:
marker_size = 4;

% Set the az and el for the height profile movie:
height_az = 0;
height_el = 0;

% Set the az and el for the surfactant profile movie:
surf_az = 0;
surf_el = 0;

% Set the az and el for the log height profile movie:
log_az = 0;
log_el = 0;

% Set user_control to 0 to use the above values of az and el for the height
% profile movie.  Otherwise, you can manually change it during execution of
% plot_maker.
user_control = 0;

% Set the extra height of the axes relative to the max height and max 
% surfactant concentrations for their respective movies:
extra_height = .2;

% Set the frame rate of the movies:
frame_rate = 5;

% Set the amount to rotate az and el at the end of the movies (in degrees):
az_jump = 10;
el_jump = 5;

%%%%%
% The following are for the height profile movie only.
%%%%%

% Set the colors used for the colormap of the Surfactant Concentration:
highC = [0 1 0];
lowC = [0 0 0];

% blur_power: Creates a difference between the color that the colormap has 
% at a concentration of 0, and the color that is actually displayed when 
% the concentration is 0.  The larger this value, the greater the 
% difference.
blur_power = 0.0;

% make_mesh is a boolean that determines whether a coarse mesh is created:
make_mesh = 1;

% Set the coarseness of the mesh plot and the mesh color.  I suggest 6 for 
% a 200x200 grid and 9 for a 400x400 grid:
coarseness = 7;
mesh_color = [.5 .5 .5];

% Set make_sub to 1 to make the subplot and 0 to get rid of the subplot:
make_sub = 1;

% Set the size of the top view subplot.  Value is normalized over (0, 1]:
sub_size = 0.2;

% Set the value used to pad the edges of the plots.  This is normalized 
% over [1, 2].  Suggested value is 1.1:
pad = 1.1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
