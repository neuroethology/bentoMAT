function strtemp = unpackTracking(pth, strtemp, trackList, trackFile)


fid = [pth strip(strip(trackList{trackFile},'left','.'),'left',filesep)];
[~,~,ext] = fileparts(fid);

if(strcmpi(ext,'.mat'))
    temp = load(fid); %virtual load would be faster/more memory friendly, but laggier
    strtemp.tracking.args{trackFile} = temp;
    strtemp.io.feat.fid{trackFile} = fid;

elseif(strcmpi(ext,'.json'))
    if(exist('jsondecode','builtin'))
        disp('loading tracking data');
        strtemp.tracking.args{trackFile} = jsondecode(fileread(fid));
    elseif(exist('loadjson','file'))
        disp('Using loadjson.')
        strtemp.tracking.args{trackFile} = loadjson(fid);
    else
        disp('Please download jsonlab (https://github.com/fangq/jsonlab) or upgrade to Matlab 2016b or later.')
        strtemp.tracking.args{trackFile} = [];
    end
    strtemp.io.feat.fid{trackFile} = fid;

elseif(strcmpi(ext,'.h5')) %DeepLabCut, JAX output, or SLEAP
    
    trackType = promptTrackType({'JAX','DLC','SLEAP'});
    strtemp.tracking.fun = trackType;
    if contains(trackType,'DLC')
        args = h5read(fid,'/df_with_missing/table');
        strtemp.tracking.args{trackFile} = args.values_block_0;
        strtemp.tracking.fun = 'DLC';
        
    elseif contains(trackType,'JAX')
        args = struct();
        args.points = h5read(fid,'/poseest/points');
        args.ids = h5read(fid,'/poseest/instance_track_id');
        strtemp.tracking.args{trackFile} = args;
        strtemp.trackTime = (1:length(strtemp.tracking.args{1}.ids))/30;
        strtemp.tracking.fun = 'JAX';
        
    elseif contains(trackType,'SLEAP')
        args =  struct();
        args.occupancy = h5read(fid,'/track_occupancy');
        args.tracks = h5read(fid,'/tracks');
        args.edges = double(h5read(fid,'/edge_inds'))+1;
        strtemp.tracking.args{trackFile} = args;
        strtemp.tracking.fun = 'SLEAP';
        
    end

elseif(strcmpi(ext,'.csv')) %also DeepLabCut output
    args = xlsread(fid);
    strtemp.tracking.args{trackFile} = args';
else % I couldn't unpack the tracking data :[
    strtemp.tracking.args={[]};
end