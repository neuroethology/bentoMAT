function [movies,feat,annot,front] = makePythonStructs(gui,vals,doAnnot)

for i=1:size(vals,1)
    data    = gui.allData(vals(i,1)).(['session' num2str(vals(i,2))])(vals(i,3));

    % get movie filename
    if(gui.enabled.movie(1))
        ind         = find(~cellfun(@isempty,strfind(data.io.movie.fid,'Top')),1);
        ind2        = find(~cellfun(@isempty,strfind(data.io.movie.fid,'Front')),1);
        movies{1,i}  = data.io.movie.fid(ind);
    else
        ind         = 1;
        ind2        = inf;
        movies{1,i} = '';
    end

    % get features filename
    feat{1,i}       = data.io.feat.fid{ind};

    % get annotations filename
    if(doAnnot)
        annot{1,i}  = data.io.annot.fid{ind};
    else
        annot{1,i}  = '';
    end

    % get front-features filename
    if(length(data.io.feat.fid)>=ind2)
        front{1,i}  = data.io.feat.fid{ind2};
    else
        front{1,i}  = '';
    end
end

movies  = py.list(movies);
feat    = py.list(feat);
annot   = py.list(annot);
front   = py.list(front);