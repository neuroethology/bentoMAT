function updateBTA(source,~,data)
h = guidata(source);

if(strcmpi(source.Tag,'checkbox'))
    color = permute(source.CData(2,5,:),[1 3 2]);
    set(source,'CData',getButtonImage(color,source.Value));
end

if(h.isActive)
    computeBTA(source,[],data);
end