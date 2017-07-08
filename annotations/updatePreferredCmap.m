function updatePreferredCmap(cmap)

fname = [fileparts(mfilename('fullpath')) '\color_profiles.txt']; %gets the full path to this file
fid = fopen(fname,'w');

M = {};
f = fieldnames(cmap);
formatSpec = '%s %.3f %.3f %.3f\n';

for i = 1:length(f)
    M{1} = f{i};
    M{2} = cmap.(f{i})(1);
    M{3} = cmap.(f{i})(2);
    M{4} = cmap.(f{i})(3);
    fprintf(fid,formatSpec,M{:});
end
fclose(fid);