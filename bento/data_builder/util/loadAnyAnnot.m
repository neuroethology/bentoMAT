function [annotations,tmax,tmin,FR,fid,hotkeys] = loadAnyAnnot(filename,tmin,tmax)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



[~,~,ext] = fileparts(filename);
loadRange = exist('tmin','var');
hotkeys = struct();

switch ext
    case '.xls' %old .annot format
    fid     = filename;
    if(loadRange)
        [annotations,~] = loadAnnotSheet(filename,tmin,tmax);
    else
        [annotations,tmax] = loadAnnotSheet(filename);
        tmin = 1;
    end
    FR = nan; %framerate not specified in file- trust user input to gui
    
    case '.annot' %new .annot format
    fid = filename;
    if(loadRange)
        [annotations,~,~,FR] = loadAnnotSheetTxt(filename,tmin,tmax);
    else
        try
        [annotations,tmin,tmax,FR] = loadAnnotSheetTxt(filename);
        catch
            keyboard
        end
    end
    
%     case 'csv' %temporary MUPET support
%         fid = filename;
%         M = dlmread(filename,',',1,0);
%         dt = strtemp.audio.t(2) - strtemp.audio.t(1);
%         atemp.singing.sing = round(M(:,2:3)/dt * 1.0000356445); % what's up, MUPET :\
%         tmin = 1;
%         tmax = length(strtemp.audio.t);
    
    case '.txt' %load data in the old format, OR ETHOVISION, prepare to convert to sheet format when saved
    fid = filename;
    if(loadRange)
        [annotations,~,hotkeys]    = loadAnnotFile(filename,tmin,tmax);
    else
        [annotations,tmax,hotkeys] = loadAnnotFile(filename);
        tmin = 1;
    end
    FR = nan; %framerate not specified in file- trust user input to gui
    otherwise
        [annotations,tmax,tmin,fid,hotkeys] = deal([]);
end