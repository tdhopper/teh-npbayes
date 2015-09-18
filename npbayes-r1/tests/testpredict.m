% test predictive likelihood code.  Uses bars problem.  Trains a network
% on bars problem, and estimate probability of observing each pixel.  This
% should sum to one no matter what.

cleardist

% description of the bars problem.
imsize        = 5;
noiselevel    = .01;
numbarpermix  = [0 ones(1,3)]/3;
numgroup      = 40;
numdata       = 50;
traindatass   = genbars(imsize,noiselevel,numbarpermix,numgroup,numdata);

% initialize hdp or lda.
numdim        = imsize^2;
numclass      = imsize*2+2; 
eta           = 1/imsize;
lda0          = ldaMultinomial(traindatass,1,1,eta*ones(numdim,1),numclass);

lda           = lda_specialize(lda0,'block');
[samples lda] = lda_posterior(lda,1000,10,100);

%testdatass   = genbars(imsize,noiselevel,numbarpermix,numgroup,numdata);
testdatass    = num2cell(1:25);
ll            = lda_predict(lda.qq0,testdatass,samples,'beta',50,1000);
lik           = meanlik(ll);
sum(exp(lik))
% blocked sampler is not great for this problem, since number of data items
% per group is relatively small.

