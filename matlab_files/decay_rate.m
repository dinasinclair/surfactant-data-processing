function [myFit] = decay_rate

% time scaling
h_scale = 2.5;
t_scale = 5;
t_start = 3;
t_end = 10;

% Load in the file to get the total number of frames:
eval('tnf');

% Load in the first frame to get important values:
eval('frame0000');

% Put first frame's data in:
dist_height = zeros(1,tot_num_frames);
times = zeros(1,tot_num_frames);

% Now load in all of the other files:
for index = 1 : tot_num_frames
    file = sprintf('frame%04d', index-1);
    eval(file);
    file = sprintf('t%04d', index-1);
    eval(file);
    hmat = sprintf('height_mat%04d', index-1);
    time = eval(sprintf('time%04d', index-1));
    dist_height(index) = max(max(eval(hmat)));
    times(index) = time;
end

times = t_scale*times;
dist_height = h_scale*dist_height;

n_start = find(times==t_start);
n_end = find(times==t_end);
myFit = fit(times(n_start:n_end)',dist_height(n_start:n_end)'-2.5,'exp1');

plot(times,dist_height,t_start:.1:t_end,myFit(t_start:.1:t_end)+2.5);