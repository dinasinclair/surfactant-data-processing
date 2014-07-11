% plot_maker.m
%
% Created by: Eric A. Autry
% Date: 06/20/2011

% Get parameters from set_plotter.m:
eval('set_plotter');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (verbosity)
    message = 'Loading files.'
end

% Load in the file to get the total number of frames:
eval('tnf');

% Load in the first frame to get important values:
eval('frame0000');
if (verbosity)
    message = sprintf('Finished loading file: frame%04d.', 0)
end

% Now set up the 3-dimensional height and surfactant matricies:
% Currently filled with random data.  Will be overwritten later.
height = rand(size(x_vec, 1), size(y_vec, 1), tot_num_frames);
all_surf = rand(size(x_vec, 1), size(y_vec, 1), tot_num_frames);

% Put first frame's data in:
height(:, :, 1) = eval('height_mat0000')';
all_surf(:, :, 1) = eval('surf_mat0000')';

% Now load in all of the other files:
for index = 1 : tot_num_frames
    file = sprintf('frame%04d', index-1);
    eval(file);
    file = sprintf('t%04d', index-1);
    eval(file);
    hmat = sprintf('height_mat%04d', index-1);
    smat = sprintf('surf_mat%04d', index-1);
    height(:, :, index) = eval(hmat)';
    all_surf(:, :, index) = eval(smat)';
    if (verbosity)
        message = sprintf('Loaded files for frame number: %04d', index-1)
    end
end

% Get the last few important variabes for plot3d:
hmax = max(max(max(height))) + extra_height;
smax = max(max(max(all_surf)));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (make_height_profile)
    
%     if (verbosity)
%         message = 'Creating the height profile movie, plots_movie.avi.'
%     end

    % Make the linear movie if linear_plot is true:
    if (linear_plot)
        % Create the movie object and set its frame rate:
        linear_h = VideoWriter('linear_h.avi');
        linear_h.FrameRate = frame_rate;

        % Use plot_slice and then start making the movie:
        open(linear_h);
        for frame = 1 : tot_num_frames
            time = eval(sprintf('time%04d', frame-1));
            name = plot_slice(x_vec, y_vec, height(:, :, frame), xmin, ...
                              xmax, ymin, ymax, hmax, frame-1, time, ...
                              'height');
            img = imread(name);
            writeVideo(linear_h, img);
            if (verbosity)
                message = strcat('Created image: ', name)
            end
        end

        % Now close the video file:
        close(linear_h);
    end

    % Set az and el:
    az = height_az;
    el = height_el;
    
%     % Create the movie object and set its frame rate:
%     plots_movie = VideoWriter('plots_movie.avi');
%     plots_movie.FrameRate = frame_rate;
% 
%     % Use plot3d and then start making the movie:
%     open(plots_movie);
%     for frame = 1 : tot_num_frames
%         time = eval(sprintf('time%04d', frame-1));
%         [az, el, name] = plot3d(x_vec, y_vec, height(:,:,frame), ...
%                                 all_surf(:,:,frame), frame-1, az, el, ...
%                                 user_control, xmin, xmax, ymin, ymax, ...
%                                 hmax, smax, time);
%         img = imread(name);
%         writeVideo(plots_movie, img);
%         if (verbosity)
%             message = strcat('Created image: ', name)
%         end
%     end
% 
%     % Store old values of az and frame:
%     old_az = az;
%     last_frame = frame;
% 
%     % Now rotate about the z-axis using az_jump:
%     num_az_jumps = int8(360 / az_jump);
%     if (num_az_jumps > (360 / az_jump))
%         num_az_jumps = num_az_jumps - 1;
%     end
%     for az_frame = 1 : num_az_jumps
%         az = az - az_jump;
%         frame = frame + 1;
%         time = eval(sprintf('time%04d', last_frame-1));
%         [az, el, name] = plot3d(x_vec, y_vec, height(:,:,last_frame), ...
%                                 all_surf(:,:,last_frame), frame-1, az, ...
%                                 el, user_control, xmin, xmax, ymin, ...
%                                 ymax, hmax, smax, time);
%         img = imread(name);
%         writeVideo(plots_movie, img);
%         if (verbosity)
%             message = strcat('Created image: ', name)
%         end
%     end
% 
%     % Finish rotating all the way back to where we were before:
%     time = eval(sprintf('time%04d', last_frame-1));
%     [az, el, name] = plot3d(x_vec, y_vec, height(:,:,last_frame), ...
%                             all_surf(:,:,last_frame), frame-1, az, el, ...
%                             user_control, xmin, xmax, ymin, ymax, hmax, ...
%                             smax, time);
%     img = imread(name);
%     writeVideo(plots_movie, img);
%     if (verbosity)
%         message = strcat('Created image: ', name)
%     end
% 
%     % Now rotate about the x-axis using el_jump:
%     num_el_jumps = int8(abs(90 - el) / el_jump);
%     if (num_el_jumps > (abs(90 - el) / el_jump))
%         num_el_jumps = num_el_jumps - 1;
%     end
%     for el_frame = 1 : num_el_jumps
%         el = el + el_jump;
%         frame = frame + 1;
%         time = eval(sprintf('time%04d', last_frame-1));
%         [az, el, name] = plot3d(x_vec, y_vec, height(:,:,last_frame), ...
%                                 all_surf(:,:,last_frame), frame-1, az, ...
%                                 el, user_control, xmin, xmax, ymin, ...
%                                 ymax, hmax, smax, time);
%         img = imread(name);
%         writeVideo(plots_movie, img);
%         if (verbosity)
%             message = strcat('Created image: ', name)
%         end
%     end
% 
%     % Now rotate back:
%     for el_frame = 1 : num_el_jumps
%         el = el - el_jump;
%         frame = frame + 1;
%         time = eval(sprintf('time%04d', last_frame-1));
%         [az, el, name] = plot3d(x_vec, y_vec, height(:,:,last_frame), ...
%                                 all_surf(:,:,last_frame), frame-1, az, ...
%                                 el, user_control, xmin, xmax, ymin, ...
%                                 ymax, hmax, smax, time);
%         img = imread(name);
%         writeVideo(plots_movie, img);
%         if (verbosity)
%             message = strcat('Created image: ', name)
%         end
%     end
% 
%     % Now close the video file:
%     close(plots_movie);
 end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (make_surf_profile)
    
