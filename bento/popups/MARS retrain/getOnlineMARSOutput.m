function annot = getOnlineMARSOutput(fid)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



fid = strtrim(strip(strip(fid,'left','.'),'left',filesep));

[annot,~]   = loadAnnotFile(fid);
annot       = annot.Ch1; %MARS predictions always go to channel 1 (at least for now......)
annot       = orderfields(annot);