function openHelpMenu(source)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



str = {'---Playback Hotkeys---',''};
str = [str;{[char(8592) ' ' char(8594)],'Step +/- one frame'}];
str = [str; {'[Spacebar]','Start/stop playback'}];
str = [str; {[char(8593) ' ' char(8595)],'inc/dec play speed'}];
str = [str; {'[Shift]','(held down while playing) only'}];
str = [str; {'','show episodes of current bhvr'}];
str = [str; {'',''}];

str = [str; {'---Navigating annotations---',''}];
str = [str; {'t/g','Cycle current behavior'}];
str = [str; {'PgDown','Next bout (any bhvr)'}];
str = [str; {'PgUp','Prev bout (any bhvr)'}];
str = [str; {'[Shift]+PgDown','Next bout (current bhvr)'}];
str = [str; {'[Shift]+PgUp','Prev bout (current bhvr)'}];
str = [str; {'',''}];

str = [str; {'---Modifying annotations---',''}];
str = [str; {'a','Toggle annot (current bhvr)'}];
str = [str; {'e','Toggle erase (current bhvr)'}];
str = [str; {'[Shift]+e','Toggle erase (all bhvrs)'}];
str = [str; {'[Ctrl]+z','Undo'}];
str = [str; {'s','Save changes to annotations'}];
str = [str; {'',''}];
str = [str; {'---Other---',''}];
str = [str; {'h','Open this menu'}];
str = [str; {'v','Toggle data visibility'}];
str = [str; {'n','Toggle annot. visibility'}];
str = [str; {'',''}];

str(:,1) = pad(str(:,1),10,'both');
str = pad(str,15);
temp=str;str={};
for i=1:length(temp)
    str = [str;[temp{i,:}]];
end

h=msgbox(str,'Annotation Hotkeys');
ah = get( h, 'CurrentAxes' );
ch = get( ah, 'Children' );
ch.FontName = 'Courier';
ch.FontSize = 12;
h.Position = [h.Position(1:2)-(ch.Extent(3:4).*[1.05 1.15]-h.Position(3:4))/2 ch.Extent(3:4).*[1.05 1.15]];
h.Children(1).Position(1) = h.Position(3)/2 - h.Children(1).Position(3)/2;