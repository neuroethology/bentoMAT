function io = unpackIOData(fields)

io = [];
for f = 1:length(fields)
    clear temp;
    for d = fieldnames(fields(f).data)'
        if(strcmpi(fields(f).data.(d{:}).Style,'edit'))
            temp.(d{:}) = fields(f).data.(d{:}).String;
        else
            if(iscell(fields(f).data.(d{:}).String))
                temp.(d{:}) = fields(f).data.(d{:}).String{fields(f).data.(d{:}).Value};
            else
                temp.(d{:}) = fields(f).data.(d{:}).String;
            end
        end
    end
    if(isfield(io,fields(f).type))
        io.(fields(f).type)(end+1) = temp;
    else
        io.(fields(f).type) = temp;
    end
end