function clearActionFromPopup(source,~)

h = guidata(source);
if(~isempty(h.Action))
    h.Action=[];
    clearAction(h.guifig,[]);
end