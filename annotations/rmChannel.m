function rmChannel(source,~,toDelete,parent)
gui = guidata(parent);
g2  = guidata(source);

ind = toDelete.Value;
toDelete = toDelete.String{ind};
channels = g2.chList.String;
channels = setdiff(channels,toDelete);
g2.chList.String = channels;

parent.String       = {channels{:},'add new...','remove channel...'};
if(strcmpi(toDelete,gui.annot.activeCh)) % active channel was deleted
    parent.Value        = min(ind,length(channels));
    gui.annot.activeCh  = channels{parent.Value};
    gui                 = transferAnnot(gui,gui.data);
    updateSliderAnnot(gui);
else
    parent.Value        = find(strcmpi(channels,gui.annot.activeCh));
end

gui.annot.channels  = channels;
gui.data.annot      = rmfield(gui.data.annot,toDelete);

if(any(gui.enabled.movie))
    for i=ind:length(gui.movie.annot)-1
        gui.movie.annot(i).String = '';
    end
end
guidata(gui.h0,gui);
updatePlot(gui.h0,[]);