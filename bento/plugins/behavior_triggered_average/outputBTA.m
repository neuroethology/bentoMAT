function outputBTA(source,~,gui)
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt

var = input('Assign variable name:');
var(ismember(var,'?!@#$%^&*()+=-<>,./\[]}{')) = [];
if(isempty(var))
    msgbox('Invalid variable name, data not saved.');
    return;
end
if(isnumeric(var(1)))
    var = ['var_' var];
end

BTA=computeBTA(source,[],gui);
assignin('base',var,BTA);
msgbox(['Traces saved as ' var]);