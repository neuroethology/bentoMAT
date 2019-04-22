function removeRow(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



gui = guidata(source);
dat = get(gui.t,'data');
if(size(dat,1)<=1)
    return;
end
inds = gui.t.UserData(:,1);
dat(inds,:) = [];

set(gui.t,'data',dat);
guidata(source,gui);