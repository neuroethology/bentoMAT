function Audio_Browse(source,~,fieldname)

gui = guidata(source);
if(strcmpi(source.Style,'pushbutton'))
    switch fieldname
        case 'fid'
            typestr = {'*.mp3;*.wav;*.ogg;*.flac;*.au', 'Audio files (*.mp3;*.wav;*.ogg;*.flac;*.au)';
                       '*.mat', 'Saved spectrogram (*.mat)'};
        case 'annot'
            typestr = {'*.txt', 'MUPET event times (*.txt)'};
        case 'meta'
            typestr = {'*.txt', 'Audio log files (*.txt)'};
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

ind = find([gui.fields.p]==source.Parent.Parent);
gui.fields(ind).data.(fieldname).String = fname;
formatSpec = 'HH:MM:SS.FFF';

if(strcmpi(fieldname,'meta'))
    fid = fopen(fname);
    text = textscan(fid,'%s\t%s\t%s\t%s\t%s');
    fclose(fid);

    text = cellfun(@(x)x(2:end),text,'uniformoutput',false);
    text = text(2:end);
    nmice = length(unique(text{4}));
    if(nmice>0)
        gui.fields(ind).data.metamenu.String = unique(text{4});
    else
        gui.fields(ind).data.metamenu.String = '';
    end
    gui.fields(ind).data.metamenu.Value = 1;
    tEvent = datetime([text{1}{1} ' ' text{2}{1}],'InputFormat','yyyyMMdd HH:mm:ss.SSS');
    tStart = tEvent - seconds(str2num(text{3}{1}));
    tString = datestr(tStart,formatSpec);
    gui.fields(ind).data.time.String = tString;
    
elseif(strcmpi(fieldname,'fid'))
    [~,~,ext] = fileparts(fname);
    if(strcmpi(ext,'.mat'))
        t = load(fname,'t');
        gui.fields(ind).data.FR.String     = num2str(1/(t.t(2)-t.t(1)));
        gui.fields(ind).data.start.String = '1';
        gui.fields(ind).data.stop.String  = num2str(length(t.t));
    else
        info = audioinfo(fname);
        gui.fields(ind).data.FR.String    = num2str(info.SampleRate);
        gui.fields(ind).data.start.String = '1';
        gui.fields(ind).data.stop.String  = num2str(info.TotalSamples);
    end
    
end

gui.pth = fileparts(fname);
guidata(source,gui);








