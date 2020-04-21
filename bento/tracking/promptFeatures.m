function [feats,names] = promptFeatures(data)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



f = fieldnames(data.tracking.args{1});
f(strcmpi(f,'features'))=[];

[selection,flag] = listdlg('ListString',f,'SelectionMode','single',...
                            'PromptString','Which variable contains features?');
if(flag)
    feats       = data.tracking.args{1}.(selection);
    if(length(size(data.tracking.args{1}.(selection)))==2)
        feats   = permute(feats,[3 1 2]);
    end
else
    feats = [];
end

[selection,flag] = listdlg('ListString',f,'SelectionMode','single',...
                            'PromptString','Which variable contains feature names?');
if(flag)
    names       = data.tracking.args{1}.(selection);
    if(length(size(data.tracking.args{1}.(selection)))==2)
        names   = permute(names,[3 1 2]);
    end
else
    names = [];
end