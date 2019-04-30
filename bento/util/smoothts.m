function vout = smoothts(vin, smethod, wsize, extarg)
%SMOOTHTS smoothes a matrix of data using a specified method.
%
%   VOUT = SMOOTHTS(VIN, SMETHOD, WSIZE, EXTARG)
%
%   SMOOTHTS, using the specified method, will smooth the data 
%   contained in a row-oriented matrix.  Valid smoothing methods
%   (SMETHOD) are Exponential (e), Gaussian (g) or Box (b).  Valid
%   SMETHOD's are in parentheses.  A row-oriented matrix is one
%   where each row is a variable and each column is an observation
%   for the specific variable.
%
%   VOUT = SMOOTHTS(VIN) smoothes the matrix VIN using the default
%   Box method with window size, WSIZE, of 5.
%
%   VOUT = SMOOTHTS(VIN, 'b', WSIZE) smoothes the input matrix VIN
%   using the Box (simple, linear) method.  WSIZE is an optional 
%   integer (scalar) argument that specifies the width of the box
%   to be used.  If WSIZE is not supplied, the default is 5.
%
%   VOUT = SMOOTHTS(VIN, 'g', WSIZE, STDEV) smoothes the input matrix
%   VIN using Gaussian Window method.  WSIZE and STDEV are optional
%   input arguments.  WZISE is an integer (scalar) that specifies the
%   size of the windows used.  STDEV is a scalar that represents the
%   standard deviation of the Gaussian Window.  If WSIZE and STDEV are
%   not supplied the defaults are 5 and 0.65, respectively.
%
%   VOUT = SMOOTHTS(VIN, 'e', WSIZE_OR_ALPHA) smoothes the input 
%   matrix VIN using Exponential method.  WZISE_OR_ALPHA is a value 
%   that can specify either the window size (WSIZE) or exponential 
%   factor (ALPHA).  If WSIZE_OR_ALPHA is an integer greater than 1, 
%   it is considered as the window size (WSIZE); however, if it is 
%   between 0 and 1, it is considered as ALPHA, the exponential factor.
%   When it is 1, the effect is the same whether it is regarded as 
%   WSIZE or ALPHA.  If WSIZE_OR_ALPHA is not supplied the default 
%   is WSIZE = 5 (thus, ALPHA = 0.3333).
%
%   VOUT is always a row-oriented matrix of the same length as VIN.
%
%   See also TSMOVAVG.

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2005 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $   $Date: 2005/12/12 23:18:55 $

switch nargin
case 1
    smethod = 'b';
    wsize = 5;
case 2
    if isempty(smethod)
        smethod = 'b';
    end
    wsize = 5;
case {3, 4}
    if isempty(smethod)
        smethod = 'b';
    end
    if isempty(wsize)
        wsize = 5;
    end
otherwise
    error('Ftseries:ftseries_smoothts:InvalidNumberOfInputArguments', ...
        'Invalid number of input arguments.');
end

if any(double(wsize < 0)) | (prod(size(wsize)) ~= 1)
    error('Ftseries:ftseries_smoothts:WSIZEMustBePosScalar', ...
        'WSIZE must be a single positive scalar.');
elseif length(wsize) == 1
    wsize = [1 wsize];
end

overshoots = floor(wsize(2)/2);
if overshoots*2 == wsize(2)
    downshoot = overshoots-1;
    upshoot = overshoots;
else
    downshoot = overshoots;
    upshoot = overshoots;
end   

vout = vin;
switch lower(smethod(1))
case 'b'
    if nargin == 3
        if isempty(wsize)
            wsize = [1 5];
        end
    elseif nargin == 4
        error('Ftseries:ftseries_smoothts:TooManyInputArguments', ...
            'Too many input arguments.');
    end
    smoothfilt = ones(wsize) ./ prod(wsize);
    for hdx = 1:size(vin, 1)
        tvout = conv(vin(hdx, :), smoothfilt);
        vout(hdx, :) = tvout(downshoot+1:length(tvout)-upshoot);
    end
case 'g'
    if nargin == 2
        extarg = 0.65;
    elseif nargin == 3
        if isempty(wsize)
            wsize = [1 5];
        end
        extarg = 0.65;
    elseif nargin == 4
        if isempty(extarg)
            extarg = 0.65;
        end
    end
    x = -(wsize(2)-1)/2:(wsize(2)-1)/2;
    smoothfilt = exp(-(x.*x)/(2*extarg));
    smoothfilt = smoothfilt/sum(smoothfilt(:));
    for hdx = 1:size(vin, 1)
        tvout = conv(vin(hdx, :), smoothfilt);
        vout(hdx, :) = tvout(downshoot+1:length(tvout)-upshoot);
    end
case 'e'
    if nargin == 2
        extarg = 2/(wsize + 1);
    elseif nargin == 3
        if isempty(wsize)
            wsize = [1 5];
        end
        if wsize(2) > 1
            extarg = 2 / (wsize(2) + 1);
        elseif wsize(2) <= 1
            extarg = wsize(2);
        end
    elseif nargin == 4
        error('Ftseries:ftseries_smoothts:TooManyInputArguments', ...
            'Too many input arguments.');
    end
    vout = vin;
    for idx = 2:size(vin,2)
        vout(:, idx) = extarg.*vin(:, idx) + (1-extarg).*vout(:, idx-1);
    end
otherwise
    error('Ftseries:ftseries_smoothts:InvalidSmoothingMethod', ...
        'Valid smoothing methods are Box (''b''), Exponential (''e''), or Gaussian (''g'').');
end

% [EOF]
