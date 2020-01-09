function movies = applyTracking(gui,movies,time)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


if(gui.enabled.movie(1))
    % check which movie we're plotting tracking on
    [rr,cc] = identifyTrackedMovie(gui.data);
    
    switch gui.data.io.movie.readertype{rr,cc}
        case 'seq'
            info = gui.data.io.movie.reader{rr,cc}.reader.getinfo();
            frnum = info.curFrame+1;
        case 'vid'
            frnum = round(gui.data.io.movie.reader{rr,cc}.CurrentTime * ...
                          gui.data.io.movie.reader{rr,cc}.FrameRate);
    end
    if(frnum<2)
        return;
    end
else
    [rr,cc]=deal(1);
    frnum = find(gui.data.annoTime>time,1,'first');
end

for trackFile = 1:length(gui.data.tracking.args)
    eval(['pts = ' gui.data.tracking.fun '(gui.data.tracking.args{trackFile}, ' num2str(frnum) ' );']);
    if(isstruct(pts))
        color = pts.color;
        pts = pts.pts;
    else
        color = {'green','blue','red','magenta'};
        color = [color color color]; color = [color color color];
    end
    if(isfield(gui.data.io.movie,'fid') && length(gui.data.io.movie.fid)>1)
        dims = [gui.data.io.movie.reader{1}.width];
        if(dims(1)~=max(dims))
            pad = (max(dims)-dims(1))/2;
            for i=1:length(pts)
                pts{i}(2:2:end)=pts{i}(2:2:end)+pad;
            end
        end
    end

    for j=1:length(pts)
        if(max(pts{j}(2:end))<=1) %means points are probably in relative coordinates
            scale = [size(movies{rr,cc},2) size(movies{rr,cc},1) ...
                     size(movies{rr,cc},2) size(movies{rr,cc},1)];
        else
            scale = [1 1 1 1];
        end
        if(isnumeric(color)), c = color(j,:); else, c = color{j}; end
        for i = 2:2:length(pts{j})-2
            if(any(isnan(pts{j}(i:i+1)))), continue; end
            movies{rr,cc} = insertShape(movies{rr,cc},'FilledCircle',[pts{j}(i:i+1).*scale(1:2) 6],'color',c);

            if(any(isnan(pts{j}(i:i+3)))), continue; end
            movies{rr,cc} = insertShape(movies{rr,cc},'Line',pts{j}(i:i+3).*scale,'linewidth',2,'color',c);

        end
        if(any(isnan(pts{j}(i:i+1)))), continue; end
        movies{rr,cc} = insertShape(movies{rr,cc},'FilledCircle',[pts{j}(length(pts{j})-1:length(pts{j})).*scale(1:2) 6],'color',c);
        if(any(isnan(pts{j}(1:2)))), continue; end
        movies{rr,cc} = insertShape(movies{rr,cc},'FilledCircle',[pts{j}(2:3).*scale(1:2) 6],'color','red','opacity',1);
    end
end