function [mov,reader] = readBehMovieFrame(movie,time)
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
            frnum   = floor(time*movie.FR);
            frnum   = min(reader{col,i}.numFrames,frnum);

            % if this is slow, can use step instead of seek to take advantage
            % of sequential structure of movie. Will take some extra coding
            % though. Also, worth investigating whether this speeds up other
            % movie types as well?
            reader{col,i}.reader.seek(frnum);
            movies{col,i} = reader{col,i}.reader.getframe();
        otherwise
            tMax    = reader{col,i}.Duration - 1/reader{col,i}.FrameRate;
            time    = min(time, tMax);
            reader{col,i}.currentTime = time;
            movies{col,i} = readFrame(reader{col,i});
    end
end
    % pad each entry in to same width
    dims    = cellfun(@size,movies(col,:),'uniformoutput',false);
    dims    = cat(1,dims{:});
    [w,ind] = max(dims(:,2));
    for i = setdiff(1:size(dims,1),ind)
        pad = (w - dims(i,2))/2;
        movies{col,i} = padarray(movies{col,i},[0 pad],'both');
    end
    mov{col} = cat(1,movies{col,:});
end

% pad each column to same height
dims = cellfun(@size,mov,'uniformoutput',false);
dims = cat(1,dims{:});
[w,ind] = max(dims(:,1));
for i = setdiff(1:size(dims,1),ind)
    pad     = (w - dims(i,1))/2;
    mov{i}  = padarray(mov{i},[pad 0],'both');
end
mov = cat(2,mov{:});

