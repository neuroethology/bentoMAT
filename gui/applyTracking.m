function mov = applyTracking(gui,mov,time)

frnum = round(time*gui.data.annoFR);
if(frnum>length(gui.data.tracking.active))
    gui.data.tracking.active{frnum}=[];
end

eval(['mov = ' gui.data.tracking.fun '(mov, ' num2str(frnum) ...
            ', gui.data.tracking.active{frnum}, gui.data.tracking.args);']);

% apply crop+zoom if turned on
if(~isempty(gui.data.tracking.crop))
    mov = imcrop(mov,gui.data.tracking.crop);
end