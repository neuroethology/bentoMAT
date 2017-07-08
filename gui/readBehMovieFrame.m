function [mov,reader] = readBehMovieFrame(movie,time)
% reader = the behavior movie struct; t = the current time in *seconds*

movies = [];
reader = movie.reader;
for i = 1:length(movie.reader) %loop over loaded movies
    type = movie.readertype;
    switch type
        case 'seq'
            %convert time to a frame number
            frnum   = floor(time*movie.FR);
            frnum   = min(reader(i).numFrames,frnum);

            % if this is slow, can use step instead of seek to take advantage
            % of sequential structure of movie. Will take some extra coding
            % though. Also, worth investigating whether this speeds up other
            % movie types as well?
            reader(i).reader.seek(frnum);
            movies{i} = reader(i).reader.getframe();
        otherwise
            tMax    = reader(i).Duration - 1/reader(i).FrameRate;
            time    = min(time, tMax);
            reader(i).currentTime = time;
            movies{i} = readFrame(reader(i));
    end
end

dims    = cellfun(@size,movies,'uniformoutput',false);
dims    = cat(1,dims{:});
[w,ind] = max(dims(:,2));
for i = setdiff(1:size(dims,1),ind)
    pad = (w - dims(i,2))/2;
    movies{i} = padarray(movies{i},[0 pad],'both');
end
mov = cat(1,movies{:});