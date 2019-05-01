function [rast,time] = unpackCaData(pth)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



[~,fname,ext] = fileparts(pth);
disp(['Loading Ca file ' fname '...']);

[rast,time]=deal([]);
% add cases to this switch statement for other data types~?
switch ext
    case '.csv'
        temp = csvread(pth);
        time = temp(:,1)';
        rast = temp(:,5)';
        % get rid of artifacts
        rast((1:500))    = nan;
        rast(end-119:end) = nan;

    case '.mat'
        temp = load(pth);
        f    = fieldnames(temp);
        if(isfield(temp,'neuron'))    %also CNMFE data data
            rast = temp.neuron.C_raw;
        elseif(length(f)==1)
            if(isstruct(temp.(f{1})) && isfield(temp.(f{1}),'C_raw')) %CNMFE data
                rast = temp.(f{1}).C_raw;
            else
                rast = temp.(f{1}); %assume it's a matrix of traces
            end
        else
            disp(['unsure which variable to read in ' fname]);
            rast = [];
        end
        time = [];
    case '.flr'
        % Yatang Ca traces
        datapara = input_lyt(pth);
        rast = datapara.data';
        time=[];
end

disp('done');