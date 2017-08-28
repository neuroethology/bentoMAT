function setAudioThresholds(source,~)

gui         = guidata(source);

thrLo = gui.audio.thrLo;
thrHi = gui.audio.thrHi;

prompt = {'Lower bound:','Upper bound:'};
dlg_title = 'Set intensity cutoffs for spectrogram';
num_lines = 1;
defaultans = {num2str(thrLo),num2str(thrHi)};

vals = inputdlg(prompt,dlg_title,num_lines,defaultans);

if(~isempty(str2num(vals{1})))
    gui.audio.thrLo = str2num(vals{1});
else
    errordlg('Non-numeric value entered for lower bound');
end
if(~isempty(str2num(vals{2})))
    gui.audio.thrHi = str2num(vals{2});
else
    errordlg('Non-numeric value entered for upper bound');
end

guidata(source,gui);
updatePlot(source,[]);