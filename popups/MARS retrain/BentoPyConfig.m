function [flag,path_to_MARS,config] = BentoPyConfig(config)

flag=0;
[~, ~, isloaded] = pyversion; %get python up and running if it's not already
if(~isloaded)
    pyversion 2.7; % MARS doesn't work with 3.5
end

% mod     = py.importlib.import_module('multiprocessing');
% [~,exe] = pyversion;
% py.multiprocessing.spawn.set_executable(exe); % protect against multiprocessing madness


% add an option to set the MARS path in the future
if(isempty(config.path_to_MARS))
    path_to_MARS = uigetdir('Please provide path to the MARS_train_infer directory');
    if(~path_to_MARS)
        flag=1;
        return;
    end
    config.path_to_MARS = path_to_MARS;
else
    path_to_MARS = config.path_to_MARS;
end

if(count(py.sys.path,path_to_MARS)==0)
    insert(py.sys.path,int32(0),path_to_MARS);
end

% set up the folder for saving temporary classifiers
if(~exist([path_to_MARS 'Bento_temp'],'dir'))
    mkdir([path_to_MARS 'Bento_temp']);
end

if(~exist([path_to_MARS 'Bento'],'dir'))
    mkdir([path_to_MARS 'Bento']);
end