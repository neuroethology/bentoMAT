function cmap = loadPreferredCmap()

formatSpec = '%s %.3f %.3f %.3f';
fid = fopen([fileparts(mfilename('fullpath')) '\color_profiles.txt']);
M    = textscan(fid,formatSpec);

for i = 1:length(M{1})
    cmap.(M{1}{i}) = [M{2}(i) M{3}(i) M{4}(i)];
end
fclose(fid);