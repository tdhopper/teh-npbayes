function hdp = hdp_standardize(hdp);

switch hdp.type
case {'std', 'beta'}
case 'crf'
  hdp.classnd             = zeros(hdp.numgroup,hdp.numclass);
  for jj = 1:hdp.numgroup
    hdp.datacc{jj}        = hdp.tablecc{jj}(hdp.datatt{jj});
    hdp.classnd(jj,:)     = sparse(ones(1,hdp.numtable(jj)),hdp.tablecc{jj},...
                            hdp.tablend{jj},1,hdp.numclass);
  end
  weights                 = hdp.totalnt;
  weights(hdp.numclass+1) = hdp.gamma;
  hdp.beta                = randdir(weights); 
  hdp.datatt              = [];
  hdp.tablecc             = [];
  hdp.tablend             = [];
  hdp.numtable            = [];
case 'block'
  hdp.classqq             = hdp.qq0(:,ones(1,hdp.numclass));
  hdp.classqq(:,:)        = hdp.classss;
  hdp.classss             = [];
  hdp.range               = [];
  hdp.eta                 = [];
otherwise
  error('Unknown HDP type');
end
hdp.type = 'std';

