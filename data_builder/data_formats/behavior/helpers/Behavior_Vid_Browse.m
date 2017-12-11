function Behavior_Vid_Browse(source,~,fieldname)

gui = guidata(source);
if(strcmpi(source.Style,'pushbutton'))
    switch fieldname
        case 'fid'
            typestr = {'*.seq;*.mp4;*.avi;*.wmv', 'Behavior video (*.seq;*.mp4;*.avi;*.wmv)'};
        case 'annot'
            typestr = {'*.txt;*.annot;*.xls;*.xlsx', 'Annotation file (*.txt; *.annot;*.xls;*.xlsx)'};
        case 'track'
            typestr = {'*.mat;*.json', 'Tracking data (*.mat;*.json)'};
    end
    [FileName,PathName,~] = uigetfile([typestr;{'*.*',  'All Files (*.*)'}],'Pick a file',gui.pth);
    fname = [PathName FileName];
    if(FileName==0)
        return
    end
    else
    fname = source.String;
    if(isempty(fname))
        return
    end
end

ind = find([gui.fields.p] == source.Parent.Parent);
gui.fields(ind).data.(fieldname).String = fname;
formatSpec = 'HH:MM:SS.FFF';

if(strcmpi(fieldname,'fid'))
    [~,~,ext] = fileparts(fname);
    switch ext
        case '.seq'
            sr = seqIo(fname,'reader');
            ts = sr.getts();
            ts = datetime(ts(1),'convertfrom','posixtime','timezone','local');
            tString = datestr(ts,formatSpec);
            gui.fields(ind).data.time.String = tString;
            
            info = sr.getinfo();
            gui.fields(ind).data.FR.String = num2str(info.fps);
            gui.fields(ind).data.start.String = '1';
            gui.fields(ind).data.stop.String = num2str(info.numFrames);
    end

end

gui.pth = fileparts(fname);
guidata(source,gui);