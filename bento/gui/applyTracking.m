function movies = applyTracking(gui,movies,time)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt

if(isempty(time))
    time=0;
end
if gui.config.openCircles
    trackMarker = 'Circle';
else
    trackMarker = 'FilledCircle';
end


if(gui.enabled.movie(2))
    % check which movie we're plotting tracking on
    [rr,cc] = identifyTrackedMovie(gui.data);
    
    switch gui.data.io.movie.readertype{rr,cc}
        case 'seq'
            info = gui.data.io.movie.reader{rr,cc}.reader.getinfo();
            frnum = info.curFrame+1;
        case 'vid'
            frnum = round(time * gui.data.io.movie.reader{rr,cc}.reader.FrameRate);
            frnum = round(gui.data.io.movie.reader{rr,cc}.reader.CurrentTime * gui.data.io.movie.reader{rr,cc}.reader.FrameRate);
    end
    if(frnum<2)
        return;
    end
else
    [rr,cc]=deal(1);
    if(isfield(gui.data,'trackTime') && ~isempty(gui.data.trackTime))
        frnum = find(gui.data.trackTime>time,1,'first');
        if(isempty(frnum))
            frnum = length(gui.data.trackTime);
        end
    else
        % problem!!! the annotation timestamps aren't necessarily the same as
        % the pose estimation timestamps! default to assuming video was 30hz.
        frnum = max(round(time*30),1);
    end
end

for trackFile = 1:length(gui.data.tracking.args)
    try
    eval(['pts = ' gui.data.tracking.fun '(gui.data.tracking.args{trackFile}, ' num2str(frnum) ' );']);
    catch
        keyboard
    end
    if(isstruct(pts))
        color = pts.color;
        pts = pts.pts;
    else
        color = {'green','cyan','red','magenta','yellow','white','blue'};
    end
    if(isfield(gui.data.io.movie,'fid') && length(gui.data.io.movie.fid)>1)
        dims = [gui.data.io.movie.reader{1}.reader.width];
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
        if(isnumeric(color)), c = color(mod(pts{j}(1),length(color))+1,:); else, c = color{mod(pts{j}(1),length(color))+1}; end
        
        pts{j} = double(pts{j});
        if(length(pts{j})>3) % if it's a pose and not a single point
            for i = 2:2:length(pts{j})-2
                if(any(isnan(pts{j}(i:i+1)))), continue; end
                movies{rr,cc} = insertShape(movies{rr,cc},trackMarker,[pts{j}(i:i+1).*scale(1:2) gui.config.ptSize],'color',c);

                if(any(isnan(pts{j}(i:i+3)))), continue; end
                movies{rr,cc} = insertShape(movies{rr,cc},'Line',pts{j}(i:i+3).*scale,'linewidth',1,'color',c);

            end
            if(any(isnan(pts{j}(i:i+1)))), continue; end
            if(~(isnan(pts{j}(length(pts{j})-1)) && isnan(pts{j}(length(pts{j})))))
                movies{rr,cc} = insertShape(movies{rr,cc},trackMarker,[pts{j}(length(pts{j})-1:length(pts{j})).*scale(1:2) gui.config.ptSize],'color',c);
            end
        end
    end
    
    for j=1:length(pts)    
        if(any(isnan(pts{j}(1:2)))), continue; end
%         if j==1 || pts{j}(1)~=pts{j-1}(1)
%             movies{rr,cc} = insertShape(movies{rr,cc},trackMarker,[pts{j}(2:3).*scale(1:2) gui.config.ptSize*1.25],'color','red','opacity',1);
%         end
        
        if(gui.config.trackingText)
            textPos  = [pts{j}(2:3).*scale(1:2)] + .005*size(movies{rr,cc},1)*[1 1];
            movies{rr,cc} = insertText(movies{rr,cc},textPos,num2str(j),'BoxColor','red','TextColor','white','FontSize',10);    
        end
    end

    px = []; py = [];
    for j = 1:length(pts)
        px = [px pts{j}(2:2:end)];
        py = [py pts{j}(3:2:end)];
    end
    ctr = [nanmedian(py) nanmedian(px)];
    win = 150;
%     movies{rr,cc} = movies{rr,cc}(max(ctr(1)-win,1) : min(ctr(1)+win, size(movies{rr,cc},1)), ...
%                                   max(ctr(2)-win,1) : min(ctr(2)+win, size(movies{rr,cc},2)), :);
end