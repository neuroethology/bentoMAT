function mouse = load_experiment(filename)

if(isempty(filename))
    [filename pth] = uigetfile('*.xls;*.xlsx');
    filename = [pth filename];
end

[~,~,raw] = xlsread(filename,'Sheet1');
mouse = unpackExperiment(raw);