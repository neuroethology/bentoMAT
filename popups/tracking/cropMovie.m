function cropMovie(source,~,type)

h   = guidata(source);
gui = guidata(h.guifig);

if(strcmpi(type,'revert'))
    gui.data.tracking.crop = [];
    guidata(gui.h0,gui);
    updatePlot(gui.h0,[]);
    return;
end

axes(gui.movie.axes);
[~, rect] = imcrop(gui.movie.img);

gui.data.tracking.crop = rect;
guidata(gui.h0,gui);
updatePlot(gui.h0,[]);