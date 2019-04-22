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
%                rtemp.TS        = (1:length(rtemp.seek))/rtemp.fps;
                 rtemp.TS        = rtemp.reader.getts();
                disp('done');
                reader{col,i}   = rtemp;
                tMax            = reader{col,i}.TS(end);
                tMin            = min([reader{col,i}.TS(1) tMin]);
%                 Fr              = data.annoFR;  % the fps values in seq files are sometimes
%                                                 % inaccurate! trust the experimenter instead.
%                 tMax            = reader{col,i}.numFrames/Fr;
            otherwise
                reader{col,i}       = VideoReader([data.io.movie.fid{col,i}]);
                reader{col,i}.CurrentTime = 0;
                Fr              = reader{col,i}.FrameRate;
                tMax            = reader{col,i}.Duration;
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
