function changeTimeUnits(source,~)
gui = guidata(source);

textbox = gui.ctrl.slider.text;
currentStr = textbox.String;

toFrames=0;
if(~isempty(strfind(currentStr,':')))
    toFrames = 1;
end

if(toFrames)
    frNum = round(getTime(currentStr)*gui.data.annoFR);
    textbox.String = num2str(frNum);
    textbox.Tag = 'frameBox';
    gui.ctrl.slider.units.TooltipString = 'Switch to time';
else
    time = makeTime(str2num(currentStr)/gui.data.annoFR);
    textbox.String = time;
    textbox.Tag = 'timeBox';
    gui.ctrl.slider.units.TooltipString = 'Switch to frame # (behavior video)';
end