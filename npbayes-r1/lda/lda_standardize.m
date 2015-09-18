function lda = lda_standardize(lda);

switch lda.type
case {'beta','std'}
case 'crf'
  lda.classnd         = zeros(lda.numgroup,lda.numclass);
  for jj = 1:lda.numgroup
    lda.datacc{jj}    = lda.tablecc{jj}(lda.datatt{jj});
    lda.classnd(jj,:) = sparse(ones(1,lda.numtable(jj)),lda.tablecc{jj},...
                        lda.tablend{jj},1,lda.numclass);
  end
  lda.numtable        = [];
  lda.datatt          = [];
  lda.tablecc         = [];
  lda.tablend         = [];
  lda.classnt         = [];
case 'block'
  lda.classqq         = lda.qq0(:,ones(1,lda.numclass));
  lda.classqq(:,:)    = lda.classss;
  lda.classss         = [];
  lda.eta             = [];
otherwise
  error('Unknown LDA type');
end
lda.type = 'std';
