function [annot,maxTime,hotkeys,FR] = loadAnnotFile(fname,defaultFR, tmin,tmax)
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
M = textscan(fid,'%s','delimiter','\n'); M=M{1};
fclose(fid);

hotkeys=struct();
if(isempty(strtrim(M)))
    annot=[];maxTime=[];hotkeys=struct();
elseif(strcmpi(strtrim(M(1)),'Caltech Behavior Annotator - Annotation File'))
    [annot,maxTime,hotkeys] = loadAnnotFileCaltech(M,tmin,tmax);
elseif(strcmpi(strtrim(M(1)),'scorevideo LOG')) % what about (automated) Ethovision?
    [annot,maxTime]  = loadAnnotFileEthovision(M);
else
    cleantext = cellfun(@(x) string(char(nonzeros(double(x))')),M,'uniformoutput',false); % stupid unicode weirdness
    cleantext = cellfun(@(x) x{1},cleantext,'uniformoutput',false);
    cleantext = cleantext(cell2mat(cellfun(@(x) ~isempty(x), cleantext,'uniformoutput',false)));
    if(contains(cleantext{1},'Date_Time_Absolute')) % maybe it's an Ethovision Observer log? hopefully this string is in all Observer logs, I have no idea
        [annot,maxTime]  = loadAnnotFileObserver(cleantext, defaultFR); %ask the user (or gui) to provide a framerate
        FR = defaultFR;
    else
        annot=[];maxTime=[];hotkeys=struct();
    end
end