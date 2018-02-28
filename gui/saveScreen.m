function saveScreen(source,movieOnly)

gui = guidata(source);

ftypes = {'*.eps;', 'EPS file (*.eps)';...
 '*.jpg', 'JPEG image (*.jpg)';...
 '*.bmp', 'Bitmap file (*.bmp)';...
 '*.fig','MATLAB Figure (*.fig)';...
 '*.png','Portable Network Graphics file (*.png)';...
 '*.tif','TIFF image (*.tif)';...
 '*.*',  'All Files (*.*)'};
if(movieOnly)
    ftypes([1 4],:)=[];
end

[FileName,PathName] = uiputfile(ftypes,'Save As');
saveDataName = fullfile(PathName,FileName);

if(movieOnly)
    I = gui.movie.img.CData;
    imwrite(I,saveDataName);
else
    if(strcmpi(saveDataName(end-2:end),'eps'))
            saveas(gui.h0, saveDataName,'epsc');
    else
        saveas(gui.h0, saveDataName);
    end
end