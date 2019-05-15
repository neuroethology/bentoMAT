function [feats,names] = promptFeatures(data)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



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

[selection,flag] = listdlg('ListString',f,'SelectionMode','single',...
                            'PromptString','Which variable contains feature names?');
if(flag)
    names       = data.args.(selection);
    if(length(size(data.args.(selection)))==2)
        names   = permute(names,[3 1 2]);
    end
else
    names = [];
end