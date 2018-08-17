function setMovieBrightness(source)

gui         = guidata(source);

sc = gui.movie.sc;

prompt = {'Brightness:'};
dlg_title = 'Adjust movie brightness';
num_lines = 1;
defaultans = {num2str(sc)};

vals = inputdlg(prompt,dlg_title,num_lines,defaultans);

err=0;
if(~isempty(str2num(vals{1})))
    gui.movie.sc = str2num(vals{1});
else
    err=1;
end

if(err)
    errordlg('Non-numeric value entered');
end

guidata(source,gui);
updatePlot(source,[]);