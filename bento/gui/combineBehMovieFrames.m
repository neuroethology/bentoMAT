function mov = combineBehMovieFrames(gui,movies,time)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt




% add tracking data if included
if(all(gui.enabled.tracker))
    movies = applyTracking(gui,movies,time);
end

% convert to 3-channel color
for col = 1:size(movies,1)
    dims    = cellfun(@size,movies(col,:),'uniformoutput',false);
    if(any(cellfun(@length,dims)==3) && ~all(cellfun(@length,dims)==3)) %fix for different color settings
        for ind = find(cellfun(@length,dims)~=3)
            movies{col,ind} = repmat(movies{col,ind},[1 1 3]);
        end
    end
end

% pad each column to common width
for col = 1:size(movies,1)
    dims    = cellfun(@size,movies(col,:),'uniformoutput',false);
    dims    = cat(1,dims{:});
    [w,ind] = max(dims(:,2));
    for i = setdiff(1:size(dims,1),ind)
        pad = (w - dims(i,2))/2;
        movies{col,i} = padarray(movies{col,i},[0 pad],'both');
    end
    mov{col} = cat(1,movies{col,:});
end

% pad all columns to same height
dims = cellfun(@size,mov,'uniformoutput',false);
dims = cat(1,dims{:});
[w,ind] = max(dims(:,1));
for i = setdiff(1:size(dims,1),ind)
    pad     = (w - dims(i,1))/2;
    mov{i}  = padarray(mov{i},[pad 0],'both');
end
mov = cat(2,mov{:});
