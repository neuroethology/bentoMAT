function mouse = load_experiment(filename,skipvideos)

if(isempty(filename))
    [filename pth] = uigetfile('*.xls;*.xlsx');
    filename = [pth filename];
end

[~,~,raw] = xlsread(filename,'Sheet1');
if(~exist('skipvideos','var'))
    skipvideos = 0;
end
mouse = unpackExperiment(raw,skipvideos);