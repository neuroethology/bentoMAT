function strs = getDatatypesList()
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



mydir = mfilename('fullpath');
mydir(max(strfind(mydir,'\')):end)=[];
pth = [mydir '\data_formats\'];
datatypes = dir(pth);
datatypes = {datatypes(cellfun(@isempty,strfind({datatypes.name},'.'))).name};
strs = {' '};
for i = 1:length(datatypes)
    strs{end+1} = ['--- ' strrep(datatypes{i},'_',' ') ' ---'];
    list = dir([pth datatypes{i} '\*.m']);
    list = {list.name};
    if(isempty(list))
        continue;
    end
    strs(end+(1:length(list))) = strrep(strrep(list,'_',' '),'.m','');
end