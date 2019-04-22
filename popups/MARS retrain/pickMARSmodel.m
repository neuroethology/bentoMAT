function pickMARSmodel(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



[fileName,pathName,filterIndex] = uigetfile('');

if(~filterIndex)
    return;
end

h = guidata(source);
h.pth.String = [pathName fileName];