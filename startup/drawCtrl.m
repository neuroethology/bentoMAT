function gui = drawCtrl(gui)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



if(isfield(gui,'ctrl'))
    delete(gui.ctrl.panel);
end
gui.ctrl = [];
gui.ctrl.panel  = uipanel('position',[0 0 1 1],'bordertype','none');

scale = ones(size(gui.config.ctrl));
for i = 1:length(gui.config.ctrl)
    if(isfield(gui.config.ctrlSc,gui.config.ctrl{i}))
        scale(i) = gui.config.ctrlSc.(gui.config.ctrl{i});
    end
end
nRows = sum(scale);
for i = 1:length(scale)
    str = ['draw' gui.config.ctrl{i} ...
           '(gui,' num2str(nRows-sum(scale(1:i))+1) ',' num2str(scale(i)) ',nRows)'];
    gui.ctrl.(gui.config.ctrl{i}) = eval(str);
end