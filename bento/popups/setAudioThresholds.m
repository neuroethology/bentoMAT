function setAudioThresholds(source)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



gui         = guidata(source);

thrLo = gui.audio.thrLo;
thrHi = gui.audio.thrHi;
freqLo = gui.audio.freqLo;
freqHi = gui.audio.freqHi;

prompt = {'Lower intensity bound:','Upper intensity bound:','Lower frequency bound:','Upper frequency bound:'};
dlg_title = 'Set cutoffs';
num_lines = 1;
defaultans = {num2str(thrLo),num2str(thrHi),num2str(freqLo),num2str(freqHi)};

vals = inputdlg(prompt,dlg_title,num_lines,defaultans);

err=0;
if(~isempty(str2num(vals{1})))
    gui.audio.thrLo = str2num(vals{1});
else
    err=1;
end
if(~isempty(str2num(vals{2})))
    gui.audio.thrHi = str2num(vals{2});
else
    err=1;
end
if(~isempty(str2num(vals{3})))
    gui.audio.freqLo = str2num(vals{3});
else
    err=1;
end
if(~isempty(str2num(vals{4})))
    gui.audio.freqHi = str2num(vals{4});
else
    err=1;
end

if(err)
    errordlg('Non-numeric value entered for one or more fields');
end

guidata(source,gui);
updatePlot(source,[]);