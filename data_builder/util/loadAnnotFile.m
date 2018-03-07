function [annot,maxTime] = loadAnnotFile(fname,tmin,tmax)
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

if(strcmpi(M(1),'Caltech Behavior Annotator - Annotation File'))
    [annot,maxTime] = loadAnnotFileCaltech(M,tmin,tmax);
else
    [annot,maxTime]  = loadAnnotFileEthovision(M);
end