% plot_logs.m
%
% Created by: Eric A. Autry
% Date: 07/12/2011
%
% This function takes in two vectors and a matrix, and creates a 2D or 3D
% plot and writes it to a .png file.  It also takes in a frame_number to 
% specify the name of the output picture.
%
%%%%%%%%%%
% Inputs:
%
% x_vec: the vector listing all of the x values used.
%
% y_vec: the vector listing all of the y values used.
%
% height_mat: the matrix listing all of the height values.
%
% (So, if we consider x_vec(2) and y_vec(5), these will be the x and y
% coordinates of the cell that has a height value of height_mat(2, 5).)
%
% frame_num: the $$$$ in the original file fort.q$$$$.
%
% xmin: the min x of the run
%
% xmax: the max x of the run
%
% ymin: the min y of the run
%
% ymax: the max y of the run
%
% hmax: the maximum height of the run
%
% time: a number that gives the actual time for this frame
%
% log_plot_option: which type of plot to use - described in set_plotter.m
%
% log_az: the az value to use for the 3D plot
%
% log_el: the el value to use for the 3D plot
%
%%%%%%%%%%
% Outputs:
%
% It will create a .png file named log$$$$.png.
%
% It also outputs name, the name of the created image.

function name = plot_logs(x_vec, y_vec, height_mat, xmin, xmax, ymin, ...
                          ymax, hmax, frame_num, time, log_plot_option, ...
                          log_az, log_el)

% Get parameters from set_plotter.m:
eval('set_plotter');

% Supress the figure:
if (fig_verbosity ~= 1)
    figure('visible', 'off');
end

% Calculate mx and my:
mx = size(x_vec, 1);
my = size(y_vec, 1);

% Find the middle x_row:
if (mod(my, 2) == 0)
    x_row = my / 2.0;
else
    x_row = (my + 1) / 2.0;
end

% Find the middle y_row:
if (mod(mx, 2) == 0)
    y_row = mx / 2.0;
else
    y_row = (mx + 1) / 2.0;
end

% Make the matrix with the log values:
hmat = log10(abs(height_mat - ones(my, mx)));

% Make the plot:
if (log_plot_option == 0)
    az = log_az;
    el = log_el;
    fig = axes();
    surf(x_vec, y_vec, hmat);
    shading interp
    view(az, el);
    axis([xmin xmax ymin ymax -16 log(hmax)]);
    set(fig, 'FontSize', font_size);
    xlabel('x');
    ylabel('y');
    zlabel('Height (log scale)');
elseif (log_plot_option == 1)
    fig = axes();
    plot(x_vec, hmat(x_row, :));
    axis([xmin xmax -16 log(hmax)]);
    set(fig, 'FontSize', font_size);
    xlabel('x');
    ylabel('Height (log scale)');
else
    fig = axes();
    plot(y_vec, hmat(:, y_row));
    axis([ymin ymax -16 log(hmax)]);
    set(fig, 'FontSize', font_size);
    xlabel('y');
    ylabel('Height (log scale)');
end

% Set the title to be the time so that time is displayed:
title(strcat('Time =  ', num2str(time)));

% Output the picture:
for i = 1 : max(size(pic_out_type))
    % Now to create the name of the file:
    f_num = sprintf('%04d.', frame_num);
    name = strcat('log', f_num, char(pic_out_type(i)));
    
    % Now print the figure, surf, to the file:
    type = strcat('-d',  char(pic_out_type(i)));
    print(type, name);
end

if (print_fig == 1)
    saveas(fig, strcat('log', f_num, 'fig'));
end

% Now close the figure:
close
