function [movies,reader,frnum] = readBehMovieFrame(movie,time)
% reader = the behavior movie struct; t = the current time in *seconds*

movies = [];
reader = movie.reader;
for col = 1:size(movie.reader,1) %loop over loaded movies
    for i = 1:size(movie.reader,2)
        if(isempty(movie.fid{col,i}))
            continue;
        end
        type = movie.readertype{col,i};
        switch type
            case 'seq'
                %convert time to a frame number
%                 frnum   = floor(time*movie.FR);
                frnum   = find(reader{col,i}.TS>time,1,'first')-2;
                frnum   = min([reader{col,i}.numFrames frnum]);

                reader{col,i}.reader.seek(frnum);
                movies{col,i} = reader{col,i}.reader.getframe();
                frnum = frnum - (find(reader{col,i}.TS > movie.tmin/movie.FR,1,'first')-1);
            otherwise
                tMax    = reader{col,i}.Duration - 1/reader{col,i}.FrameRate;
                time    = min(time, tMax);
                reader{col,i}.currentTime = time;
                movies{col,i} = readFrame(reader{col,i});
                frnum = round(time*reader{col,i}.FrameRate);
        end
    end
end
