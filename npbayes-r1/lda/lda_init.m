function lda = lda_init(datass,alphaa,alphab,qq0,initcc,initpost);

lda.alphaa = alphaa;
lda.alphab = alphab;
lda.alpha  = alphaa/alphab;

lda.numgroup = length(datass);
lda.datass = datass;
for jj = 1:lda.numgroup
  lda.numdata(jj) = size(datass{jj},2);
end

if iscell(initcc)
  lda.datacc   = initcc;
  lda.numclass = 0;
  for jj = 1:lda.numgroup
    lda.numclass = max(lda.numclass,max(lda.datacc{jj}));
  end
else
  lda.numclass = initcc;
  lda.datacc   = cell(lda.numgroup,1);
  cc = rem(1:max(lda.numdata),lda.numclass)+1;
  for jj = 1:lda.numgroup
    lda.datacc{jj} = cc(randperm(lda.numdata(jj)));
  end
end

if exist('initpost')
  lda.alpha    = initpost.alpha;
  lda.classqq  = initpost.classqq;
else
  lda.classqq = qq0(:,ones(1,lda.numclass));
end

lda.qq0     = qq0;
lda.classnd = zeros(lda.numgroup, lda.numclass);
for jj = 1:lda.numgroup
  for cc = 1:lda.numclass
    ii = find(lda.datacc{jj}==cc);
    lda.classqq(:,cc)  = adddata(lda.classqq(:,cc),lda.datass{jj}(:,ii));
    lda.classnd(jj,cc) = length(ii);
  end
end

lda.beta = ones(1,lda.numclass)/lda.numclass;
lda.type = 'beta';

