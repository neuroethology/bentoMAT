function annot = rmBlankChannels(annot)

for ch = fieldnames(annot)'
    temp = annot.(ch{:});
    if(isfield(temp,'other'))
        temp = rmfield(temp,'other');
    end
    if(all(structfun(@isempty,temp)))
        annot = rmfield(annot,ch);
    end
end