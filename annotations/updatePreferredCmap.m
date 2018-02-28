function updatePreferredCmap(cmap,hotkeys)

fname = [fileparts(mfilename('fullpath')) '\color_profiles.txt']; %gets the full path to this file
fid = fopen(fname,'w');
formatSpec = '%s %s %.3f %.3f %.3f\n';

M       = {};
f       = fieldnames(cmap);

for i = 1:length(f)
    M{1} = hotkeys.(f{i});
    M{2} = f{i};
    M{3} = cmap.(f{i})(1);
    M{4} = cmap.(f{i})(2);
    M{5} = cmap.(f{i})(3);
    fprintf(fid,formatSpec,M{:});
end
fclose(fid);