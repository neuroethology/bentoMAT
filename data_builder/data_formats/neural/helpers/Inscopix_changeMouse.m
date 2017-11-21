function Inscopix_changeMouse(source,~)

    gui=guidata(source);
    f = gui.fields.p==source.Parent.Parent;
    formatSpec = 'HH:MM:SS.FFF';

    fid = fopen(gui.fields(f).data.meta.String);
    text = textscan(fid,'%s','Delimiter','\n');
    fclose(fid);
    text = text{1};
    
    mousename = gui.fields(f).data.metamenu.String{gui.fields(f).data.metamenu.Value};
    ind = find(~cellfun(@isempty,strfind(text,mousename)),1,'first');
    
    tRow = text(ind - 1 + find(~cellfun(@isempty,strfind(text(ind:end),'RECORD START:')),1,'first'));
    tRow = regexprep(tRow,'RECORD START: ','');
    tString = datestr(datetime(tRow{1},'InputFormat','MMM dd, yyyy hh:mm:ss.SSS a'),formatSpec);
    gui.fields(f).data.time.String = tString;

    tRow = text(ind - 1 + find(~cellfun(@isempty,strfind(text(ind:end),'FPS:')),1,'first'));
    tRow = regexprep(tRow,'FPS: ','');
    gui.fields(f).data.FR.String = tRow;

    time = text(~cellfun(@isempty,strfind(text,'FRAMES:')));
    time = cellfun(@str2double,regexprep(time,'FRAMES: ',''));    
    ind  = gui.fields(f).data.metamenu.Value;
    gui.fields(f).data.start.String = num2str(sum(time(1:ind-1))+1);
    gui.fields(f).data.stop.String = num2str(sum(time(1:ind)));
end