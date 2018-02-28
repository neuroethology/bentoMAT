function [cmap,hotkeys] = loadPreferredCmap()

formatSpec = '%s %s %.3f %.3f %.3f';
fid     = fopen([fileparts(mfilename('fullpath')) filesep 'color_profiles.txt']);
M       = textscan(fid,formatSpec);

cmap    = struct();
hotkeys = struct();
for i = 1:length(M{1})
    cmap.(M{2}{i})      = [M{3}(i) M{4}(i) M{5}(i)];
    hotkeys.(M{2}{i})   = M{1}{i};
end
fclose(fid);