function pickMARSmodel(source,~)

[fileName,pathName,filterIndex] = uigetfile('');

if(~filterIndex)
    return;
end

h = guidata(source);
h.pth.String = [pathName fileName];