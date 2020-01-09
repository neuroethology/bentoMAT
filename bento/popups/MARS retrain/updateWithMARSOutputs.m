function gui = updateWithMARSOutputs(gui,vals,model_type)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



% add the classifier outputs back as an annotation channel
data    = gui.allData(vals(1)).(['session' num2str(vals(2))])(vals(3));

pth     = fileparts(data.io.feat.fid{1});
[~,mID] = fileparts(pth);
fid     = [pth '\' mID '_actions_pred_' model_type '.txt'];

data.annot.MARS_output       = getOnlineMARSOutput(fid);
if(~any(strcmpi(data.io.annot.fid,fid)))
    data.io.annot.fid{end+1}     = fid;
    data.io.annot.fidSave{end+1} = strrep(fid,'.txt','.annot');
end


% add the classifier probabilities in as (possibly new) features, and
% display those feature automatically
%
% TODO: update this to support multiple feature sets per experiment...
% somehow?
fid     = [pth '\' mID '_classifier_probabilities_mlp.mat'];
probs   = load(fid);
for i = 1:size(probs.behaviors,1)
    behLabel = [model_type '_' probs.behaviors(i,:)];
    ind = find(~cellfun(@isempty,strfind(cellstr(data.tracking.args{1}.features),behLabel)),1);
    if(isempty(ind))
        data.tracking.args{1}.features = [pad(behLabel,size(data.tracking.args{1}.features,2)); ...
                                       data.tracking.args.features];
        data.tracking.args{1}.data_smooth = cat(3,flipud(permute(probs.probabilities,[3 2 1])),data.tracking.args{1}.data_smooth);
    else
        data.tracking.args{1}.data_smooth(:,:,ind) = flipud(permute(probs.probabilities,[3 2 1]));
    end
end

gui.allData(vals(1)).(['session' num2str(vals(2))])(vals(3)) = data;