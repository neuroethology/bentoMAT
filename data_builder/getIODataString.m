function str = getIODataString(io)

str = {};
for f = fieldnames(io)'
    for i = 1:length(io.(f{:}))
        str{end+1} = sprintf('%s',f{:});
        empty = true;
        for d = fieldnames(io.(f{:})(i))'
            if(~isempty(strtrim(io.(f{:})(i).(d{:})))&~strcmpi(io.(f{:})(i).(d{:}),'HH:MM:SS.SSS'))
                try
                str{end+1} = sprintf('  %s:\t%s',d{:},io.(f{:})(i).(d{:}));
                catch
                    keyboard
                end
                empty = false;
            end
        end
        if(empty)
            str{end+1} = '  No data';
        end
        str{end+1} = '';
    end
end