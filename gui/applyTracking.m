function mov = applyTracking(gui,mov,time)

frnum = floor(time*gui.data.annoFR)+1;
if(isempty(gui.data.tracking.active{frnum})&frnum>1)
    gui.data.tracking.active{frnum} = gui.data.tracking.active{frnum-1};
end
if(isempty(gui.data.tracking.inactive{frnum})&frnum>1)
    gui.data.tracking.inactive{frnum} = gui.data.tracking.inactive{frnum-1};
end
    
eval(['pts = ' gui.data.tracking.fun '(gui.data.tracking.args, ' num2str(frnum) ' );']);

active       = gui.data.tracking.active{frnum};
inactive     = gui.data.tracking.inactive{frnum};

[~,indsA,indsB]     = intersect(pts(:,1),active);
if(~isempty(indsA))
    inds         = sortrows([indsB indsA],1);
    inds         = inds(:,2);
else
    inds=[];
end
plotActive   = pts(inds, 2:end);

[~,indsA,indsB]     = intersect(pts(:,1),inactive);
if(~isempty(indsA))
    inds         = sortrows([indsB indsA],1);
    inds         = inds(:,2);
else
    inds=[];
end
plotInactive = pts(inds, 2:end);

if(size(pts,2)<=3)
    mov = insertObjectAnnotation(mov,'circle',[plotActive 5*ones(length(active),1)],...
                                 cellstr(num2str( (1:length(active))' ))',...
                                 'color','magenta','textcolor','w','linewidth',4,'FontSize',12);
                             
    mov = insertObjectAnnotation(mov,'circle',[plotInactive 5*ones(size(plotInactive,1),1)],...
                                 cellstr(num2str( ((length(active)+1):size(pts,1))' ))',...
                                 'color','blue','textcolor','w','linewidth',2,'FontSize',12);
end

% apply crop+zoom if turned on
if(~isempty(gui.data.tracking.crop))
    mov = imcrop(mov,gui.data.tracking.crop);
end