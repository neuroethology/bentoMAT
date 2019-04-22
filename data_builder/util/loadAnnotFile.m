function [annot,maxTime,hotkeys] = loadAnnotFile(fname,tmin,tmax)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


if(nargin<2)
    tmin = 1;
    tmax = inf;
elseif(isstr(tmin))
    tmin = str2num(tmin);
    tmax = str2num(tmax);
end

fid = fopen(fname);
if(fid==-1)
    keyboard
end
M = textscan(fid,'%s','delimiter','\n'); M=M{1};
fclose(fid);

hotkeys=struct();
if(isempty(strtrim(M)))
    annot=[];maxTime=[];hotkeys=struct();
elseif(strcmpi(strtrim(M(1)),'Caltech Behavior Annotator - Annotation File'))
    [annot,maxTime,hotkeys] = loadAnnotFileCaltech(M,tmin,tmax);
elseif(strcmpi(strtrim(M(1)),'scorevideo LOG'))
    [annot,maxTime]  = loadAnnotFileEthovision(M);
else
    annot=[];maxTime=[];hotkeys=struct();
end