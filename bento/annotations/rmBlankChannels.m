function annot = rmBlankChannels(annot)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



for ch = fieldnames(annot)'
    temp = annot.(ch{:});
    if(isfield(temp,'other'))
        temp = rmfield(temp,'other');
    end
    if(all(structfun(@isempty,temp)))
        annot = rmfield(annot,ch);
    end
end