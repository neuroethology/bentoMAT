function [movies,feat,annot,front,frame_start,frame_stop] = makePythonStructs(allData,vals,doAnnot,mask)

for i=1:size(vals,1)
    data    = allData(vals(i,1)).(['session' num2str(vals(i,2))])(vals(i,3));

    % get movie filename
    if(~isempty(data.io.movie) & ~isempty(fieldnames(data.io.movie)))
        ind         = find(~cellfun(@isempty,strfind(data.io.movie.fid,'Top')),1);
        ind2        = find(~cellfun(@isempty,strfind(data.io.movie.fid,'Front')),1);
        movies{1,i}  = data.io.movie.fid(ind);
    else
        ind         = 1;
        ind2        = inf;
        movies{1,i} = '';
    end

    % get features filename
    feat{1,i}       = data.io.feat.fid{1};

    % get annotations filename
    if(doAnnot)
        annot{1,i}  = data.io.annot.fid{1}; %assume it's the first linked file for now, ughh
    else
        annot{1,i}  = '';
    end

    % get front-features filename
    if(length(data.io.feat.fid)>1)
        front{1,i}  = data.io.feat.fid{2};
    else
        front{1,i}  = '';
    end
    
    % get start/stop frames if mask behaviors/channels were passed
    if(~isempty(mask) && ~isempty(mask.Ch))
        if(ischar(mask.Ch))
            start = data.annot.(mask.Ch).(mask.beh)(:,1);
            stop  = data.annot.(mask.Ch).(mask.beh)(:,2);
        else
            bouts=[];
            for ch=1:length(mask.Ch)
                for b = 1:length(mask.beh)
                    if(~isfield(data.annot.(mask.Ch{ch}),mask.beh{b})), continue; end
                    bouts = [bouts; data.annot.(mask.Ch{ch}).(mask.beh{b})];
                end
            end
            bouts = convertToBouts(convertToRast(bouts,bouts(end,2)+1));
            start = bouts(:,1); stop = bouts(:,2);
        end
        frame_start{i} = py.list(mat2cell(int32(start),ones(length(start),1))');
        frame_stop{i} = py.list(mat2cell(int32(stop),ones(length(stop),1))');
    else
        frame_start{i} = 0;
        frame_stop{i}  = 0;
    end
end

movies  = py.list(movies);
feat    = py.list(feat);
annot   = py.list(annot);
front   = py.list(front);
frame_start = py.list(frame_start);
frame_stop  = py.list(frame_stop);