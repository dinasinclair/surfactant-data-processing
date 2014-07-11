% plot3d.m
%
% Created by: Eric A. Autry
% Date: 06/14/2011
%
% This function takes in two vectors and a matrix, and creates a 3d plot
% and writes it to a .png file.  It also takes in a frame_number and
% figure_number to specify the name of the output picture.
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
% surf_mat: the matrix listing all of the surfactant values.
%
% (So, if we consider x_vec(2) and y_vec(5), these will be the x and y
% coordinates of the cell that has a height value of height_mat(2, 5).)
%
% frame_num: the $$$$ in the original file fort.q$$$$.
%
% az and el: the numbers to specify the view: view([az, el]).
%
% user_control: a boolean saying whether or not the user is allowed to set
% az and el during the run
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
% smax: the maximum surfactant concentration of the run
%
% time: a string that gives the actual time for this frame
%
%%%%%%%%%%
% Outputs:
%
% It will create a .png file named frame$$$$.png.
%
% It will also output the three values:
%
% az and el: define the view that the user has chosen.  To be used for 
% later pictures.
%
% pic_name: the name of the created image.

function [az, el, pic_name] = plot3d(x_vec, y_vec, height_mat, ...
                                     surf_mat, frame_num, az, el, ...
                                     user_control, xmin, xmax, ymin, ...
                                     ymax, hmax, smax, time)
                       
% Get parameters from set_plotter.m:
eval('set_plotter');

if((user_control ~= 1 || frame_num ~= 0) && fig_verbosity ~= 1)
    % Supress the figure:
    figure('visible', 'off');
end

% Set the color map to the defined scale:
cmat = colormap;
L = size(cmat, 1);
blurC = (1 - blur_power) * lowC + blur_power * highC;
for index = 2 : L
    cmat(index, 1) = ((highC(1) - blurC(1)) / (L-1))*(index-1) + blurC(1);
    cmat(index, 2) = ((highC(2) - blurC(2)) / (L-1))*(index-1) + blurC(2);
    cmat(index, 3) = ((highC(3) - blurC(3)) / (L-1))*(index-1) + blurC(3);
end
cmat(1, :) = lowC;
colormap(cmat);

% Make the plot.
if (make_sub)
    fig = axes('Position',[(sub_size*pad) (sub_size*pad) ...
                           (2-(sub_size*pad)-pad) (2-(sub_size*pad)-pad)]);
else
    fig = axes();
end
surf(x_vec, y_vec, height_mat, surf_mat);
axis([xmin xmax ymin ymax 0 hmax]);
set(fig, 'FontSize', font_size);
xlabel('x');
ylabel('y');
zlabel('Height');
shading interp
t = colorbar('peer', gca);
set(t, 'FontSize', font_size);
set(get(t, 'ylabel'), 'FontSize', font_size);
set(get(t, 'ylabel'), 'String', 'Surfactant Concentration');
caxis([0 smax]);
view([az, el]);

if (make_mesh)
    % Make the coarse mesh and plot it over the surface:
    hold on
    h(:, :) = height_mat(1: coarseness :size(x_vec), ...
                         1: coarseness :size(y_vec));
    x = x_vec(1 : coarseness : size(x_vec));
    y = y_vec(1 : coarseness : size(y_vec));
    mesh(fig, x, y, h, 'EdgeColor', mesh_color, 'FaceAlpha', 0);
    hold off
end

% Allow the user to rotate it if it is the first and user control is on:
if(frame_num == 0 && user_control)
    % Allow the user to rotate the figure:
    rotate3d('on')
    
    % Create a text block to explain rotating:
    uicontrol('Style','text',...
              'Position',[180 400 200 15],...
              'String','Click and Rotate');

    % Create a text block to explain the pausing:
    uicontrol('Style','text',...
              'Position',[180 385 200 15],...
              'String','Press any key to continue');
    
    % Now pause until the use presses a key to indicate that they are done:
    pause

    % Now get the az and the el from the plot:
    [az, el] = view;
    
    % Remake the plot without the buttons using the new az and el:
    close
    fig = axes('Position', [(sub_size*pad) (sub_size*pad) ...
                           (2-(sub_size*pad)-pad) (2-(sub_size*pad)-pad)]);
    surf(fig, x_vec, y_vec, height_mat, surf_mat);
    axis([xmin xmax ymin ymax 0 hmax]);
    set(fig, 'FontSize', font_size);
    xlabel('x');
    ylabel('y');
    zlabel('Height');
    shading interp
    t = colorbar('peer',gca);
    set(get(t, 'ylabel'), 'String', 'Surfactant Concentration');
    set(get(t, 'ylabel'), 'FontSize', font_size);
    colormap(cmat);
    caxis([0 smax]);
    view([az, el]);
    
    if (make_mesh)
        % Make the coarse mesh and plot it over the surface:
        hold on
        h(:, :) = height_mat(1: coarseness :size(x_vec), ...
                             1: coarseness :size(y_vec));
        x = x_vec(1 : coarseness : size(x_vec));
        y = y_vec(1 : coarseness : size(y_vec));
        mesh(fig, x, y, h, 'EdgeColor', mesh_color, 'FaceAlpha', 0);
        hold off
    end
end

% Now get the final values of az and el:
[az, el] = view;

% Set the title to be the time so that time is displayed:
title(strcat('Time =  ', num2str(time)));

if (make_sub)
    % Now make the top view subplot:
    sub_axes = axes('Position', [0 0 sub_size sub_size]);
    surf(sub_axes, x_vec, y_vec, height_mat, surf_mat);
    axis equal;
    shading interp
    set(sub_axes, 'FontSize', font_size);
    view(sub_axes, az, 90);
    colormap(cmat);
    caxis([0 smax]);
end

% Output the picture:
for i = 1 : max(size(pic_out_type))
    % Now to create the name of the file:
    f_num = sprintf('%04d.', frame_num);
    pic_name = strcat('frame', f_num, char(pic_out_type(i)));
    
    % Now print the figure, surf, to the file:
    type = strcat('-d',  char(pic_out_type(i)));
    print(type, pic_name);
end

if (print_fig == 1)
    saveas(gcf, strcat('frame', f_num, 'fig'));
end

% Now close the figure:
close
close
end
