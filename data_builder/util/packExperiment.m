function [M,flag] = packExperiment(gui)

% blank out any accidental text that made it into hidden columns
gui.t.Data(:,~gui.rowVis) = {[]};
flag=0;
M = [cell(1,16); get(gui.t,'ColumnName')'; gui.t.Data];

% get path
pth = get(gui.root,'string');
%OS protection:
pth = strrep(pth,'\',filesep);
pth = strrep(pth,'/',filesep);
if(~strcmpi(pth(end),filesep))
    pth = [pth filesep];
end
M{1,1}  = pth;
M{1,2}  = 'Ca framerate:';
M{1,4}  = 'Annot framerate:';
M{1,6}  = 'Multiple trials/Ca file:';
M{1,7}  = get(gui.CaMulti,'Value');
M{1,8}  = 'Multiple trials/annot file:';
M{1,9}  = get(gui.annoMulti,'Value');
M{1,10} = 'Includes behavior movies:';
M{1,11} = get(gui.incMovies,'Value');
M{1,12} = 'Offset (in seconds; positive values = annot starts before Ca):';
M{1,13} = get(gui.offset,'Value');

% add Ca framerate data:
if(get(gui.CaFRtog,'Value')==0)
    CaFR = get(gui.CaFR,'String');
    if(isempty(CaFR))
        msgbox('Please enter the framerate of your Ca data.');
        flag = 1;
        return;
    end
    CaFR   = str2num(CaFR);
    M(1,3) = {CaFR};
else
    M(1,3) = {'variable'};
end

% add anno framerate data:
if(get(gui.annoFRtog,'Value')==0)
    annoFR = get(gui.annoFR,'String');
    if(isempty(annoFR))
        flag = 1;
        msgbox('Please enter the framerate of your annotations.');
        return;
    end
    annoFR = str2num(annoFR);
    M(1,5) = {annoFR};
else
    M(1,5) = {'variable'};
end