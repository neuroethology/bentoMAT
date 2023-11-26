function [features, names] = generic_timeseries_features(args)

f = fieldnames(args);
if length(f)>1
	disp('not sure which variables to unpack, features will not be loaded.');
	features = [];
	names = '';
	return
end

num_feats = min(size(args.(f{:})));

if size(args.(f{:}),2)==num_feats
	features = permute(double(args.(f{:})),[3,1,2]);
else
	features = permute(double(args.(f{:})'),[3,1,2]);
end

names = strcat([f{:} '-'], num2str((1:num_feats)'));