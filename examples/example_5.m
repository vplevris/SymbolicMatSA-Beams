%% Example 5 - Four-Span Beam with Uniform Load

Lengths = [L ; L; L; L]; % Length of Each Element
Supports = [1 0; % [0 0] Means Free to Move and Rotate
            1 0; % [1 0] Means Restricted to Move (y-direction), Free to Rotate
            1 0; % [1 1] Means Restricted to Move or Rotate (Fully Fixed)
            1 0;
            1 1];
PointLoads = [ 0  0;
               0  0;
               0  0;
               0  0;               
               0  0];
% For PointLoads: First Fy (Vertical Load, Positive is Upwards),
% Then Mz (Bending Moment, Positive is Counter-Clockwise)
UniformLoads = [ -w; -w; -w; -w]; % Uniform Load Along Each Element, Positive is Upwards