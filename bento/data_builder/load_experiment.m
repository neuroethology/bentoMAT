function mouse = load_experiment(filename,skipvideos)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


if(isempty(filename))
    [filename pth] = uigetfile('*.xls;*.xlsx');
    filename = [pth filename];
else
    pth = fileparts(filename);
end

[~,~,raw] = xlsread(filename,'Sheet1');
if(isempty(raw{1,1})|isnan(raw{1,1}))
    raw{1,1} = pth; %blank path means read from the directory the sheet is in
end
if(~exist('skipvideos','var'))
    skipvideos = 0;
end
mouse = unpackExperiment(raw,skipvideos);