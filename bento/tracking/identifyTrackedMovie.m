function [rr,cc] = identifyTrackedMovie(data)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



rr=1;cc=1;
if(~isfield(data.io.movie,'fid'))
return;
end
if(length(data.io.movie.fid)>1)
    if(~isempty(strfind(data.tracking.fun,'top')))
        [rr,cc] = find(~cellfun(@isempty,strfind(data.io.movie.fid,'Top')));
    elseif(~isempty(strfind(data.tracking.fun,'front')))
        [rr,cc] = find(~cellfun(@isempty,strfind(data.io.movie.fid,'Fro')));
    end
end