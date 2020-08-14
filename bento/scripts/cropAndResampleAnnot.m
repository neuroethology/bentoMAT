function annot = cropAndResampleAnnot(annot,tRan,FRRatio)
% use this to re-index annotations to fall within the range specified in
% tRan (in frames). Returned struct will have same format/labels as input
% struct, but only keep frames between tRan(1) and tRan(2), with frames
% re-numbered such that tRan(1) = frame 1.

tmin = tRan(1);
tmax = tRan(2);

for f = fieldnames(annot)'
    for beh = fieldnames(annot.(f{:}))'
        if(isempty(annot.(f{:}).(beh{:}))), continue; end
        % resample at FRRatio
        annot.(f{:}).(beh{:}) = round(annot.(f{:}).(beh{:})*FRRatio);
        
        % then remove out-of-range annotations
        annot.(f{:}).(beh{:}) = max(annot.(f{:}).(beh{:}) - tmin + 1, 1);
        
        annot.(f{:}).(beh{:})(annot.(f{:}).(beh{:})(:,2)==1, :) = [];
        annot.(f{:}).(beh{:})(annot.(f{:}).(beh{:})(:,1)>=(tmax-tmin+1), :) = [];
        
        annot.(f{:}).(beh{:})(:,2) = min(annot.(f{:}).(beh{:})(:,2), (tmax-tmin+1));
    end
end