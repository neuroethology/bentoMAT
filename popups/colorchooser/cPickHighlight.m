function cPickHighlight(source,~)
data = guidata(source);

% keyboard
hit = find([data.h.bhvrs.Value]);
for i=1:length(data.h.lbls)
    if(i==hit)
        set(data.h.lbls(i),'FontWeight','bold');
    else
        set(data.h.lbls(i),'FontWeight','normal');
    end
end

color = rgb2hsv(get(data.h.bhvrs(hit),'BackgroundColor'));
X = sqrt(color(2));
Y = 1 - color(3);

X = max(min(ceil(X*300),300),1);
Y = max(min(ceil(Y*300),300),1);

data = updateMap(data,color(1));
data.X = X;
data.Y = Y;

set(data.h.cursor,'xdata',X,'ydata',Y);
set(data.h.Hchooser,'ydata',(1-color(1))*[500 500]);

data.active = hit;
guidata(source,data);