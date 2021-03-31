function [data,featnames] = jellyfish_neurons_features(data, args)


data.rast = args.F0;
data.CaTime = (1:args.tMax)/data.CaFR;
data.trackTime = (1:args.tMax)/data.CaFR;
data.annoTime = (1:args.tMax)/data.CaFR;
data.annoFR = data.CaFR;

featnames = [];
data.tracking.args{1}.features = featnames;
data.tracking.features = [];