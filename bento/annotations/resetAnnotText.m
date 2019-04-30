function resetAnnotText(gui)
% clears the colored boxes that display active annotations
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



if(any(gui.enabled.movie))
    for i=1:length(gui.movie.annot)
        gui.movie.annot(i).String = '';
    end
end