% Call bento.m to initialize or restart Bento
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt

addpath(genpath(fileparts(mfilename('fullpath')))); %add all folders in the same directory as bento.m
if(~exist('quitloop','var') || ~exist('gui','var') || ~isstruct(gui) || ~isfield(gui,'h0') || ~isvalid(gui.h0))
    fclose all;
    construct_gui();
elseif(exist('gui','var') && isstruct(gui) && isfield(gui,'h0') && isvalid(gui.h0))
    ans = questdlg('Keep data currently in Bento?','','Yes');
    switch ans
        case 'Yes'
            figure(gui.h0);
        case 'No'
            fclose all;
            construct_gui();
        case 'Cancel'
            return;
    end
end
quitloop = 0;


while(~quitloop)
    gui = guidata(gui.h0);
    if(any(gui.Action))
        test = toc(gui.ctrl.slider.timer);
        if(test>0.15)
            if(~isempty(strfind(gui.Action,'drag')))
                hSlider = setSliderVal(gui.h0);
            else
                hSlider = incSliderVal(gui.h0);
            end
            updateSlider(gui.h0,hSlider);
            dummy.Source.Tag = 'slider';
            updatePlot(gui.h0,dummy);
        end
    end
    quitloop = gui.quitbutton;
    drawnow;
end
set(gui.h0,'CloseRequestFcn','closereq');
close(gui.h0);
