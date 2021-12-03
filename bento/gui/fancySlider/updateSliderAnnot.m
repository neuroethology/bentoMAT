function updateSliderAnnot(gui)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



if(gui.enabled.annot(2))
    if(~isempty(gui.data.annoTime))
        time 	= round((gui.data.annoTime(end)-gui.data.annoTime(1))*gui.data.annoFR);
    elseif(all(gui.enabled.traces))
        time = round(gui.data.CaTime(end) - gui.data.CaTime(1)*gui.data.CaFR);
    elseif(isfield(gui.data,'trackTime'))
        time = round(gui.data.trackTime(end) - gui.data.trackTime(1)/(gui.data.trackTime(2)-gui.data.trackTime(1)));
    end

    offset = gui.data.io.annot.tmin/gui.data.annoFR;
    inds = find((gui.data.annoTime>=(gui.ctrl.slider.Min-offset)) & (gui.data.annoTime<=(gui.ctrl.slider.Max-offset)));
    img     = makeBhvImage(gui.annot.bhv,gui.annot.cmap,inds,time,gui.annot.show);

    bgsmall = displayImage(img,gui.ctrl.slider.Pos(3)*gui.h0.Position(3)*5,1);
    set(gui.ctrl.slider.bg,'cdata',bgsmall);
else
    set(gui.ctrl.slider.bg,'cdata',[]);
end