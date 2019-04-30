function movies = applyTracking(gui,movies)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



% check which movie we're plotting tracking on
[rr,cc] = identifyTrackedMovie(gui.data);

info = gui.data.io.movie.reader{rr,cc}.reader.getinfo();
frnum = info.curFrame+1;
if(frnum<2)
    return;
end
    
eval(['pts = ' gui.data.tracking.fun '(gui.data.tracking.args, ' num2str(frnum) ' );']);
if(isstruct(pts))
    color = pts.color;
    pts = pts.pts;
else
    color = 'gcrgcrgcrgcrgcr';
    color = [color color color];
end
if(isfield(gui.data.io.movie,'fid') && length(gui.data.io.movie.fid)>1)
    dims = [gui.data.io.movie.reader{1}.width];
    if(dims(1)~=max(dims))
        pad = (max(dims)-dims(1))/2;
        for i=1:size(pts,1)
            pts(i,2:2:end)=pts(i,2:2:end)+pad;
        end
    end
end
plotActive = pts(:,2:end);
plotInactive = [];
% if(frnum>1 && isempty(gui.data.tracking.active{frnum}))
%     gui.data.tracking.active{frnum} = gui.data.tracking.active{frnum-1};
% end
% if(frnum > 1 && isempty(gui.data.tracking.inactive{frnum}))
%     gui.data.tracking.inactive{frnum} = gui.data.tracking.inactive{frnum-1};
% end
% active       = gui.data.tracking.active{frnum};
% inactive     = gui.data.tracking.inactive{frnum};
% 
% [~,indsA,indsB]     = intersect(pts(:,1),active);
% if(~isempty(indsA))
%     inds         = sortrows([indsB indsA],1);
%     inds         = inds(:,2);
% else
%     inds=[];
% end
% plotActive   = pts(inds, 2:end);
% 
% [~,indsA,indsB]     = intersect(pts(:,1),inactive);
% if(~isempty(indsA))
%     inds         = sortrows([indsB indsA],1);
%     inds         = inds(:,2);
% else
%     inds=[];
% end
% plotInactive = pts(inds, 2:end);


if(size(pts,2)<=4)
%     mov = insertObjectAnnotation(mov,'circle',plotActive,...
%                                  cellstr(num2str( (1:length(active))' ))',...
%                                  'color','green','textcolor','w','linewidth',4,'FontSize',12);
%                              
%     mov = insertObjectAnnotation(mov,'circle',plotInactive,...
%                                  cellstr(num2str( ((length(active)+1):size(pts,1))' ))',...
%                                  'color','blue','textcolor','w','linewidth',2,'FontSize',12);
else
    for j=1:size(plotActive,1)
        for i = 3:2:size(plotActive,2)
            if(isnumeric(color)), c = color(j,:);
            else, c = color(j); end
            movies{rr,cc} = insertShape(movies{rr,cc},'Line',plotActive(j,i-2:i+1),'linewidth',3,'color',c);
            movies{rr,cc} = insertShape(movies{rr,cc},'FilledCircle',[plotActive(j,i:i+1) 6],'color',c);
        end
%         movies{rr,cc} = insertShape(movies{rr,cc},'FilledCircle',[plotActive(j,1:2) 7],'color','red','opacity',1);
    end
    for j=1:size(plotInactive,1)
        if(isnumeric(color)), c = color(j,:);
        else, c = color(j); end
        for i = 3:2:size(plotInactive,2)
            movies{rr,cc} = insertShape(movies{rr,cc},'Line',plotInactive(j,i-2:i+1),'linewidth',3,'color',c);
            movies{rr,cc} = insertShape(movies{rr,cc},'FilledCircle',[plotInactive(j,i:i+1) 6],'color',c);
        end
%         movies{rr,cc} = insertShape(movies{rr,cc},'FilledCircle',[plotInactive(j,1:2) 7],'color','red','opacity',1);
    end
end