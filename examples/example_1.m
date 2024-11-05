%% Example 1 - Simply Supported Beam with a Point Load

Lengths = [0.8*L ;  0.2*L]; % Length of Each Element
Supports = [1 0; % [0 0] Means Free to Move and Rotate
            0 0; % [1 0] Means Restricted to Move (y-direction), Free to Rotate
            1 0]; % [1 1] Means Restricted to Move or Rotate (Fully Fixed)
PointLoads = [ 0 0; 
              -P 0;
               0 0] ;
% For PointLoads: First Fy (Vertical Load, Positive is Upwards),
% Then Mz (Bending Moment, Positive is Counter-Clockwise)
UniformLoads = [ 0 ; 0]; % Uniform Load Along Each Element, Positive is Upwards