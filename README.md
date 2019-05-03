# **B**ehavior **E**nsemble and **N**eural **T**rajectory **O**bservatory

Bento is a Matlab GUI for managing multimodal neuroscience datasets. It lets you browse and annotate behavioral and neural data, train behavior classifiers, and helps you organize and navigate trials within a batch of experiments.

Visit the [Bento wiki](https://github.com/annkennedy/bento/wiki) for documentation and tutorials!
<div align=center>
<img src='https://github.com/annkennedy/bento/docs/tracking_demo.gif?raw=true'>
</div>

## Installation
The easiest way to keep your local version up to date is to clone this git repository. To launch Bento, enter `addpath(genpath('path\to\bento\repository'))` in the Matlab command line, followed by `bento`.

Bento requires the following software:
* Matlab 2014b or later
* Microsoft Excel (for assembling of metadata. This requirement will be softened in the future.)

You may also wish to install:
* [Piotr's Matlab Toolbox](https://pdollar.github.io/toolbox/) if you use *.seq format videos
* [Source2D Toolbox](https://github.com/zhoupc/CNMF_E) (in ca_source_extraction) if you use calcium traces extracted with CNMF_E
* [JSONLab](https://github.com/fangq/jsonlab) if you use our mouse tracker, MARS, and your MATLAB doesn't have native *.json support (pre-2017)

<br>
<p><img src='https://github.com/annkennedy/bento/docs/annotation_demo.gif?raw=true' width='48%'> <img src='https://github.com/annkennedy/bento/docs/features_demo.gif?raw=true' width='48%'></p>

## Code Contributors
Bento was created by [Ann Kennedy](https://annkennedy.github.io/), but has benefitted from the suggestions of several members of the [David J Anderson lab](https://davidandersonlab.caltech.edu) at Caltech, including Tomomi Karigo, Bin Yang, and Jalani Williams.

MARS, a pose estimation and behavior classification system that can be integrated with Bento, was created by Cristina Segalin, Jalani Williams, and Ann Kennedy, with support of members of the [Anderson](https://davidandersonlab.caltech.edu) and [Perona](http://www.vision.caltech.edu/Perona.html) labs at Caltech. Code and documentation for MARS is coming soon.

Bento is an actively developed package, and we welcome community involvement. For questions about Bento, consult the project [Wiki](https://github.com/annkennedy/bento/wiki).

If you wish to contribute to Bento, or your question was not answered by the [Wiki](https://github.com/annkennedy/bento/wiki), please contact <a class="u-email" href="mailto:&#x6b;&#x65;&#x6e;&#x6e;&#x65;&#x64;&#x79;&#x61;&#x40;&#x63;&#x61;&#x6c;&#x74;&#x65;&#x63;&#x68;&#x2e;&#x65;&#x64;&#x75;">&#x6b;&#x65;&#x6e;&#x6e;&#x65;&#x64;&#x79;&#x61;&#x40;&#x63;&#x61;&#x6c;&#x74;&#x65;&#x63;&#x68;&#x2e;&#x65;&#x64;&#x75;</a>.

<br>
<p><img src='https://github.com/annkennedy/bento/docs/panels_demo.gif?raw=true' width='48%'> <img src='https://github.com/annkennedy/bento/docs/PCA_demo.gif?raw=true' width='48%'></p>

## Licensing
Bento is licensed through Caltech; redistribution and use for academic and other non-commercial purposes, with or without modification, are permitted provided that conditions of the [license](https://github.com/annkennedy/bento/blob/master/LICENSE.txt) are met.
