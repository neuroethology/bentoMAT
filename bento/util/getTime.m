function num = getTime(str)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt

str = regexp(str,'\d*:\d*.\d*','Match');
if(~isempty(str))
    str = str{1};
    c   = strfind(str,':');
    min = str2num(str(1:c-1));
    sec = str2num(str(c+1:end));
else
    min = 0; sec = 0;
end

num = min*60 + sec;