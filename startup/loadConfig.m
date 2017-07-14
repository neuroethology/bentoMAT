function config = loadConfig()

config.midline   = 0.6;
config.rowscale  = 0.06;

config.ctrl = {'slider','track','annot','expt'};
% list of controls:
% expt, spectrogram, slider, track, annot
config.ctrlSc.spectrogram = 3; % lets you allocate extra space for a control bar