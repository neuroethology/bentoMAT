function [rr,cc] = identifyTrackedMovie(data)

rr=1;cc=1;
if(length(data.io.movie.fid)>1)
    if(contains(data.tracking.fun,'top'))
        [rr,cc] = find(~cellfun(@isempty,strfind(data.io.movie.fid,'Top')));
    elseif(contains(data.tracking.fun,'front'))
        [rr,cc] = find(~cellfun(@isempty,strfind(data.io.movie.fid,'Fro')));
    end
end