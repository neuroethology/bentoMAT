function patchify(annot,yran,dt,cmap)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



bhvrs = fieldnames(annot);
correctedLabels = findEquivalentLabels(bhvrs);
for f = 1:length(bhvrs)
    if(isempty(annot.(bhvrs{f}))|strcmpi(bhvrs{f},'other'))
        continue;
    end
    
    t_begin = annot.(bhvrs{f})(:,1);
    t_end = annot.(bhvrs{f})(:,2);

    for k = 1:length(t_begin)
        tb = t_begin(k);
        te = t_end(k);
        patch([tb te te tb]*dt,[yran(1) yran(1) yran(2) yran(2)],...
            cmap.(correctedLabels{f}),'EdgeColor','none');
    end
end