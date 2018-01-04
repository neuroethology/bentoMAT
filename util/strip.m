function str = strip(str,dir,char)

if(strcmpi(dir,'right'))
    str = fliplr(str);
end
    
inds = strfind(str,char);
while(~isempty(inds))
    if(inds(1)==1)
        str(1)=[];
        inds=inds-1;
        inds(1)=[];
    end
end

if(strcmpi(dir,'right'))
    str = fliplr(str);
end
