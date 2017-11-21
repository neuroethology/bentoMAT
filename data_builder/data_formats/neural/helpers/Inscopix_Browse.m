function Inscopix_Browse(source,~,fieldname)
    
gui = guidata(source);
switch fieldname
    case 'fid'
        typestr = {'*.mat', 'Extracted Ca traces (*.mat)'};
    case 'meta'
        typestr = {'*.txt', 'Ca imaging log files (*.txt)'};
end
[FileName,PathName,~] = uigetfile({typestr{:};'*.*',  'All Files (*.*)'},'Pick a file');
fname = [PathName FileName];
if(FileName==0)
    return
end

ind = find([gui.fields.p] == source.Parent.Parent);
gui.fields(ind).data.(fieldname).String = fname;
formatSpec = 'HH:MM:SS.FFF';

if(strcmpi(fieldname,'meta'))
    fid = fopen(fname);
    text = textscan(fid,'%s','Delimiter','\n');
    fclose(fid);
    text = text{1};
    sessMarkers = find(~cellfun(@isempty,strfind(text,'began recording.')));
    sessions = text(sessMarkers);
    for i=1:length(sessions)
        temp = regexp(sessions{i},' ','split');
        sessions{i} = temp{end-2};
    end
    if(~isempty(sessions))
        gui.fields(ind).data.metamenu.String = sessions;
    else
        gui.fields(ind).data.metamenu.String = '';
    end
    gui.fields(ind).data.metamenu.Value = 1;
    tRow = text(sessMarkers(1)-1+find(~cellfun(@isempty,strfind(text(sessMarkers(1):end),'RECORD START:')),1,'first'));
    tRow = regexprep(tRow,'RECORD START: ','');
    tString = datestr(datetime(tRow{1},'InputFormat','MMM dd, yyyy hh:mm:ss.SSS a'),formatSpec);
    gui.fields(ind).data.time.String = tString;

    tRow = text(sessMarkers(1)-1+find(~cellfun(@isempty,strfind(text(sessMarkers(1):end),'FPS:')),1,'first'));
    tRow = regexprep(tRow,'FPS: ','');
    gui.fields(ind).data.FR.String = tRow;

    tRow = text(sessMarkers(1)-1+find(~cellfun(@isempty,strfind(text(sessMarkers(1):end),'FRAMES:')),1,'first'));
    tRow = regexprep(tRow,'FRAMES: ','');
    gui.fields(ind).data.start.String = '1';
    gui.fields(ind).data.stop.String = tRow;

end