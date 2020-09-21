addpath(genpath(pwd));
raw_movie = h5read('L:\er08 redo\day3\ROItraces\Obj_1 - Concatenated Movie.h5','/Object'); % Mosaic uses dataset called 'Object', controller Preprocess uses '1'.

T = size(raw_movie,3);
R = size(raw_movie,1);%-25-25+1;
C = size(raw_movie,2);%-25-25+1;


im_cols = zeros(ceil(R/4)*ceil(C/4),T);
for t = 1:T
    %%%im = squeeze(raw_movie(220:end-25,25:end-75,t));  %controller preprocess uses 'test_sc' while Mosaic uses 'raw_movie'
    im = squeeze(raw_movie(:,:,t));
    im = imresize(im,1/4);
    im_cols(:,t) = im(:);

    if(mod(t,100)==0)
        t
    end
end

rankCa = 50;
opt.beta = .1;
opt.iter = 500;
[traces,xy,numIter,tElapsed,finalResidual] = sparsenmfnnls(im_cols'-min(im_cols(:)),rankCa,opt);