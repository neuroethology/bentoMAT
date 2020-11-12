function [data,featnames] = EMG_features(data, args)

if(iscell(args))
    argsStr = struct('features',[]);
    argsStr.data = args;
    args = argsStr;
    data.tracking.args{1} = args;
end
movieName = data.io.movie.fid{1};
segs = strsplit(movieName,'_');
segNumber = str2double(segs{find(strcmpi(segs,'segment'))+1}) + 1;

% unpack data
% data.rast       = args.data{segNumber}.spike';
% data.CaTime     = args.data{segNumber}.timeframe;
data.CaTime     = args.data{segNumber}.raw_EMG_timeframe;
for i=1:length(args.data{segNumber}.spike_timing)
    spks = args.data{segNumber}.spike_timing{i};
    data.rast(i,:) = hist(spks,data.CaTime);
end
data.CaFR       = 1/(data.CaTime(2)-data.CaTime(1));
data.annoFR     = data.CaFR;
data.annoTime   = data.CaTime;
data.trackTime  = args.data{segNumber}.raw_EMG_timeframe;
data.tracking.features          = permute(args.data{segNumber}.raw_EMG,[3 1 2]);
data.tracking.args{1}.features  = args.data{segNumber}.EMG_names;
featnames = data.tracking.args{1}.features;

% sync up time with movie?
% tMax = gui.data.io.movie.reader{1}.Duration;
data.CaTime     = data.CaTime - data.CaTime(1) - (1/data.CaFR) + 0.207;
dt              = data.trackTime(2)-data.trackTime(1);
data.trackTime  = data.trackTime - data.trackTime(1) + dt/2 + 0.1763;