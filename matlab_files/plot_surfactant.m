% plot_surfactant.m
%
% Created by: Eric A. Autry
% Date: 07/11/2011
%
% This function takes in two vectors and a matrix, and creates a 3d plot
% and writes it to a .png file.  It also takes in a frame_number to specify
% the name of the output picture.
%
%%%%%%%%%%
% Inputs:
%
% x_vec: the vector listing all of the x values used.
%
% y_vec: the vector listing all of the y values used.
%
% surf_mat: the matrix listing all of the surfactant values.
%
% (So, if we consider x_vec(2) and y_vec(5), these will be the x and y
% coordinates of the cell that has a surfactant value of surf_mat(2, 5).)
%
% frame_num: the $$$$ in the original file fort.q$$$$.
%
% az and el: the numbers to specify the view: view([az, el]).
%
% xmin: the min x of the run
%
% xmax: the max x of the run
%
% ymin: the min y of the run
%
% ymax: the max y of the run
%
% smax: the maximum surfactant concentration of the run
%
% extra_height: the extra height to add to the axes
%
% time: a number that gives the actual time for this frame
%
%%%%%%%%%%
% Outputs:
%
% It will create a .png file named surfactant$$$$.png.
%
% It also outputs name, the name of the create image.

function name = plot_surfactant(x_vec, y_vec, surf_mat, xmin, xmax, ...
                                ymin, ymax, smax, az, el, frame_num, ...
                                extra_height, time)

% Get parameters from set_plotter.m:
eval('set_plotter');

% Supress the figure:
if (fig_verbosity ~= 1)
    figure('visible', 'off');
end

% Make the plot:
fig = axes();
surf(x_vec, y_vec, surf_mat);
axis([xmin xmax ymin ymax 0 (smax + extra_height)]);
shading interp
view(az, el)
set(fig, 'FontSize', font_size);
xlabel('x');
ylabel('y');
zlabel('Surfactant Concentration');

% Set the title to be the time so that time is displayed:
title(strcat('Time =  ', num2str(time)));

% Output the picture:
for i = 1 : max(size(pic_out_type))
    % Now to create the name of the file:
    f_num = sprintf('%04d.', frame_num);
    name = strcat('surfactant', f_num, char(pic_out_type(i)));
    
    % Now print the figure, surf, to the file:
    type = strcat('-d',  char(pic_out_type(i)));
    print(type, name);
end

if (print_fig == 1)
    saveas(fig, strcat('surfactant', f_num, 'fig'));
end

% Now close the figure:
close
