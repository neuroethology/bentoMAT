function makeButton(parent,string)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



axes('parent',parent,'position',[0 0 1 1]);
c = 0.1;

v = [0 c; c 0; 1-c 0; 1 c; 1 .5; 0 .5];
f = 1:length(v);
cmap = [.8*ones(4,3);
        .87*ones(2,3)];
patch('faces',f,'vertices',v,'FaceVertexCData',cmap,'facecolor','interp','edgecolor','none','hittest','off');

v = [c 0; 1-c 0; 1 c; 1 1-c; 1-c 1; c 1; 0 1-c; 0 c];
f = 1:length(v);
patch('faces',f,'vertices',v,'facecolor','none','edgecolor','w','hittest','off');

text(.25,.55,string,'hittest','off');

axis tight;axis off;