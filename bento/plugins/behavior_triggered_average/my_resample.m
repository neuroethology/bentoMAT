function  varargout = my_resample(varargin)
%RESAMPLE  Resample uniform or nonuniform data to a new fixed rate.
%   Y = RESAMPLE(X,P,Q) resamples the values, X, of a uniformly sampled
%   signal at P/Q times the original sample rate using a polyphase
%   antialiasing filter. If X is a matrix, then RESAMPLE treats each
%   column as an independent channel.
%
%   In its filtering process, RESAMPLE assumes the samples at times before
%   and after the given samples in X are equal to zero. Thus large
%   deviations from zero at the end points of the sequence X can cause
%   inaccuracies in Y at its end points.
%
%   [Y,Ty] = RESAMPLE(X,Tx) resamples the values, X, of a signal sampled at
%   the instants specified in vector Tx. RESAMPLE interpolates X linearly
%   onto a vector of uniformly spaced instants, Ty, with the same endpoints
%   and number of samples as Tx.  Tx may either be a numeric vector
%   expressed in seconds or a datetime object.  NaNs and NaTs (for datetime
%   objects) are treated as missing data and are ignored.
%
%   [Y,Ty] = RESAMPLE(X,Tx,Fs) uses interpolation and an anti-aliasing
%   filter to resample the signal at a uniform sample rate, Fs, expressed
%   in hertz (Hz).
%
%   [Y,Ty] = RESAMPLE(X,Tx,Fs,P,Q) interpolates X to an intermediate
%   uniform grid with sample rate equal Q*Fs/P and filters the result
%   using UPFIRDN to upsample by P and downsample by Q.  Specify P and Q
%   so that Q*Fs/P is least twice as large as the highest frequency in the
%   input signal.
%
%   [Y,Ty] = RESAMPLE(X,Tx,...,METHOD) specifies the interpolation method.
%   The default is linear interpolation.  Available methods are:
%     'linear' - linear interpolation
%     'pchip'  - shape-preserving piecewise cubic interpolation
%     'spline' - piecewise cubic spline interpolation
%
%   Y = RESAMPLE(...,P,Q,N) uses a weighted sum of 2*N*max(1,Q/P) samples
%   of X to compute each sample of Y.  The length of the FIR filter
%   RESAMPLE applies is proportional to N; by increasing N you will get
%   better accuracy at the expense of a longer computation time.
%   RESAMPLE uses N = 10 by default. If N = 0, RESAMPLE performs
%   nearest neighbor interpolation: the output Y(n) is
%   X(round((n-1)*Q/P)+1), with Y(n) = 0 for round((n-1)*Q/P)+1 > length(X)).
%
%   Y = RESAMPLE(...,P,Q,N,BTA) uses BTA as the BETA design parameter for
%   the Kaiser window used to design the filter.  RESAMPLE uses BTA = 5 if
%   you don't specify a value.
%
%   Y = RESAMPLE(...,P,Q,B) uses B to filter X (after upsampling) if B is a
%   vector of filter coefficients.  RESAMPLE assumes B has odd length and
%   linear phase when compensating for the filter's delay; for even length
%   filters, the delay is overcompensated by 1/2 sample.  For non-linear
%   phase filters consider using UPFIRDN.
%
%   [Y,B] = RESAMPLE(X,P,Q,...) returns in B the coefficients of the filter
%   applied to X during the resampling process (after upsampling).
%
%   [Y,Ty,B] = RESAMPLE(X,Tx,...) returns in B the coefficients of the
%   filter applied to X during the resampling process (after upsampling).
%
%   Y = resample(...,'Dimension',DIM) specifies the dimension, DIM,
%   along which to resample an N-D input array. If DIM is not specified,
%   resample operates along the first array dimension with size greater
%   than 1.
%
%   % Example 1:
%   %   Resample a sinusoid at 3/2 the original rate.
%
%   tx = 0:3:300-3;         % Time vector for original signal
%   x = sin(2*pi*tx/300);   % Define a sinusoid
%   ty = 0:2:300-2;         % Time vector for resampled signal
%   y = resample(x,3,2);    % Change sampling rate
%   plot(tx,x,'+-',ty,y,'o:')
%   legend('Original','Resampled');
%   xlabel('Time')
%
%   % Example 2:
%   %   Resample a non-uniformly sampled sinusoid to a uniform 50 Hz rate.
%
%   Fs = 50;
%   tx = linspace(0,1,21) + .012*rand(1,21);
%   x = sin(2*pi*tx);
%   [y, ty] = resample(x, tx, Fs);
%   plot(tx,x,'+-',ty,y,'o:')
%   legend('Original','Resampled');
%   xlabel('Time')
%
%   % Example 3:
%   %   Resample a multichannel sinusoid by 3/2 along its second dimension.
%
%   p = 3;
%   q = 2;
%   tx = 0:3:300-3;
%   x = cos(2*pi*tx./(1:5)'/100);
%   y = resample(x,p,q,'Dimension',2);
%   ty = 0:2:300-2;
%   plot(tx,x,'+-',ty,y,'o:')
%   legend('Original','Resampled');
%   xlabel('Time')
%
%   % Example 4:
%   %   Resample a 3D random signal along its second dimension at twice the
%   %  original rate.
%
%   tx = 0:2:38;
%   x = rand(100,20,5);
%   ty = 0:39;
%   y = resample(x,2,1,'Dimension',2);
%   plot(tx,x(1,:,1),'+-',ty,y(1,:,1),'o:')
%   legend('Original','Resampled');
%   xlabel('Time')
%
%   See also UPFIRDN, INTERP, INTERP1, DECIMATE, FIRLS, KAISER, INTFILT.

%   NOTE: digital anti-alias filter is designed using windowing

%   Copyright 1988-2020 The MathWorks, Inc.
%
%#codegen

narginchk(2,10);

tempArgs = cell(size(varargin));

[tempArgs{:}] = convertStringsToChars(varargin{:});

[Dim,m,isDimValSet] = dimParser(tempArgs{:});

% permutes the input dimensions such that it's first non-singleton dimension is DIM
[xIn, dimIn] = orientToNdim (varargin{1}, Dim);

% fetch the users desired interpolation method (if any)
method = getInterpMethod(tempArgs{:});

% Parse the inputs and set the appropriate arguments
isP = isscalar(varargin{2});

% fetch the numeric arguments
n1 = coder.const(countNumericInputs(varargin{:}));
numericArgs = cell(1,n1);
idx =0;

coder.unroll();
for kk = 1:length(varargin)
    if isnumeric(varargin{kk}) || isdatetime(varargin{kk})
        idx = idx+1;
        numericArgs{idx} = varargin{kk};
    end
end

if isP && (m <= 5)
    % [...] = RESAMPLE(X,P,Q,...)
    % error check for uniform resampling
    coder.internal.assert(~(m < 3 && isP),'signal:resample:MissingQ');
    
    % interpolation is not performed when using uniformly sampled data
    coder.internal.assert(~(~strcmp(method,'')),'signal:resample:UnexpectedInterpolation',method);
    
    [varargout{1:max(1,nargout)}] = uniformResample(xIn, isDimValSet, Dim, dimIn, numericArgs{:});
else
    % [...] = RESAMPLE(X,Tx,...)
    if strcmp(method,'')
        % use linear method by default
        method1 = 'linear';
    else
        method1 = method;
    end
    
    [varargout{1:max(1,nargout)}] = nonUniformResample(isDimValSet,Dim, m, method1, dimIn, xIn, numericArgs{:});
end
end

function [y, tyOut, h] = nonUniformResample(isDimValSet, Dim, m, method, dimIn, xIn, varargin)

if (numel(varargin)>1)
    tx1 = varargin{2};
end

% fetch non-NaN input samples in time-sorted order
[x, tx] = getSamples(xIn,tx1,Dim);

fs = 1;

if ((length(varargin) >= 4 && isDimValSet)|| (length(varargin) >= 3 && ~isDimValSet)) && ~isempty(varargin{3})
    fs = varargin{3};
    validateFs(fs);
    % obtain sample rate
elseif isdatetime(tx) && (length(tx)>1)
    % compute the average sample rate if unspecified
    fs = (numel(tx)-1) / seconds(tx(end)-tx(1));
elseif ~isdatetime(tx) && (length(tx)>1)
    fs = (numel(tx)-1) / (tx(end)-tx(1));
end

coder.internal.assert(~((m == 4) && ~isscalar(varargin{2})),...
    'signal:resample:MissingQ');

p = 1;
q = 1;
if (length(varargin)>= 6 && isDimValSet) || (length(varargin) >= 5 && ~isDimValSet)
    if ~isempty(varargin{4}) && ~isempty(varargin{5})
        p = varargin{4};
        q = varargin{5};
    end
    validateResampleRatio(p,q);
else
    % get a close rational approximation of the ratio between the desired
    % sampling rate and the average sample rate
    [p, q] = getResampleRatio(tx,fs);
end

% use cubic spline interpolation onto a uniformly sampled grid
% with a target sample rate of Q*Fs/P
tsGrid = p/(q*fs);
tGrid = 0;
if isdatetime(tx)&& length(tx) > 1
    tGrid = tx(1):seconds(tsGrid):tx(end);
elseif ~isdatetime(tx) && length(tx) > 1
    tGrid = tx(1):tsGrid:tx(end);
end

if isreal(x)
    xGrid = nDInterp1(tx,x,tGrid,method);
else
    % compute real and imaginary channels independently
    realGrid = nDInterp1(tx,real(x),tGrid,method);
    imagGrid = nDInterp1(tx,imag(x),tGrid,method);
    xGrid = complex(realGrid,imagGrid);
end

% recover the desired sampling rate by resampling the grid at the
% specified ratio
[y, h] = uniformResample(xGrid, isDimValSet, Dim, dimIn, varargin{1}, p, q, varargin{6:end});

% create output time vector
if isvector(y)
    ny = length(y);
else
    ny = size(y,Dim);
end

ty = coder.nullcopy(zeros(1,ny));

if isdatetime(tx)
    ty = tx(1) + seconds((0:ny-1)/fs);
elseif ~isdatetime(tx) && length(tx)>1
    ty = (tx(1)*ones(1,ny)) + (0:ny-1)/fs(1);
end

% match dimensionality of output time vector to input
if iscolumn(tx)
    tyOut = ty(:);
else
    tyOut = ty;
end
end
%-------------------------------------------------------------------------
function  [y, h] = uniformResample(x, isDimValSet, Dim, dimIn, xTrue, p, q, varargin)

% codegen inference
if nargin < 7
    q = 1;
end

% number of numeric arguments in varargin
nNum = length(varargin);
N = 10;
bta = 5;

% parse N and beta
if ~isempty(varargin)
    if ((nNum >= 2 && isDimValSet)|| (nNum >= 1 && ~isDimValSet))&& ~isempty(varargin{1})
        N = varargin{1};
    end
    if ((nNum >= 3 && isDimValSet)|| (nNum >= 2 && ~isDimValSet))&& ~isempty(varargin{2})
        bta = varargin{2};
    end
end

validateattributes(x, {'numeric'},{},'resample','X',1);
validateResampleRatio(p, q);

[p, q] = rat( p/q, 1e-12 );  %--- reduce to lowest terms
% (usually exact, sometimes not; loses at most 1 second every 10^12 seconds)
p = p(1);
q = q(1);

if (p == 1) && (q == 1)
    yTmp = x;
    if (numel(x) == numel(xTrue))
        y = ipermute(yTmp,dimIn);
        y = reshape(y,size(xTrue));
    else
        y = reshape(yTmp,size(x));
        y = ipermute(y,dimIn);
    end
    h = 1;
    return
end

pqmax = max(p,q);
if length(N)>1      % use input filter
    L = length(N);
    h = N;
else                % design filter
    if( N>0 )
        fc = 1/2/pqmax;
        L = 2*N(1)*pqmax + 1;
        h = firls( L-1, [0 2*fc 2*fc 1], [1 1 0 0]).*kaiser(L,bta)' ;
        h = p*h/sum(h);
    else
        L = p;
        h = ones(1,p);
    end
end

Lhalf = (L-1)/2;

if isvector(x)
    Lx = length(x);
else
    Lx = size(x, 1);
end

% Need to delay output so that downsampling by q hits center tap of filter.
nZeroBegin = floor(q-mod(Lhalf,q));
z = zeros(1,nZeroBegin);
h = [z h(:).'];  % ensure that h is a row vector.
Lhalf = Lhalf + nZeroBegin;

% Number of samples removed from beginning of output sequence
% to compensate for delay of linear phase filter:
delay = floor(ceil(Lhalf)/q);

% Need to zero-pad so output length is exactly ceil(Lx*p/q).
nZeroEnd = computeZeroPadLength(Lx,p,q,length(h),delay);
h = [h zeros(1,nZeroEnd)];

% Get rid of trailing and leading data so input and output signals line up
% temporally:
Ly = ceil(Lx*p/q);  % output length
% Ly = floor((Lx-1)*p/q+1);  <-- alternately, to prevent "running-off" the
%                                data (extrapolation)
szx = size(x);
sy = szx;
if isrow(x)
    sy(2) = Ly;
else
    sy(1) = Ly;
end

% numel in the 3rd dimension, when nD array is collapsed to a 3D-array
n2D = 1;
if numel(szx) >= 3
    n2D = prod(szx(3:length(szx)),'all');
end

% syTrue is the desired output size for uniform resample
sxTrue = size(xTrue);
syTrue = sxTrue;

if isvector(xTrue)
    if isrow(xTrue)
        syTrue(2) = Ly;
    else
        syTrue(1) = Ly;
    end
else
    syTrue(Dim) = Ly;
end

% ----  HERE'S THE CALL TO UPFIRDN  ----------------------------
if isreal(x)
    y = coder.nullcopy(zeros(syTrue));
else
    y = coder.nullcopy(complex(ones(syTrue),ones(syTrue)));
end

if isvector(x)
    yVec = upfirdn(x,h,p,q);
    indV = delay+(1:Ly);
    
    if ~isrow(x)
        indV = indV.';
        yV = yVec(indV);
        y = yV;
    else
        yV = yVec(indV);
        yV1 = yV.';
        if (numel(x) == numel(xTrue))
            y = reshape(yV1,syTrue);       % % uniform resample
        else
            y = reshape(yV1,sy);           % % non-uniform resample
        end
    end
elseif ~isvector(x) && (numel(szx)==2)
    ymat = upfirdn(x,h,p,q);
    indM = delay+(1:Ly);
    indM = indM.';
    yM=ymat(indM,:);
    
    if (numel(ymat) == prod(syTrue))
        yRshp = ipermute(yM,dimIn);
        y = reshape(yRshp,syTrue);
    else
        y = ipermute(yM,dimIn);       % % non-uniform resample
    end
end

% input is an nD-array
if (numel(szx)> 2)
    syTmp = [sy(1:2) n2D];
    if isreal(x)
        yTmp = coder.nullcopy(zeros(syTmp));
    else
        yTmp = coder.nullcopy(complex(ones(syTmp),ones(syTmp)));
    end
    
    for ii = 1:n2D
        xTmp = x(:,:,ii);
        
        if (szx(1) == 1)
            % if xTmp is a row vector and user sets Dimension to the singleton dimension
            if isreal(x)
                yTmp1 = coder.nullcopy(zeros(sy(1),sy(2)));
            else
                yTmp1 = coder.nullcopy(complex(ones(sy(1),sy(2)),ones(sy(1),sy(2))));
            end
            
            for jj = 1: szx(2)
                xTmp1 = x(1,jj,ii);
                yTmp2 = upfirdn(xTmp1,h,p,q).';
                indTmp = (1:Ly)+delay;
                indTmp = indTmp.';
                y1 = yTmp2(indTmp,:);
                yTmp1(1:Ly,jj) = y1;
            end
            yTmp(:,:,ii) = yTmp1;
            
        else
            yTmp1 = upfirdn(xTmp,h,p,q);
            ind = (1:Ly)+delay;
            ind = ind.';
            y1 = yTmp1(ind,:);
            yTmp(:,:,ii) = y1;
        end
    end
    
    if (numel(syTmp) ~= numel(sy))      % nonuniform resample
        yRshp = reshape(yTmp,sy);       % converting 3D output to nD
        y1 = ipermute(yRshp,dimIn);      % returns to the original orientation
        y = reshape(y1,syTrue);          % ensures the correct output size
    else
        y1 = ipermute(yTmp,dimIn);
        y = reshape(y1,syTrue);
    end
end

h = h(nZeroBegin+1:end-nZeroEnd);  % get rid of leading and trailing zeros
% in case filter is output
end
%-------------------------------------------------------------------------
function [xOut, txOut] = removeMissingTime(x,tx)
if isdatetime(tx)
    idx = isnat(tx);
else
    idx = isnan(tx);
end

txOut = tx;
xOut = x;
if ~isempty(idx)
    txOut(idx) = [];
    if isvector(x)
        xOut(idx) = [];
    else
        xOut(idx,:) = [];
    end
end
end
%-------------------------------------------------------------------------
function y = nDInterp1(tin, xin, tout, methodInt)

% by default specify tout as a column to obtain column matrix output
tout1 = reshape(tout,[],1);
tin1 = reshape(tin,[],1);

sxIn = size(xin);

if isvector(xin)
    if isrow(xin)
        % preserve orientation of input vector
        tout2 = tout1.';
    else
        tout2 = tout1;
    end
    xinCol = reshape(xin,[],1);
    % interpolate, excluding NaN
    idx = find(~isnan(xinCol));
    y = vecInterp1(tin1(idx), xinCol(idx), tout2, methodInt);
    
elseif ismatrix(xin)
    y = matInterp1(tin1, xin, tout1, methodInt);
    
elseif numel(sxIn) > 2
    sy = sxIn;
    sy(1) = length(tout1);
    y = coder.nullcopy(zeros(sy));
    
    nPages = 1;
    if (numel(sxIn) >= 3)
        nPages = prod(sxIn(3:end));
    end
    
    for np = 1: nPages
        y(:,:,np) = matInterp1(tin1, xin(:,:,np), tout1, methodInt);
    end
end
end

%-------------------------------------------------------------------------
function y = matInterp1(tin, xin, tout, method)

% by default specify tout as a column to obtain column matrix output
tout1 = reshape(tout,[],1);
tin1 = reshape(tin,[],1);
y = coder.nullcopy(zeros(size(tout1)));

if isvector(xin)
    if isrow(xin)
        % preserve orientation of input vector
        tout2 = tout1.';
    else
        tout2 = tout1;
    end
    xinCol = reshape(xin,[],1);
    % interpolate, excluding NaN
    idx = find(~isnan(xinCol));
    
    y = vecInterp1(tin1(idx), xinCol(idx), tout2, method);
    
elseif ismatrix(xin)
    % initialize matrix output
    nRows = size(tout1,1);
    nCols = size(xin,2);
    y = coder.nullcopy(zeros(nRows,nCols));
    
    % loop through each column of input x
    for col=1:nCols
        % interpolate, excluding NaN
        idx = find(~isnan(xin(:,col)));
        y(:,col) = vecInterp1(tin1(idx), xin(idx,col), tout1, method);
    end
end
end

%-------------------------------------------------------------------------
function y = vecInterp1(tin, xin, tout, methodIntrp)

% check sample times for duplicate entries
iDup = find(diff(tin) == 0);

% copy indices to point to the repeated locations in xin/tin
iRepeat = 1 + iDup;

while ~isempty(iDup)
    % find the number of successive equal sample times
    numEqual = find(diff(iDup) ~= 1,1,'first');
    if isempty(numEqual)
        numEqual = numel(iDup);
    end
    numEqual1 = numEqual(1);
    
    % replace leading x with mean value of all duplicates
    xSelect = xin(iDup(1) + (0:numEqual1));
    xMean = mean(xSelect(~isnan(xSelect)));
    xin(iDup(1)) = xMean;
    
    % move to next block of conflicting sample times
    iDup = iDup(2+numEqual1:end);
end

% remove duplicates
xin(iRepeat) = [];
tin(iRepeat) = [];

% call interp
switch methodIntrp
    case 'pchip'
        y = interp1(tin, xin, tout, 'pchip', 'extrap');
    case 'spline'
        y = interp1(tin, xin, tout, 'spline', 'extrap');
    otherwise
        y = interp1(tin, xin, tout, 'linear', 'extrap');
end
end

%-------------------------------------------------------------------------
function [xOut, tx] = getSamples(x, tx, Dim)
sx = size(x);
validateattributes(x, {'numeric'},{},'resample','X',1);

coder.internal.assert(~(isvector(x) && numel(x) ~= numel(tx)),...
    'signal:resample:TimeVectorMismatch');

coder.internal.assert(~(~isvector(x) && numel(sx)==2 && ...
    size(x,1) ~= numel(tx)) ,'signal:resample:TimeRowMismatch');

coder.internal.assert(~((numel(sx)>=3) && (size(x,1) ~= numel(tx))) ,...
    'signal:resample:TimeResampleDimMismatch',Dim);

if isdatetime(tx)
    validateattributes(tx, {'datetime'},{'vector'}, 'resample','Tx',2);
else
    validateattributes(tx, {'numeric'},{'real','vector'}, ...
        'resample','Tx',2);
end

[x, tx] = removeMissingTime(x, tx);

% for efficiency, place samples in time-sorted order
[tx, idx] = sort(tx);
if isvector(x)
    % handle row vector input
    if isrow(x)
        xOut = x(1,idx(:));
    else
        xOut = x(idx(:));
    end
elseif ismatrix(x)
    xOut = x(idx,:);
elseif numel(sx) >= 3
    xOut = x(idx,:,:);
    xOut = reshape(xOut,size(x));
end

% check finite behavior after sorting and NaN removal
if ~isdatetime(tx)
    validateattributes(tx, {'numeric'},{'finite'}, 'resample','Tx',2);
end
end

%-------------------------------------------------------------------------
function validateFs(fs)
validateattributes(fs, {'numeric'},{'real','finite','scalar', ...
    'positive'},'resample','Fs',3);
end

%-------------------------------------------------------------------------
function validateResampleRatio(p, q)
validateattributes(p, {'numeric'},{'integer','positive','finite', ...
    'scalar'},'resample','P');
validateattributes(q, {'numeric'},{'integer','positive','finite', ...
    'scalar'},'resample','Q');
end
%-------------------------------------------------------------------------
function [p, q] = getResampleRatio(t, fs)

tsAvg = coder.nullcopy (0);
if length(t)>1
    % compute the average sampling interval
    tsAvg = (t(end)-t(1))/(numel(t)-1);
end

if isduration(tsAvg)
    tsAvg = seconds(tsAvg);
end

% get a rational approximation of the ratio of the desired to the average
% sample rate
[p, q] = rat(tsAvg*fs,.01);

if p < 2
    % sample rate too small for input
    p = 1;
    q = round(1/(tsAvg*fs));
end
end

%-------------------------------------------------------------------------
function [method] = getInterpMethod(varargin)

method = '';
supportedMethods = {'linear','pchip','spline'};
for i=1:numel(varargin)
    if ischar(varargin{i})|| isStringScalar(varargin{i})
        if (strncmpi(varargin{i},'Dimension',3))
            break;
        else
            method = validatestring(varargin{i},supportedMethods,'resample','METHOD');
        end
    end
end
end

%-------------------------------------------------------------------------
function [xOut, dimPerm] = orientToNdim (x, nDim)
sX = size(x);

% error if Dimenion is larger than input size
coder.internal.assert(~(~isscalar(x) && (numel(sX)< nDim)),...
    'signal:resample:DimensionMismatch');

trueDim = 1:numel(sX);
dimPerm = coder.nullcopy(trueDim);

if isvector(x)
    xOut = x;
    dimPerm = trueDim;
elseif (numel(sX) >= 2)
    % rotate the input according to Dimension
    if (nDim ~= 1)
        [~,inds] = sort(sX,'descend');
        i1 = (inds ~= nDim);
        dimPerm(1) = nDim;
        dimPerm(2:end) = inds(i1);
        xOut = permute(x, dimPerm);
    else
        xOut = x;
        dimPerm = trueDim;
    end
end
end
%-------------------------------------------------------------------------
function [dim,m,isDimValSet] = dimParser(varargin)

% By default, set nDim to the first non-singleton dimension
sx = size(varargin{1});
dim = 1;

if numel(sx) > 1 && ~isscalar(varargin{1})
    nonSingDim = find(sx>1);
    dim = nonSingDim(1);
end

% flags to set
dimSet = false;
isDimValSet = false;
possibleStrings = {'linear','pchip','spline','Dimension'};

coder.unroll;
for argIndex = 1:length(varargin)
    inputVal = varargin{argIndex};
    if ischar(inputVal) || isStringScalar(inputVal)
        str = validatestring(inputVal,possibleStrings,'resample');
        switch str
            case 'Dimension'
                coder.internal.assert(~dimSet, ...
                    'signal:resample:MultipleNameEntered');
                dimSet = true;
        end
    elseif isnumeric(inputVal)
        if (dimSet) && (argIndex == length(varargin))
            validateattributes(inputVal,{'numeric'},...
                {'scalar','finite','real','positive'},'resample','Dim');
            dim = double(inputVal);
            isDimValSet = true;
        end
    end
end

coder.internal.assert(~(dimSet && ~isDimValSet),...
    'signal:resample:NameValueExpected');

n = coder.const(countNumericInputs(varargin{:}));

% the number of numeric arguments in varargin after removing Dimension
if dimSet && isDimValSet
    m = n-1;                            % user specified Dim
else
    m = n;
end

end

function n = countNumericInputs(varargin)
n = 0;
coder.unroll;
for k = 1:nargin
    if isnumeric(varargin{k}) || isdatetime(varargin{k})
        n = n + 1;
    end
end
end

function nZeroEnd = computeZeroPadLength(Lx,p,q,lenH,delay)
% coder.internal.prefer_const(Lx,p,q,lenH,delay);
nZeroEnd = 0;
while ceil( ((Lx-1)*p+lenH+nZeroEnd )/q ) - delay < ceil(Lx*p/q)
    nZeroEnd = nZeroEnd+1;
end
end
% LocalWords:  resamples Ns Fs BTA upsampling ty resampled Krauss LPF Lx xin sy Tmp Dimenion
% LocalWords:  extrap
