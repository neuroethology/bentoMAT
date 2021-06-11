function [data,featnames] = EMG_features(data)

if(iscell(args))
    argsStr = struct('features',[]);
    argsStr.data = args;
    args = argsStr;
end
data.tracking.args{1} = args;

% unpack data
% using the binned spikes because I'm not sure about the framerate of the
% raw data
data.CaTime     = args.binnedFr;
data.rast = args.spikes_binned;
% for i=1:length(args.spike_times)
%     spks = args.spike_times{i};
%     data.rast(i,:) = hist(spks,data.CaTime);
% end
data.CaFR       = 1/(data.CaTime(2)-data.CaTime(1));
% data.annoFR     = data.CaFR;
% data.annoTime   = data.CaTime;
data.trackTime  = args.raw_EMG_timestamps;
data.tracking.features{1}          = args.raw_EMGs';
data.tracking.args{1}.features  = args.EMG_names;
featnames = data.tracking.args{1}.features;

% sync up time with movie?
% tMax = gui.data.io.movie.reader{1}.Duration;
data.CaTime     = data.CaTime - data.CaTime(1) - (1/data.CaFR);
dt              = data.trackTime(2)-data.trackTime(1);
data.trackTime  = data.trackTime - data.trackTime(1) + dt/2;