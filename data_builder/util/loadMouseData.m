function [mouse,enabled] = loadMouseData(ioStruct)

% enabled.movie    = raw{1,11};
% enabled.annot    = any(~cellfun(@isempty,data(:,match.Annotation_file)));
% enabled.traces   = any(~cellfun(@isempty,data(:,match.Calcium_imaging_file)));
% enabled.tracker  = any(~cellfun(@isempty,data(:,match.Tracking)));
% enabled.features  = 0;%any(~cellfun(@isempty,data(:,match.Tracking)));
% enabled.audio    = any(~cellfun(@isempty,data(:,match.Audio_file)));


mouse = struct();
previous = [];
for m = 1:length(ioStruct)
    for sess = fieldnames(ioStruct(m))'
        for tr = 1:length(ioStruct(m).(sess{:}))
            
            temp         = ioStruct(m).(sess{:})(tr);
            temp.enabled = [];
            
            for f = fieldnames(temp.io)' %loop over data types
                for i = 1:length(temp.io.(f{:})) %loop over entries of a given data type
                    [temp.(f{:})(i),temp.enabled] = loadIOData(temp.io.(f{:})(i),previous);
                end
            end
            
            temp     = buildSliderTime(temp);
            mouse(m).(sess{:})(tr) = temp;
            previous = temp;
            
        end
    end
end