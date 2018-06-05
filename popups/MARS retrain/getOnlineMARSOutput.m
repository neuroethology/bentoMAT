function annot = getOnlineMARSOutput(fid)

fid = strtrim(strip(strip(fid,'left','.'),'left',filesep));
[~,str] = fileparts(fid);
str = strrep(str,'-','_');

[annot,~]   = loadAnnotFile(fid);
annot       = annot.Ch1; %MARS predictions always go to channel 1 (at least for now......)
annot       = orderfields(annot);