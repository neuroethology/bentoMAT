# **B**ehavior **E**nsemble and **N**eural **T**rajectory **O**bservatory

Bento is a Matlab GUI for browsing and annotating joint calcium imaging + video datasets. It lets you browse and annotate behavioral and neural data, and makes it easy to organize and navigate trials within a batch of experiments.
<div align=center><img src=/docs/bento_screenshot_plain.png?raw=true width=500px></div>


## Installation
The easiest way to keep your local version up to date is to clone this git repository. Bento requires the following software:
* Matlab 2014b or later
* Microsoft Excel (for assembling of metadata. This requirement will be softened in the future.)

#### Optional additional tools:
* [Piotr's Matlab Toolbox](https://pdollar.github.io/toolbox/) if behavior videos are in *.seq format
* [Source2D Toolbox](https://github.com/zhoupc/CNMF_E) (in ca_source_extraction) if using calcium traces extracted with CNMF_E
* [JSONLab](https://github.com/fangq/jsonlab) for some tracker files- if your MATLAB doesn't have native *.json support (pre-2017?)


## Creating your first experiment
Clicking "New Experiment" in the welcome menu brings up a window in which you can enter experiment metadata + paths to your data; entered text can be saved into an excel sheet ("Save info") and reloaded in subsequent sessions ("Edit experiment"/"Load experiment" in the main menu).

Bento assumes all of your data can be found within a common parent directory (possibly split among subdirectories.) Setting the path of this parent directory, then hitting "Launch File Finder", allows you to search for files within your parent directory and add them to the table.

You can link any combination of imaging data, behavior annotations, behavior movies, audio recordings, and tracking data (some of these are better supported than others at the moment.) A variety of data formats are supported for each field- see more below.

### Supported Data Formats
#### Calcium imaging data
* [CNMF-E output](https://github.com/zhoupc/CNMF_E)
* Any mat file containing a single matrix (any variable name)-- Bento will assume that matrix is arranged as neurons x time

#### Movies
* .seq format (used by [Piotr's Toolbox](https://pdollar.github.io/toolbox/))
* Any video type supported by Matlab's VideoReader (mp4, wav, avi...)

Multiple movies can be displayed simultaneously: list files in the appropriate cell of the experiment excel sheet, with filenames separated by semicolons (;). Movies will be stacked vertically; use a double-semicolon (;;) to display side-by-side.

#### Behavior annotations
* Caltech behavior annotator (I think part of [Piotr's Toolbox](https://pdollar.github.io/toolbox/)) 
* Bento .annot files

Multiple annotations can be loaded simultaneously: list files in the appropriate cell of the experiment excel sheet, with filenames separated by semicolons (;).

#### Audio data
* Linked .wav files will be converted to spectrograms (this sometimes takes a while) and displayed. The generated spectrograms will be saved to a .mat file and re-loaded automatically on future use.

## Using the GUI
Coming soon.
