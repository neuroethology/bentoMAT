function pyReload()

clear classes;
fun = inputdlg('reload python module:');
mod = py.importlib.import_module(fun{:});
py.reload(mod);
