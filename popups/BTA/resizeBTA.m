function resizeBTA(source,~,data)
h = guidata(source);

pre     = str2num(h.pre.String);
post    = str2num(h.post.String);

set(h.fig,'xlim',[-pre post]);
set(h.fig_sub,'xlim',[-pre post]);

updateBTA(source,[],data);