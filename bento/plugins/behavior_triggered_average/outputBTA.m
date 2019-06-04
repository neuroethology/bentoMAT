function outputBTA(source,~,gui)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt

h = guidata(source);
unitList = h.unit.String;
hit = h.unit.Value;
[selection,ok] = listdlg('ListString',unitList,'InitialValue',hit,...
                    'PromptString','Select variables to save');
if(~ok)
    return;
end
var = inputdlg({'Assign variable name:','Assign time axis name:'},...
               'Saving behavior-triggered average...',1,...
               {'BTA','BTA_time'});

BTA = struct();
for i = selection
    h.unit.Value = i;
    [BTA.(regexprep(h.unit.String{i},' *','_')),time] = computeBTA(source,[],gui);
end

for i=1:length(var)
    var{i}(ismember(var{i},'?!@#$%^&*()+=-<>,./\[]}{')) = [];
    if(isempty(var{i}))
        msgbox(['Invalid name(s), variable ' strrep(num2str(i:2),'  ',', ') ' not saved.']);
        return;
    end
    if(isnumeric(var{i}(1)))
        var{i} = ['var_' var{i}];
    end
    if(i==1)
        assignin('base',var{1},BTA);
    else
        assignin('base',var{2},time);
    end
end
msgbox('Traces saved.');