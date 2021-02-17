function [movies,reader,frnum] = readBehMovieFrame(movie,time)
% reader = the behavior movie struct; t = the current time in *seconds*
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



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
                frnum = round(time*reader{col,i}.FrameRate);
%                 reader{col,i}.currentTime = time + 1/reader{col,i}.FrameRate;
%                 movies{col,i} = readFrame(reader{col,i});
                movies{col,i} = read(reader{col,i},frnum);
%                 imfix = zeros(480,720,3);
%                 for ch = 1:3
%                     temp = reshape(squeeze(movies{col,i}(:,:,ch)),480,[]);
%                     imfix(:,(ch-1)*(810-720)+1:end,ch) = temp(:,1:(720-(ch-1)*(810-720)));
%                     if(ch<3)
%                         imfix(:,1:(ch)*(810-720),ch+1) = temp(:,720-(ch-1)*(810-720)+1:end);
%                     end
%                 end
%                 movies{col,i} = imfix(:,1:720,:)/255;
        end
    end
end
