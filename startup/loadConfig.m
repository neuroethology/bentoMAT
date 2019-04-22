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


config.path_to_MARS = '/home/ann/Documents/GitHub/MARS_train_infer/';
