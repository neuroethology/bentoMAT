function [annotations,tmin,tmax,hotkeys,FR] = loadAnnotCSV(fname, defaultFR, tmin, tmax)

if(nargin<2)
    defaultFR = 1000;
elseif(nargin<3)
    tmin = 1;
    tmax = inf;
elseif(isstr(tmin))
    tmin = str2num(tmin);
    tmax = str2num(tmax);
end
FR = nan; %framerate not usually specified in these kinds of files, return nan to let the gui decide.

data = readtable(fname);
labels = data.Properties.VariableNames(2:end);

hotkeys = struct();
annotations = struct();
tmax = size(data,1);

for behavior=labels
    annotations.ch1.(behavior{:}) = convertToBouts(data.(behavior{:})');
end