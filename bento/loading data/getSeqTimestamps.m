function ts = getSeqTimestamps(pth,reader)
% a helper function that creates a _TS.mat file of seq movie timestamps,
% because reading from the seq file every time is weirdly slow
% 
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


tsFile = strrep(pth,'.seq','_TS.mat');
if(exist(tsFile,'file'))
    load(tsFile,'ts');
else
    ts = reader.getts();
    save(tsFile,'ts');
end