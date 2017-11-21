function output = json_read_slow(fid)

dat = fileread(fid);
txt = json_decode(dat);

keyboard
keypoints = zeros(length(txt.keypoints),2,2,7);
scores    = zeros(length(txt.keypoints),2,7);
for i = 1:length(txt.keypoints)
    m1=txt.keypoints{i}{1};
    m2=txt.keypoints{i}{2};
    keypoints(i,1,:,:) = [[m1{1}{:}]; [m1{2}{:}]];
    keypoints(i,2,:,:) = [[m2{1}{:}]; [m2{2}{:}]];
    
    s = txt.scores{i};
    scores(i,:,:) = [[s{1}{:}]; [s{2}{:}]];
end

output.keypoints = keypoints;
output.scores    = scores;