function resizeBTA(source,~,gui)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


h = guidata(source);

pre     = str2num(h.pre.String);
post    = str2num(h.post.String);

set(h.fig,'xlim',[-pre post]);
set(h.fig_sub,'xlim',[-pre post]);

updateBTA(source,[],gui);