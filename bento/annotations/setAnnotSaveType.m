function setAnnotSaveType(source)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



gui=guidata(source);
answer = questdlg('Units for saved annotations:', ...
	'Set annotation save format', ...
	'Frames','Time (seconds)','Frames');

switch answer
    case 'Frames'
        gui.annot.saveAsTime = false;
    otherwise
        gui.annot.saveAsTime = true;
end
guidata(gui.h0,gui);