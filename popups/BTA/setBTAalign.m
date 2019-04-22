function setBTAalign(source,~,data,val)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


h = guidata(source);

if(val==0)
    set(h.toggle.start,'Value',1);
    set(h.toggle.end,'Value',0);
else
    set(h.toggle.start,'Value',0);
    set(h.toggle.end,'Value',1);
end

updateBTA(source,[],data);