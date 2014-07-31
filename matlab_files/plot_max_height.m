
function [] = plot_max_height(directory_list,input_title)
% plot_max_height.m
% Plots maximum height over time
%
% Created by: Dina Sinclair (Based on code by Eric A. Autry)
% Date: 07/29/2014

% INPUTS
% directory_list is a list of folders in the _pexplots folder that you want
% to end up on the graph. (NEED TO IMPLEMENT M VS TL DIFFERENCE)

% EXPECTATIONS FROM USER
% you should run this from the matlab_files folder (inside _pexplots).
% all directories should be in folders in the _pexplots folder.

% VARIABLES THAT CAN BE MESSED WITH
verbosity = 1; % Prints steps as running if true
LINEWIDTH = 1.5; % 0.5 is the MATLAB default
TITLE_SIZE = 24; % Fontsize
AXIS_LABEL_SIZE = 17; % Fontize
LEGEND_SIZE = 14; %Fontsize
LEGEND_LOCATION = 'NorthEast'; %Where on the graph the legend goes

% Redimensionalization constants (ex: t * T_DIM = dimensionalized time)
T_DIM = 67.0; % time, in seconds 
R_DIM = 3.0; % radius, in cm
H_DIM = 1.6; % height, in mm
SURF_DIM = 0.2; % surfactant concentration, in micrograms/cm^2

% VARIABLES THAT SHOULD NOT BE MESSED WITH
w = cd; % assigns w to the working directly, now the current directory

% Stop the figure from clearing old plots when it puts up new ones
hold all

% Check if want to redimensionalize (default use seconds)
% if (strcmpi(units,'unitless'))
%     to_seconds = false;
% else
%     to_seconds = true;
% end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Timestep Determination
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if (verbosity)
%     message = 'Finding timestep.'
% end
% 
% % Load in first and second times, get difference to find timestep used in
% % simulation (dt)
% eval('t0000');
% eval('t0001');
% timestep = time0001 - time0000;
% 
% if (verbosity)
%     display(timestep);
% end
for i = 1:length(directory_list)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Loading Files
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % go to the needed directory!
    cd('..');
    cd(directory_list{i});
    
   
    if (exist('height_times.mat','file') == 2 && exist('surfactant_ic.mat','file') == 2)
        if (verbosity)
            message = sprintf(['Found height/surf info for folder ',directory_list{i}])
        end
        load('height_times.mat');
        load('surfactant_ic.mat');
        
    else
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
        % Currently filled with zeros.  Will be overwritten later.
        height = zeros(size(x_vec, 1), size(y_vec, 1), tot_num_frames);
        all_surf = zeros(size(x_vec, 1), size(y_vec, 1), tot_num_frames);

        % Now load in all of the other files:
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

            % Load dimensionalized or nondimensionalized versions as appropriate
        %     if(to_seconds)
        %         height(:, :, index) = eval(hmat)' * H_DIM;
        %         all_surf(:, :, index) = eval(smat)' * SURF_DIM;
        %     else
        %         height(:, :, index) = eval(hmat)';
        %         all_surf(:, :, index) = eval(smat)';
        %     end
        %     
        %     if (verbosity)
        %         message = sprintf('Loaded files for frame number: %04d', index-1)
        %     end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % General Graph Prep
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % An array that stores pairs of (time,max_height)
        height_times = zeros(tot_num_frames,2);

        % Find Surfactant Concentration Setup
        % Calculate the number of x values in frame (length of x_vec)
                mx = size(x_vec, 1);
                % Find the middle x_row:
                if (mod(mx, 2) == 0)
                    x_row = mx / 2.0;
                else
                    x_row = (mx + 1) / 2.0;
                end
         % Calculate the number of y values in frame (length of y_vec)
                my = size(y_vec, 1);
                % Find the middle x_row:
                if (mod(my, 2) == 0)
                    y_row = my / 2.0;
                else
                    y_row = (my + 1) / 2.0;
                end
        % Presumes surfactant conc is constant inside and outside of ring. Samples 
        % one point on edge for outside conc, one point in center for inside conc.
        % Gives array [inside, outside]
        surfactant_ic = [all_surf(x_row,y_row,1),all_surf(1,1,1)];
        
        % Save surfactant ic as a variable so you don't have to load the
        % files again.
        save('surfactant_ic.mat','surfactant_ic');

        % % If dimensionalizing, change radius vector
        %         if(to_seconds)
        %             x_vec = x_vec * R_DIM;
        %         end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Make Max Height Array
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        % See if height vs time file already exists!
        % the exist function returns 2 if the file is present. weird.

        % Go through each frame and record its max height in height_times
        for index = 1 : tot_num_frames
            max_height = max(max(height(:,:,index)));
            time = eval(sprintf('time%04d', index-1));
            height_times(index,:) = [time,max_height];
             if (verbosity)
                message = sprintf('Found max for frame number: %04d', index-1)
            end
        end

        % Save time vs max height as a variable so you don't have to load the
        % files again.
        save('height_times.mat','height_times');
    end
    
    legend_titles{i} = [num2str(surfactant_ic(1)),'in,',...
            num2str(surfactant_ic(2)),'out'];
    plot(height_times(:,1), height_times(:,2),...
        'LineWidth',LINEWIDTH);
end

% Set up axes lables and legend
title(input_title,...
    'FontSize',TITLE_SIZE);
h = legend(legend_titles, 'Location', LEGEND_LOCATION); 
set(h,'FontSize',LEGEND_SIZE);
axis tight;


xlabel('Time (unitless)',...
    'FontSize',AXIS_LABEL_SIZE);
ylabel('Maximum Height (unitless)',...
    'FontSize',AXIS_LABEL_SIZE);

% go back to original directory
cd('../matlab_files');

if (verbosity)
            message = sprintf('Process completed.')
end

end

