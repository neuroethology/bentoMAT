function [feats,names] = MARS_top_features(data)

feats = data.data_smooth;
names = data.features;