%function max_h_v_t
%
eval('tnf');
n = tot_num_frames;    % number of frames
max_h = zeros(n,1);
times = zeros(n,1);
for i=1:n
    file_time = sprintf('t%04d', i-1);
    file_frame = sprintf('frame%04d', i-1);
    eval(file_time);
    eval(file_frame);
    height = sprintf('height_mat%04d',i-1);
    time = sprintf('time%04d',i-1);
    max_h(i) = max(max(eval(height)));
    times(i) = eval(time);
end
plot(max_h);
matrix = [times max_h];
save('decay_data.txt','matrix','-ASCII');