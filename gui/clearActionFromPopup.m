function clearActionFromPopup(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



h = guidata(source);
if(~isempty(h.Action))
    h.Action=[];
    clearAction(h.guifig,[]);
end