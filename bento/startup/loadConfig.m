function config = loadConfig()
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



config.midline   = 0.6;
config.rowscale  = 0.06;

config.ctrl = {'slider','track','annot','expt'};
% list of controls:
% expt, spectrogram, slider, track, annot
config.ctrlSc.spectrogram = 3; % lets you allocate extra space for a control bar

config.path_to_MARS = '';

% some display settings for tracking:

config.trackingText = false; % set to true to display a number next to each tracked object
config.openCircles = false;  % set to true to use open circles for tracked keypoints
config.ptSize = 4; % size of tracker point in pixels