function toggleMovieQuality(source,~)

h = guidata(source);

if(any([1 4]==source.Value))
    h.qSlider.Enable = 'on';
    h.hi.Enable = 'on';
    h.lo.Enable = 'on';
else
    h.qSlider.Enable = 'off';
    h.hi.Enable = 'off';
    h.lo.Enable = 'off';
end