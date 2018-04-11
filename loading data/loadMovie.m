function [gui,data] = loadMovie(gui,data)

reader = {};
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
                reader{col,i}   = rtemp;
                Fr              = data.annoFR;  % the fps values in seq files are sometimes
                                                % inaccurate! trust the experimenter instead.
                tMax            = reader{col,i}.numFrames/Fr;
            otherwise
                reader{col,i}       = VideoReader([data.io.movie.fid{i}]);
                reader{col,i}.CurrentTime = 0;
                Fr              = reader{col,i}.FrameRate;
                tMax            = reader{col,i}.Duration;
        end
    end
end

% add the reader to the gui struct
data.io.movie.reader     = reader;

gui = applySliderUpdates(gui,'movie',data.io.movie);
