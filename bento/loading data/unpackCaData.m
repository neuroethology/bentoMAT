function [rast,time,spikes,ROIs] = unpackCaData(pth)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



[~,fname,ext] = fileparts(pth);
disp(['Loading Ca file ' fname '...']);

[rast,time,ROIs]=deal([]);
% add cases to this switch statement for other data types~?
switch ext
    case '.csv'
%         fid = fopen(pth);
%         temp = textscan(fid,'%f,%f,[%d %d],%d,%f');
%         neurons = unique(temp{1});
%         rast = [];
%         for i = neurons'
%             rast(i+1,:) = temp{6}(temp{1}==i);
%             rast(i+1,temp{5}(temp{1}==i)==0)=nan;
%         end
        temp = csvread(pth);
        time = temp(:,1)';
        rast = temp(:,5)';
        % get rid of artifacts
        rast((1:500))    = nan;
        rast(end-119:end) = nan;
        spikes=[];

    case '.mat'
        temp = load(pth);
        f    = fieldnames(temp);
        if(length(f)==1 || isfield(temp,'neuron'))
            if(length(f)==1)
                use = f{1};
            else
                use = 'neuron';
            end
            S2d = strcmpi(class(temp.(use)),'Sources2D');
            if(S2d || (isstruct(temp.(use)) && isfield(temp.(use),'C_raw'))) %CNMFE data
                rast    = temp.(use).C_raw;
                if(S2d || (isfield(temp.(use),'options') && isfield(temp.(use),'A')))
                    d1      = temp.(use).options.d1;
                    d2      = temp.(use).options.d2;
                    ROIs = zeros(size(rast,1),d1,d2);
                    for i = 1:size(rast,1)
                        ROIs(i,:,:) = reshape(temp.(use).A(:,i),d1,d2);
                    end
                end
                if(S2d || isfield(temp.(use),'S'))
                    spikes  = temp.(use).S;
                else
                    spikes = [];
                end
            else
                rast = temp.(use); %assume it's a matrix of traces
                spikes = [];
            end
            time = [];
        elseif(length(f)==2 && any(strcmpi(f,'time')))
            rast = temp.(f{~strcmpi(f,'time')});
            spikes = [];
            time = temp.(f{strcpmi(f,'time')});
        else
            disp(['unsure which variable to read in ' fname]);
            rast = []; spikes=[];
        end
        time = [];
    case '.flr'
        % Yatang Ca traces
        datapara = input_lyt(pth);
        rast = datapara.data';
        time=[];
        spikes=[];
end

disp('done');