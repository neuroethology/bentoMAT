function resetAnnotText(gui)
% clears the colored boxes that display active annotations

if(any(gui.enabled.movie))
    for i=1:length(gui.movie.annot)
        gui.movie.annot(i).String = '';
    end
end