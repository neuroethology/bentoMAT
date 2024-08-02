function [annot,maxTime,hotkeys,FR] = loadAnnotFileXls(fname,defaultFR, tmin,tmax)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt

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

fid = fopen(fname);
if(fid==-1)
    keyboard
end

[~,sheetlist]   = xlsfinfo(fname);
fid = sheetlist{1};  % let's assume there's just one sheet for now- go back and fix this later
[~,~,M]      = xlsread(fname,fid);

hotkeys=struct();

if(any(strcmpi(M(1,:),'Event_type'))) % it's probably an Ethovision Observer log
    [annot,maxTime]  = loadAnnotSheetObserver(M, defaultFR);  % need to add tmin/tmax support
    FR = defaultFR;
elseif(any(strcmpi(M(1,:), 'Sinuosity')))  % it's probably DeepSqueak
    if defaultFR<1024
        defaultFR = 1024;
    end
    [annot,maxTime]  = loadAnnotSheetDeepSqueak(M, defaultFR);  % need to add tmin/tmax support
    FR = defaultFR;
else
    annot=[];maxTime=[];hotkeys=struct();
end
end