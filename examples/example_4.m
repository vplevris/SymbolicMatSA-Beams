%% Example 4 - Simply Supported Beam with Uniform Load

Lengths = [a ; b ; L-a-b]; % Length of Each Element
Supports = [1 0; % [0 0] Means Free to Move and Rotate
            0 0; % [1 0] Means Restricted to Move (y-direction), Free to Rotate
            0 0; % [1 1] Means Restricted to Move or Rotate (Fully Fixed)
            1 0]; 
PointLoads = [ 0  0;
               0  0;
               0  0;
               0  0];
% For PointLoads: First Fy (Vertical Load, Positive is Upwards),
% Then Mz (Bending Moment, Positive is Counter-Clockwise)
UniformLoads = [ 0; -w; 0]; % Uniform Load Along Each Element, Positive is Upwards