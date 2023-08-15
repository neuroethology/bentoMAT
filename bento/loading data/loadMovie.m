function [gui,data] = loadMovie(gui,data)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



reader = {};tMin=inf;
for col = 1:size(data.io.movie.fid,1)
    for i = 1:size(data.io.movie.fid,2)
        if(isempty(data.io.movie.fid{col,i}))
            continue;
        end
        switch(data.io.movie.readertype{col,i})
            case 'seq'
                temp         	= seqIo(data.io.movie.fid{col,i},'reader');
                rtemp           = temp.getinfo();
                rtemp.reader    = temp;
                disp('getting timestamps...');
                rtemp.TS        = getSeqTimestamps(data.io.movie.fid{col,i},temp);
                temp = rtemp.TS(2:end) - rtemp.TS(1:end-1);
                if (mean(temp<0)>.01) %  sometimes timestamps and fps data in seq files are garbage :(
                    rtemp.TS = (1:length(rtemp.seek))/30;
                end
                disp('done');
                reader{col,i}   = rtemp;
                tMax            = reader{col,i}.TS(end);
                tMin            = min([reader{col,i}.TS(1) tMin]);
%                 Fr              = data.annoFR;  % the fps values in seq files are sometimes
%                                                 % inaccurate! trust the experimenter instead.
%                 tMax            = reader{col,i}.numFrames/Fr;
            otherwise
                rtemp       = VideoReader([data.io.movie.fid{col,i}]);
                rtemp.CurrentTime = 0;
                Fr              = rtemp.FrameRate;
                tMax            = rtemp.Duration;

                reader{col,i}.reader = rtemp;
                reader{col,i}.FrameRate = Fr;
                reader{col,i}.Duration = tMax;
                reader{col,i}.NumFrames = rtemp.NumFrames;
                
                timestamps = getVideoTimestamps(data.io.movie.fid{col,i});
                if timestamps
                    tMax = timestamps(end);
                    Fr = 1/median(timestamps(2:end)-timestamps(1:end-1));
                    reader{col,i}.TS = timestamps;
                else
                    reader{col,i}.TS = [];
                end
        end
    end
end

for col = 1:size(data.io.movie.fid,1)
    for i = 1:size(data.io.movie.fid,2)
        if(isempty(data.io.movie.fid{col,i}))
            continue;
        end
        switch(data.io.movie.readertype{col,i})
            case 'seq'
                reader{col,i}.TS = reader{col,i}.TS - tMin;
        end
    end
end

% add the reader to the gui struct
data.io.movie.reader     = reader;

gui = applySliderUpdates(gui,'movie',data.io.movie);
