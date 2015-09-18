% bars data.  starts with number of class = number of dimensions
cleardist
set(gcf,'doublebuffer','on');

doldablock = 25;
doldabeta  = 1;
doldacrf   = 1;
dohdpblock = 25;
dohdpbeta  = 1;
dohdpcrf   = 1;
numiter    = 5000;
repiter    = 1;

% description of generated data set.
imsize       = 5;
noiselevel   = .01;
numbarpermix = [0 ones(1,3)]/3;
numgroup     = 40;
numdata      = 50;

datass       = genbars(imsize,noiselevel,numbarpermix,numgroup,numdata);

numdim       = imsize^2;
numclass     = imsize*2+2; 

eta  = 1/imsize;
lda0 = ldaMultinomial(datass, 1, 1, eta*ones(numdim,1), numclass);
hdp0 = lda2hdp(lda0,1,1);
hdp0.range = 5;

ldablock = lda_specialize(lda0,'block');
ldabeta  = lda_specialize(lda0,'beta');
ldacrf   = lda_specialize(lda0,'crf');
hdpblock = hdp_specialize(hdp0,'block',5);
hdpbeta  = hdp_specialize(hdp0,'beta');
hdpcrf   = hdp_specialize(hdp0,'crf');

colormap gray

for iter=1:numiter

  if doldablock > 0
    ldablock = lda_iterateconparam(ldablock,doldablock);
    lda = lda_standardize(ldablock);
    mysubplot(6,1,1,.05);
    imlayout(1-map(lda.classqq),[imsize imsize 1 lda.numclass],1-[1/imsize 0]);
    title(['ldaMultinomial\_block: ' num2str(toc/doldablock)]);
    drawnow;
  end

  if doldabeta > 0
    ldabeta = lda_iterateconparam(ldabeta,doldabeta);
    lda = lda_standardize(ldabeta);
    mysubplot(6,1,2,.05);
    imlayout(1-map(lda.classqq),[imsize imsize 1 lda.numclass],1-[1/imsize 0]);
    title(['lda\_block: ' num2str(toc/doldabeta)]);
    drawnow;
  end

  if doldacrf > 0
    ldacrf = lda_iterateconparam(ldacrf,doldacrf);
    lda = lda_standardize(ldacrf);
    mysubplot(6,1,3,.05);
    imlayout(1-map(lda.classqq),[imsize imsize 1 lda.numclass],1-[1/imsize 0]);
    title(['lda\_block: ' num2str(toc/doldacrf)]);
    drawnow;
  end

  if dohdpblock > 0
    hdpblock = hdp_iterateconparam(hdpblock,dohdpblock);
    hdp = hdp_standardize(hdpblock);
    mysubplot(6,1,4,.05);
    imlayout(1-map(hdp.classqq),[imsize imsize 1 hdp.numclass],1-[1/imsize 0]);
    title(['hdpMultinomial\_block: ' num2str(toc/dohdpblock)]);
    drawnow;
  end

  if dohdpbeta > 0
    hdpbeta = hdp_iterateconparam(hdpbeta,dohdpbeta);
    hdp = hdp_standardize(hdpbeta);
    mysubplot(6,1,5,.05);
    imlayout(1-map(hdp.classqq),[imsize imsize 1 hdp.numclass],1-[1/imsize 0]);
    title(['hdp\_beta: ' num2str(toc/dohdpbeta)]);
    drawnow;
  end

  if dohdpcrf > 0
    hdpcrf = hdp_iterateconparam(hdpcrf,dohdpcrf);
    hdp = hdp_standardize(hdpcrf);
    mysubplot(6,1,6,.05);
    imlayout(1-map(hdp.classqq),[imsize imsize 1 hdp.numclass],1-[1/imsize 0]);
    title(['hdp\_crf: ' num2str(toc/dohdpcrf)]);
    drawnow;
  end




end


