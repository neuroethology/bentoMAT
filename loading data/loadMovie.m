function [gui,data] = loadMovie(gui,data)

reader = struct();
switch(data.io.movie.readertype)
    case 'seq'
        for i = 1:length(data.io.movie.fid)
            temp         	= seqIo(data.io.movie.fid{i},'reader');
            rtemp           = temp.getinfo();
            rtemp.reader    = temp;
            if(i==1)
                reader    = rtemp;
            else
                reader(i) = rtemp;
            end
            Fr              = data.annoFR;  % the fps values in seq files are sometimes
                                            % inaccurate! trust the experimenter instead.
            tMax            = reader(i).numFrames/Fr;
        end
    otherwise
        for i = 1:length(data.io.movie.fid)
            if(i==1)
                reader      = VideoReader([data.io.movie.fid{i}]);
            else
                reader(i)   = VideoReader([data.io.movie.fid{i}]);
            end
            reader(i).CurrentTime = 0;
            Fr              = reader(i).FrameRate;
            tMax            = reader(i).Duration;
        end
end

% add the reader to the gui struct
data.io.movie.reader     = reader;

gui = applySliderUpdates(gui,'movie',data.io.movie);
