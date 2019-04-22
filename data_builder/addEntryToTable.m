function addEntryToTable(source,~)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt


h = guidata(source);

M{1} = h.expt.Mouse.String;
M{2} = h.expt.Sess.String;
M{3} = h.expt.Trial.String;
M{4} = h.expt.Stim.String;

for i = 1:length(h.fields)
    for f = fieldnames(h.fields(i).data)'
        if(~isempty(h.fields(i).data.(f{:}).String))
            
        end
    end
end