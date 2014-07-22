
function [] = plot_grapher( graph_times, graph_type, units, input_title )
% plot_grapher.m
% Plots simulation for inputted times, all on same graph
%
% Created by: Dina Sinclair (Based on code by Eric A. Autry)
% Date: 07/20/2014

% INPUTS
% graph_times: an array of all the times (nondimensionalized) to be
% graphed.
% graph_type: 'height' if want height profile. 'surf' if want surf profile.
% units: 'sec' if want in seconds. 'unitless' if wand to keep
% nondimensionalized.
% input_title: what you want the title of the graph to be.


% EXPECTATIONS FROM USER
% Should be run in the directory that contains the results from the desired
% simulation. Specifically, the folder needs to contain the t0000 and t0001
% frames, as well as all the frames you ask for in graph_times.

% VARIABLES THAT CAN BE MESSED WITH
verbosity = false; % Prints steps as running if true
LINEWIDTH = 1.5; % 0.5 is the MATLAB default
TITLE_SIZE = 24; % Fontsize
AXIS_LABEL_SIZE = 17; % Fontize
LEGEND_SIZE = 14; %Fontsize
LEGEND_LOCATION = 'SouthEast'; %Where on the graph the legend goes
% Redimensionalization constants (ex: t * T_DIM = dimensionalized time)
T_DIM = 67.0; % time, in seconds 
R_DIM = 3.0; % radius, in cm
H_DIM = 1.6; % height, in mm
SURF_DIM = 0.2; % surfactant concentration, in micrograms/cm^2

% VARIABLES THAT SHOULD NOT BE MESSED WITH
num_times = length(graph_times);

% Check if want a surfactant profile (default) or height profile
if (strcmpi(graph_type,'height'))
    make_height_profile = true;
    make_surf_profile = false;
else
    make_height_profile = false;
    make_surf_profile = true;
end

% Check if want to redimensionalize (default use seconds)
if (strcmpi(units,'unitless'))
    to_seconds = false;
else
    to_seconds = true;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Timestep Determination
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (verbosity)
    message = 'Finding timestep.'
end

% Load in first and second times, get difference to find timestep used in
% simulation (dt)
eval('t0000');
eval('t0001');
timestep = time0001 - time0000;

if (verbosity)
    message = ['Timestep found to be: ',timestep]
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loading Files
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
height = zeros(size(x_vec, 1), size(y_vec, 1), tot_num_frames);
all_surf = zeros(size(x_vec, 1), size(y_vec, 1), tot_num_frames);

% Now load in all of the other files:
for i = 1 : num_times
    index = int8(graph_times(i) * (1/timestep) + 1);
    file = sprintf('frame%04d', index-1);
    eval(file);
    file = sprintf('t%04d', index-1);
    eval(file);
    hmat = sprintf('height_mat%04d', index-1);
    smat = sprintf('surf_mat%04d', index-1);
    
    % Load dimensionalized or nondimensionalized versions as appropriate
    if(to_seconds)
        height(:, :, index) = eval(hmat)' * H_DIM;
        all_surf(:, :, index) = eval(smat)' * SURF_DIM;
    else
        height(:, :, index) = eval(hmat)';
        all_surf(:, :, index) = eval(smat)';
    end
    
    if (verbosity)
        message = sprintf('Loaded files for frame number: %04d', index-1)
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% General Graph Prep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% An array that stores all of the plots to be created
plots = zeros(num_times);
% Stop the figure from clearing old plots when it puts up new ones
hold on

% If dimensionalizing, change radius vector
        if(to_seconds)
            x_vec = x_vec * R_DIM;
        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make Height Graph
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (make_height_profile)
    % Plot each individual line
    for i = 1 : num_times
        
        % Determine frame number height data for given time 
        time = graph_times(i);
        frame = int8(time * (1/timestep) + 1);
        % Calculate the number of x values in frame (length of x_vec)
        mx = size(x_vec, 1);
        % Find the middle x_row:
        if (mod(mx, 2) == 0)
            x_row = mx / 2.0;
        else
            x_row = (mx + 1) / 2.0;
        end

        % If dimensionalizing, change time
        if(to_seconds)
            time = time * T_DIM;
        end
        
        % Make the plot! (And set the color and legend entry)
        plots(i) = plot(x_vec, height(x_row,:, frame),...
            'LineWidth',LINEWIDTH);
        set(plots(i),'Color',[1-i/num_times 1 i/num_times]);
        % Add units to legend if needed
        if(to_seconds)
            legend_titles{i} = ['t = ',num2str(time),' s'];
        else
            legend_titles{i} = ['t = ',num2str(time)];
        end

        if (verbosity)
            message = sprintf('Created height graph for time: %01d',time)
        end
    end
    
    % Set up axes lables and legend
    title(input_title,...
        'FontSize',TITLE_SIZE);
    h = legend(legend_titles, 'Location', LEGEND_LOCATION); 
    set(h,'FontSize',LEGEND_SIZE);
    axis tight;
    
    if(to_seconds)
        xlabel('Radius (cm)',...
        'FontSize',AXIS_LABEL_SIZE);
        ylabel('Height (mm)',...
                'FontSize',AXIS_LABEL_SIZE);
    else
        xlabel('Radius',...
            'FontSize',AXIS_LABEL_SIZE);
        ylabel('Height',...
                'FontSize',AXIS_LABEL_SIZE);
    end

 end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Make Surfactant Graph
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (make_surf_profile)
    % Plot each individual line
    for i = 1 : num_times
        
        % Determine frame number height data for given time 
        time = graph_times(i);
        frame = int8(time * (1/timestep) + 1);
        % Calculate the number of x values in frame (length of x_vec)
        mx = size(x_vec, 1);
        % Find the middle x_row:
        if (mod(mx, 2) == 0)
            x_row = mx / 2.0;
        else
            x_row = (mx + 1) / 2.0;
        end

        % If dimensionalizing, change radius vector and time
        if(to_seconds)
            time = time * T_DIM;
        end
        
        % Make the plot! (And set the color and legend entry)
        plots(i) = plot(x_vec, all_surf(x_row,:, frame),...
            'LineWidth',LINEWIDTH);
        set(plots(i),'Color',[1-i/num_times 1 i/num_times]);
        
        % Add units to legend if needed
        if(to_seconds)
            legend_titles{i} = ['t = ',num2str(time),' s'];
        else
            legend_titles{i} = ['t = ',num2str(time)];
        end

        if (verbosity)
            message = sprintf('Created surf graph for time: %01d',time)
        end
    end
    
    % Set up axes lables and legend
    title(input_title,...
        'FontSize',TITLE_SIZE);
    h = legend(legend_titles, 'Location', LEGEND_LOCATION); 
    set(h,'FontSize',LEGEND_SIZE);
    axis tight;
    
    if(to_seconds)
        xlabel('Radius (cm)',...
            'FontSize',AXIS_LABEL_SIZE);
        ylabel('Surfactant Concentration (\mugrams/cm^2)',...
            'FontSize',AXIS_LABEL_SIZE);
    else
        xlabel('Radius',...
            'FontSize',AXIS_LABEL_SIZE);
        ylabel('Surfactant Concentration',...
            'FontSize',AXIS_LABEL_SIZE);
    end

end

hold off

if (verbosity)
    message = 'Finished execution.'
end

end

