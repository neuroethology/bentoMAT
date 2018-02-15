function setBentoPth(source,~,parent,doPrompt)

exptGui = guidata(source);
if(doPrompt)
    pth = uigetdir(exptGui.root.String,'Select Bento parent directory');
else
    pth = exptGui.root.String;
end

exptGui.root.String = pth;
parent.pth          = pth;
% assignin('base','gui',parent);
assignin('caller','gui',parent);
guidata(parent.h0,parent);