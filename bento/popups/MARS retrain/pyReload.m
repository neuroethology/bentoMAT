function pyReload()
%
% (C) Ann Kennedy, 2019
% California Institute of Technology
% Licensing: https://github.com/annkennedy/bento/blob/master/LICENSE.txt



clear classes;
fun = inputdlg('reload python module:');
mod = py.importlib.import_module(fun{:});
py.reload(mod);
