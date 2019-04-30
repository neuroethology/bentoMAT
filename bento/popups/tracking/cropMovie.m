function cropMovie(source,~,type)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



gui   = guidata(source);

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