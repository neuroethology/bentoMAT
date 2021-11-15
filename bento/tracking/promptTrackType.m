function trackType = promptTrackType(custom_list)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



pth         = fileparts(which('promptTrackType'));
trackerList = dir([pth filesep 'tracking unpackers' filesep '*.m']);
trackerList = {trackerList.name};
trackerList = strrep(trackerList,'.m','');

if exist('custom_list','var')
    useList = custom_list;
else
    useList = trackerList;
end

[s,v] = listdlg('PromptString','Select tracking format:',...
                'SelectionMode','single',...
                'ListSize',[160 100],...
                'ListString',useList);
                
if(~v)
    warndlg('Tracking will be disabled until a tracking format has been specified');
    trackType=[];
    return;
end
    
trackType = useList{s};