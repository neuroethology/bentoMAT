function entryWindowRmBox(source,~,N)

h = guidata(source);

delete(h.fields(N).wrap);
h.fields(N)=[];

bump = h.f.Position(4) - h.pTop.Position(4) - 10;
for i = 1:length(h.fields)
    bump = bump - h.fields(i).wrap.Position(4);
    h.fields(i).wrap.Position(2) = bump;
    h.fields(i).rm.Callback = {@entryWindowRmBox,i};
end
h.bump = 10;
guidata(h.f,h);
h.f.Position(4) = h.f.Position(4) - bump + 10;
h.f.Position(2) = h.f.Position(2) + bump - 10;