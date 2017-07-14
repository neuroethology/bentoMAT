function trackType = promptTrackType()

pth         = fileparts(which('promptTrackType'));
trackerList = dir([pth '\tracking unpackers\*.m']);
trackerList = {trackerList.name};
trackerList = strrep(trackerList,'.m','');

[s,v] = listdlg('PromptString','Select tracking format:',...
                'SelectionMode','single',...
                'ListSize',[160 100],...
                'ListString',trackerList);

if(~v)
    warndlg('Tracking will be disabled until a tracking format has been specified');
    trackType=[];
    return;
end
    
trackType = trackerList{s};