function updatePreferredCmap(cmap,hotkeys)

fname       = [fileparts(mfilename('fullpath')) '\color_profiles.txt']; %gets the full path to this file
if(~exist(fname,2))
    pth0    = [strrep(fileparts(mfilename('fullpath')),'annotations','startup'), filesep 'default_color_profiles.txt'];
    copyfile(pth0, fname);
end

fid     = fopen(fname,'w');
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