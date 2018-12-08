function mouse = load_experiment(filename,skipvideos)

if(isempty(filename))
    [filename pth] = uigetfile('*.xls;*.xlsx');
    filename = [pth filename];
end

[~,~,raw] = xlsread(filename,'Sheet1');
if(isempty(raw{1,1}))
    raw{1,1} = pth; %blank path means read from the directory the sheet is in
end
if(~exist('skipvideos','var'))
    skipvideos = 0;
end
mouse = unpackExperiment(raw,skipvideos);