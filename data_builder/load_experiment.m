function mouse = load_experiment(filename)

[~,~,raw] = xlsread(filename,'Sheet1');
mouse = unpackExperiment(raw);