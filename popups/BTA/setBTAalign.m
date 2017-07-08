function setBTAalign(source,~,data,val)
h = guidata(source);

if(val==0)
    set(h.toggle.start,'Value',1);
    set(h.toggle.end,'Value',0);
else
    set(h.toggle.start,'Value',0);
    set(h.toggle.end,'Value',1);
end

updateBTA(source,[],data);