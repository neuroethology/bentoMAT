function setBentoPth(source,~,parent,doPrompt)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


exptGui = guidata(source);
if(doPrompt)
    pth = uigetdir(exptGui.root.String,'Select parent directory of your data');
    if(~pth) % no directory selected
        return;
    end
else
    pth = exptGui.root.String;
end

exptGui.root.String = pth; % sets path within the data builder
parent.pth          = pth; % saves the path in bento so it can be reused
guidata(parent.h0,parent);