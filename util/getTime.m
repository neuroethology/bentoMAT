function num = getTime(str)
c   = strfind(str,':');
min = str2num(str(1:c-1));
sec = str2num(str(c+1:end));

num = min*60 + sec;