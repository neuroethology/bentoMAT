function feats = promptFeatures(data)

f = fieldnames(data.args);
f(strcmpi(f,'features'))=[];

[selection,flag] = listdlg('ListString',f,'SelectionMode','single',...
                            'PromptString','Which variable contains features?');

if(flag)
    feats       = data.args.(selection);
    if(length(size(data.args.(selection)))==2)
        feats   = permute(feats,[3 1 2]);
    end
else
    feats = [];
end