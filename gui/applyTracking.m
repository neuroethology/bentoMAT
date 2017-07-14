function mov = applyTracking(gui,mov,time)

frnum = round(time*gui.data.annoFR);
eval(['mov = ' gui.data.tracking.fun '(mov, ' num2str(frnum) ', gui.data.tracking.args);']);