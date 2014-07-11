% plot_slice.m
%
% Created by: Eric A. Autry
% Date: 07/20/2011
%
% This function takes in two vectors and a matrix, and creates a 2D plot 
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
% mat: the matrix listing all of the height or surfactant values.
%
% (So, if we consider x_vec(2) and y_vec(5), these will be the x and y
% coordinates of the cell that has a value of mat(2, 5).)
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
% max_val: the maximum height or surfactant concentration of the run
%
% time: a number that gives the actual time for this frame
%
% type: a string that tells whether this is for height or surfactant
%
%%%%%%%%%%
% Outputs:
%
% It will create a .png file named (type)_linear$$$$.png.
%
% It also outputs name, the name of the created image.

function name = plot_slice(x_vec, y_vec, mat, xmin, xmax, ymin, ymax, ...
                          max_val, frame_num, time, type)

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

% Make the plot:
fig = axes();
plot(x_vec, mat(x_row, :));
axis([xmin xmax 0 max_val]);
set(fig, 'FontSize', font_size);
xlabel('x');
ylabel(type);

% Set the title to be the time so that time is displayed:
title(strcat('Time =  ', num2str(time)));

% Output the picture:
for i = 1 : max(size(pic_out_type))
    % Now to create the name of the file:
    f_num = sprintf('%04d.', frame_num);
    name = strcat(type, '_linear', f_num, char(pic_out_type(i)));
    
    % Now print the figure, surf, to the file:
    file_type = strcat('-d',  char(pic_out_type(i)));
    print(file_type, name);
end

if (print_fig == 1)
    saveas(fig, strcat(type, '_linear', f_num, 'fig'));
end

% Now close the figure:
close
