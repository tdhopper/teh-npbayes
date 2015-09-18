function hdp = hdp_specialize(hdp,hdptype,range);

switch hdptype
case 'beta'
  hdp.type = 'beta';
case 'crf'
  hdp = specialize_crf(hdp_standardize(hdp));
  hdp.type = 'crf';
case 'block'
  hdp         = hdp_standardize(hdp);
  hdp.classss = double(hdp.classqq);
  hdp.eta     = parameters(hdp.qq0);
  hdp.range   = range;
  hdp.classqq = [];
  hdp.type = 'block';
case 'std'
otherwise
  error('Unknown HDP type');
end

function hdp = specialize_crf(hdp);
numgroup = hdp.numgroup;
numclass = hdp.numclass;
datacc   = hdp.datacc;
beta     = hdp.beta;
alpha    = hdp.alpha;
totalnt  = hdp.totalnt - sum(hdp.classnt,1);

numtable = zeros(1,numgroup);
datatt   = hdp.datacc;
tablecc  = cell(numgroup,1);
tablend  = cell(numgroup,1);
classnt  = zeros(numgroup, numclass);

for jj = 1:numgroup
  datatt{jj} = datacc{jj};
  for cc = 1:numclass
    iindex = find(datacc{jj}==cc);
    weight = alpha*beta(cc);
    [tt nt] = randcrp(weight, length(iindex));
    datatt{jj}(iindex)  = tt + numtable(jj);
    tindex              = numtable(jj)+(1:nt);
    tablecc{jj}(tindex) = cc;
    tablend{jj}(tindex) = sparse(ones(1,length(tt)),tt,ones(1,length(tt)));
    classnt(jj,cc)      = nt;
    numtable(jj)        = numtable(jj) + nt;
  end
  tablend{jj}           = full(tablend{jj});
end

hdp.datatt   = datatt;
hdp.tablecc  = tablecc;
hdp.tablend  = tablend;
hdp.numtable = numtable;
hdp.classnt  = classnt;
hdp.totalnt  = totalnt + sum(classnt,1);
hdp.beta     = [];
hdp.datacc   = [];
hdp.classnd  = [];


