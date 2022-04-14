function [feats,names] = MARS_features(data)

if(isfield(data,'data_smooth'))
    feats = double(data.data_smooth);
else
    feats = double(data.data);
end
names = data.features;