%     if (verbosity)
%         message = 'Creating the surfactant profile movie, surf_movie.avi.'
%     end

    % Make the linear movie if linear_plot is true:
    if (linear_plot)
        % Create the movie object and set its frame rate:
        linear_s = VideoWriter('linear_s.avi');
        linear_s.FrameRate = frame_rate;

        % Use plot_slice and then start making the movie:
        open(linear_s);
        for frame = 1 : tot_num_frames
            time = eval(sprintf('time%04d', frame-1));
            name = plot_slice(x_vec, y_vec, all_surf(:, :, frame), ...
                              xmin, xmax, ymin, ymax, smax, frame-1, ...
                              time, 'surfactant');
            img = imread(name);
            writeVideo(linear_s, img);
            if (verbosity)
                message = strcat('Created image: ', name)
            end
        end

        % Now close the video file:
        close(linear_s);
    end

    % Create the movie file and set the frame rate:
%     surf_movie = VideoWriter('surf_movie.avi');
%     surf_movie.FrameRate = frame_rate;
% 
%     az = surf_az;
%     el = surf_el;
% 
%     % Use plot_surfactant and then start making the movie:
%     open(surf_movie);
%     for frame = 1 : tot_num_frames
%         % Find the time:
%         time = eval(sprintf('time%04d', frame-1));
% 
%         % Make the plot:
%         pic_name = plot_surfactant(x_vec, y_vec, all_surf(:,:,frame), ...
%                                    xmin, xmax, ymin, ymax, smax, az, ...
%                                    el, frame-1, extra_height, time);
% 
%         % Add the image to the video:
%         img = imread(pic_name);
%         writeVideo(surf_movie, img);
%         if (verbosity)
%             message = strcat('Created image: ', pic_name)
%         end
%     end
% 
%     % Store old values of az and frame:
%     old_az = az;
%     last_frame = frame;
% 
%     % Now rotate about the z-axis using az_jump:
%     num_az_jumps = int8(360 / az_jump);
%     if (num_az_jumps > (360 / az_jump))
%         num_az_jumps = num_az_jumps - 1;
%     end
%     for az_frame = 1 : num_az_jumps
%         az = az - az_jump;
%         frame = frame + 1;
% 
%         % Find the time:
%         time = eval(sprintf('time%04d', last_frame-1));
% 
%         % Make the plot:
%         pic_name = plot_surfactant(x_vec, y_vec, ...
%                                    all_surf(:,:,last_frame), xmin, ...
%                                    xmax, ymin, ymax, smax, az, el, ...
%                                    frame-1, extra_height, time);
% 
%         % Add the image to the video:
%         img = imread(pic_name);
%         writeVideo(surf_movie, img);
%         if (verbosity)
%             message = strcat('Created image: ', pic_name)
%         end
%     end
% 
%     % Finish rotating all the way back to where we were before:
% 
%     % Find the time:
%     time = eval(sprintf('time%04d', last_frame-1));
% 
%     % Make the plot:
%     pic_name = plot_surfactant(x_vec, y_vec, all_surf(:,:,last_frame), ...
%                                xmin, xmax, ymin, ymax, smax, az, el, ...
%                                frame-1, extra_height, time);
% 
%     % Add the image to the video:
%     img = imread(pic_name);
%     writeVideo(surf_movie, img);
%     if (verbosity)
%         message = strcat('Created image: ', pic_name)
%     end
% 
%     % Now rotate about the x-axis using el_jump:
%     num_el_jumps = int8(abs(90 - el) / el_jump);
%     if (num_el_jumps > (abs(90 - el) / el_jump))
%         num_el_jumps = num_el_jumps - 1;
%     end
%     for el_frame = 1 : num_el_jumps
%         el = el + el_jump;
%         frame = frame + 1;
% 
%         % Find the time:
%         time = eval(sprintf('time%04d', last_frame-1));
% 
%         % Make the plot:
%         pic_name = plot_surfactant(x_vec, y_vec, ...
%                                    all_surf(:,:,last_frame), xmin, ...
%                                    xmax, ymin, ymax, smax, az, el, ...
%                                    frame-1, extra_height, time);
% 
%         % Add the image to the video:
%         img = imread(pic_name);
%         writeVideo(surf_movie, img);
%         if (verbosity)
%             message = strcat('Created image: ', pic_name)
%         end
%     end
% 
%     % Now rotate back:
%     for el_frame = 1 : num_el_jumps
%         el = el - el_jump;
%         frame = frame + 1;
% 
%         % Find the time:
%         time = eval(sprintf('time%04d', last_frame-1));
% 
%         % Make the plot:
%         pic_name = plot_surfactant(x_vec, y_vec, ...
%                                    all_surf(:,:,last_frame), xmin, ...
%                                    xmax, ymin, ymax, smax, az, el, ...
%                                    frame-1, extra_height, time);
% 
%         % Add the image to the video:
%         img = imread(pic_name);
%         writeVideo(surf_movie, img);
%         if (verbosity)
%             message = strcat('Created image: ', pic_name)
%         end
%     end
% 
%     % Now close the video file:
%     close(surf_movie);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (make_log_profile)

    if (verbosity)
        message = 'Creating the log height profile movie, log_movie.avi.'
    end
    
    % Create the movie object and set its frame rate:
    log_movie = VideoWriter('log_movie.avi');
    log_movie.FrameRate = frame_rate;
    
    % Create the vectors maxima and time_vec for the maxima tracking plot:
    time_vec = [];
    maxima = [];

    % Use plot_logs and then start making the movie:
    open(log_movie);
    for frame = 1 : tot_num_frames
        time = eval(sprintf('time%04d', frame-1));
        
        % Add information to the time_vec and maxima vectors:
        [m, t] = track_maxima(x_vec, y_vec, height(:, :, frame), time, ...
                              log_plot_option);
        time_vec = cat(2, time_vec, t);
        maxima = cat(1, maxima, m);
        
        % Make the log plot and add it to the movie:
        pic_name = plot_logs(x_vec, y_vec, height(:, :, frame), xmin, ...
                             xmax, ymin, ymax, hmax, frame-1, time, ...
                             log_plot_option, log_az, log_el);
        img = imread(pic_name);
        writeVideo(log_movie, img);
        if (verbosity)
            message = strcat('Created image: ', pic_name)
        end
    end

    % Now close the video file:
    close(log_movie);
    
    % Supress the next figure:
    if (fig_verbosity ~= 1)
        figure('visible', 'off');
    end

    % Now make the plot to track the maxima over time:
    fig = axes();
    scatter(time_vec, maxima, marker_size);
    set(fig, 'FontSize', font_size);
    xlabel('Time')
    if (log_plot_option == 0 || log_plot_option == 1)
        ylabel('x');
    else
        ylabel('y');
    end

    % Output the picture:
    for i = 1 : max(size(pic_out_type))
        % Now print the figure to the file:
        type = strcat('-d',  char(pic_out_type(i)));
        print(type, 'maxima_vs_time');
    end

    if (print_fig == 1)
        saveas(fig, 'maxima_vs_time.fig');
    end

    if (verbosity)
        message = 'Created image: maxima_vs_time'
    end
    close
end

if (verbosity)
    message = 'Finished execution.'
end
