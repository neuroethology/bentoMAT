function str = strip(str,dir,char)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt

if(~exist('char','var'))
    char = ' ';
end
if(~exist('dir','var'))
    dir = 'left';
end

if(strcmpi(dir,'right'))
    str = fliplr(str);
end
    
inds = strfind(str,char);
while(~isempty(inds))
    if(inds(1)==1)
        str(1)=[];
        inds=inds-1;
        inds(1)=[];
    else
        break;
    end
end

if(strcmpi(dir,'right'))
    str = fliplr(str);
end
