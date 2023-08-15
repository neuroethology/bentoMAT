function [annotations,tmax,tmin,FR,fid,hotkeys] = loadAnyAnnot(filename,defaultFR, tmin,tmax)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



[~,~,ext] = fileparts(filename);
loadRange = exist('tmin','var');
hotkeys = struct();

switch ext
    case '.annot' %new .annot format
        fid = filename;
        if(loadRange)
            [annotations,~,~,FR] = loadAnnotSheetTxt(filename,tmin,tmax);
        else
            try
            [annotations,tmin,tmax,FR] = loadAnnotSheetTxt(filename);
            catch
                [annotations,tmax,tmin,fid,hotkeys] = deal([]);
                errordlg(['Couldn''t load annotation file at ' filename]);
            end
        end
    case {'.xls', '.xlsx'}
        fid     = filename;
        if(loadRange)
            [annotations, ~, hotkeys, FR] = loadAnnotFileXls(filename, defaultFR, tmin, tmax);
        else
            [annotations,tmax,hotkeys,FR] = loadAnnotFileXls(filename, defaultFR);
            tmin = 1;
        end
    case '.csv'  % Erin's grouped sequences
        fid = filename;
        M = dlmread(filename,',',1,0);
        FR = 1024;  % 1024 is the framerate I use for deepsqueak
        t_start = ceil(M(:,3)*FR);
        t_stop = ceil(M(:,4)*FR);
        drop = M(:,6)<3;
        t_start(drop)=[];
        t_stop(drop)=[];
        tmin = 1;
        tmax = t_stop(end);
        annotations.USV_clusters.bouts = [t_start t_stop];
%     case 'csv' %temporary MUPET support
%         fid = filename;
%         M = dlmread(filename,',',1,0);
%         dt = strtemp.audio.t(2) - strtemp.audio.t(1);
%         atemp.singing.sing = round(M(:,2:3)/dt * 1.0000356445); % what's up, MUPET :\
%         tmin = 1;
%         tmax = length(strtemp.audio.t);
    
    case '.txt'
    fid = filename;
    if(loadRange)
        [annotations,~,hotkeys,FR]    = loadAnnotFile(filename,defaultFR, tmin,tmax);
    else
        [annotations,tmax,hotkeys,FR] = loadAnnotFile(filename, defaultFR);
        tmin = 1;
    end
    otherwise
        [annotations,tmax,tmin,fid,hotkeys] = deal([]);
        errordlg(['Unrecognized extension for annotation file ' filename]);
end