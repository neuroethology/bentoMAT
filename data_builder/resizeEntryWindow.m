function resizeEntryWindow(source,~)

h = guidata(source);
h.pTop.Position(2) = h.f.Position(4)-90;
h.pTop.Position(1) = max((h.f.Position(3) - 730),0)/2+10;

bump = h.f.Position(4) - h.pTop.Position(4) - 10;
for i = 1:length(h.fields)
    bump = bump - h.fields(i).wrap.Position(4);
    h.fields(i).wrap.Position(2) = bump;
    h.fields(i).rm.Callback = {@entryWindowRmBox,i};
end
h.bump = bump;

if(bump<=10)
    h.bump = 10;
    guidata(h.f,h);
    h.f.Position(4) = h.f.Position(4) - bump + 10;
end
guidata(h.f,h);