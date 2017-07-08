function colorPick(source,~,val)
if(~val)
    set(source,'WindowButtonMotionFcn','');
    return
end

data = guidata(source);
% check if click was on colorwheel
oldUnits = get(0,'units');
set(0,'units','pixels');
 
% Get the figure beneath the mouse pointer & mouse pointer pos
try
   fig = get(0,'PointerWindow');  %R2014a or older
catch
   fig = matlab.ui.internal.getPointerWindow;  %R2014b or newer
end
p = get(0,'PointerLocation');
set(0,'units',oldUnits);

figPos = getpixelposition(fig);
axPos = data.h.SVax.Position;
axPos = axPos.*[figPos(3:4) figPos(3:4)] + [figPos(1:2) 0 0];
axPos(3:4) = axPos(3:4)+axPos(1:2);

axPos2 = data.h.RGBax.Position;
axPos2 = axPos2.*[figPos(3:4) figPos(3:4)] + [figPos(1:2) 0 0];
axPos2(3:4) = axPos2(3:4)+axPos2(1:2);


SVoff = (p(1)<axPos(1))|(p(2)<axPos(2))|(p(1)>axPos(3))|(p(2)>axPos(4));
Hoff  = (p(1)<axPos2(1))|(p(2)<axPos2(2))|(p(1)>axPos2(3))|(p(2)>axPos2(4));
if(SVoff&Hoff)
    return
end

set(source,'WindowButtonMotionFcn',{@colorPick,1});
if(~SVoff)
    X = (p(1) - axPos(1))/(axPos(3) - axPos(1)) * 300;
    Y = (axPos(4) - p(2))/(axPos(4) - axPos(2)) * 300;
    set(data.h.cursor,'xdata',X,'ydata',Y);

    X = max(min(ceil(X),300),1);
    Y = max(min(ceil(Y),300),1);
    set(data.h.bhvrs(data.active),'BackgroundColor',data.img(Y,X,:));
    beh = strrep(data.h.lbls(data.active).String,' ','_');
    data.cmap.(beh) = squeeze(data.img(Y,X,:));
else
    Hval = 1-(axPos2(4) - p(2))/(axPos2(4) - axPos(2));
    data = updateMap(data,Hval);

    X = max(min(ceil(get(data.h.cursor,'xdata')),300),1);
    Y = max(min(ceil(get(data.h.cursor,'ydata')),300),1);
    set(data.h.bhvrs(data.active),'backgroundcolor',data.img(Y,X,:));
    set(data.h.Hchooser,'ydata',(1-Hval)*[500 500]);
end
guidata(source,data);