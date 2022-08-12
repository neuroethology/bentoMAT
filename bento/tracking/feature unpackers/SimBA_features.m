function [feats,names] = SimBA_features(data)

feats = permute(data.data,[3,2,1]);
names = data.ids;