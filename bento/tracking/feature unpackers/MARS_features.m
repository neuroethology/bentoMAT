function [feats,names] = MARS_features(data)

feats = data.data_smooth;
names = data.features;