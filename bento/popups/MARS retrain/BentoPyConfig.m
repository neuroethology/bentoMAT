function [flag,path_to_MARS,config] = BentoPyConfig(config)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



flag=0;
[~, ~, isloaded] = pyversion; %get python up and running if it's not already
if(~isloaded)
    try
        pyversion 3.8;
    catch
        flag=0;
        path_to_MARS = config.path_to_MARS;
        return;
    end
end

% protect against multiprocessing madness
mod     = py.importlib.import_module('multiprocessing');
[~,exe] = pyversion;
if(isunix)
    py.multiprocessing.spawn.set_executable(exe);
else
    py.multiprocessing.set_executable(exe);
end

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