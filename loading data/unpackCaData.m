function [rast,time] = unpackCaData(pth)

[~,fname,ext] = fileparts(pth);
disp(['Loading Ca file ' fname '...']);

% add cases to this switch statement for other data types~?
switch ext
    case '.csv'
        temp = csvread(pth);
        time = temp(:,1)';
        rast = temp(:,5)';
        % get rid of artifacts
        rast((1:100))    = 0;
        rast(end-19:end) = 0;
        
    case {'.xls','.xlsx'}
        % Prabhat's fiberphotometry data
    case '.mat'
        temp = load(pth);
        if(isfield(temp,'neuron'))    %NMF data
            rast = temp.neuron.C_raw;
        else                          %Ryan's data
            temp = load(pth);
            f    = fieldnames(temp);
            if(length(f)==1)
                rast = temp.(f{1});
            else
                disp(['unsure which variable to read in ' fname]);
            end
        end
        time = [];
end

disp('done');