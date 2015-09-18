function lda = lda_specialize(lda,ldatype);

switch ldatype
case 'beta'
  lda = lda_standardize(lda);
  lda.type = 'beta';
case 'crf'
  lda = specialize_crf(lda_standardize(lda));
  lda.type = 'crf';
case 'block'
  lda          = lda_standardize(lda);
  lda.classss  = double(lda.classqq);
  lda.eta      = parameters(lda.qq0);
  lda.classqq  = [];
  lda.type = 'block';
otherwise
  error('Unknown LDA type');
end

function lda = specialize_crf(lda);
numgroup = lda.numgroup;
numclass = lda.numclass;
datacc   = lda.datacc;
alpha    = lda.alpha;
beta     = lda.beta;

numtable = zeros(1,numgroup);
datatt   = lda.datacc;
tablecc  = cell(numgroup,1);
tablend  = cell(numgroup,1);
classnt  = zeros(numgroup, numclass);

for jj = 1:numgroup
  datatt{jj}            = datacc{jj};
  for cc = 1:numclass
    iindex              = find(datacc{jj}==cc);
    weight              = alpha*beta(cc);
    [tt nt]             = randcrp(weight, length(iindex));
    datatt{jj}(iindex)  = tt + numtable(jj);
    tindex              = numtable(jj)+(1:nt);
    tablecc{jj}(tindex) = cc;
    tablend{jj}(tindex) = sparse(ones(1,length(tt)),tt,ones(1,length(tt)));
    classnt(jj,cc)      = nt;
    numtable(jj)        = numtable(jj) + nt;
  end
  tablend{jj}           = full(tablend{jj});
end

lda.numtable = numtable;
lda.datatt   = datatt;
lda.tablecc  = tablecc;
lda.tablend  = tablend;
lda.classnt  = classnt;
lda.classnd  = [];
lda.datacc   = [];
