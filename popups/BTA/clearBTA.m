function clearBTA(source,~)
h = guidata(source);

lines = get(h.fig,'children');
for i=2:length(lines)
    delete(lines(i));
end

lines = get(h.fig_sub,'children');
for i=2:length(lines)
    delete(lines(i));
end

h.isActive = 0;

guidata(source,h);