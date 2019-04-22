function datapara=input_lyt(fn)


fid=fopen(fn,'r','b');
file_info = dir(fn);
time_stamp = file_info.date;
time_precision_changed = datetime(2016,11,03,10,59,12,...
    'Format','dd-MMM-yyyy HH:mm:ss');
if time_stamp<time_precision_changed
    fileheader=fread(fid,100,'single','b' );
    data_trig = fread(fid,[1, inf],'single','b' );
else
    fileheader=fread(fid,100,'double','b' );
    data_trig = fread(fid,[1, inf],'double','b' );
end
    

num_rois = fileheader(1);
len_trial = length(data_trig)/(num_rois+1);
data = data_trig(1:num_rois*len_trial)';
trig = data_trig(num_rois*len_trial + 1:end)';
data = reshape(data,len_trial,[]);
datapara.data = data;
datapara.trig = trig;
fclose(fid);