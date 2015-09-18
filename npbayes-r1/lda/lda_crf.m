% LDA sampling by gibbs sampling in chinese restaurant franchise.  
% To get new table we integrate over which class it could have
% come from then do Gibbs.

alpha    = lda.alpha;
beta     = lda.beta;
numgroup = lda.numgroup;
numclass = lda.numclass;
classqq  = lda.classqq;
classnt  = lda.classnt;
qq0      = lda.qq0;

for jj = randperm(numgroup)

  numdata  = lda.numdata(jj);
  numtable = lda.numtable(jj);
  datass   = lda.datass{jj};
  datatt   = lda.datatt{jj};
  tablecc  = lda.tablecc{jj};
  tablend  = lda.tablend{jj};

  % sample table associated with data
  for ii = randperm(numdata)
    ss                     = datass(:,ii);
    oldtt                  = datatt(ii);
    oldcc                  = tablecc(oldtt);

    % first remove data item from model
    classqq(:,oldcc)       = deldata(classqq(:,oldcc), ss);
    tablend(oldtt)         = tablend(oldtt) - 1;

    % computes conditional likelihood factors for each table
    clik                   = marglikelihood(classqq, ss);
    clik                   = clik([tablecc 1:numclass]);
    clik                   = exp(clik-max(clik)).*[tablend alpha*beta];
    clik                   = clik/sum(clik);

    % samples for a new table
    newtt                  = randmult(clik);

    % add new tables and classes if needed.
    if newtt > numtable
      newcc                = newtt - numtable;
      newtt                = numtable + 1;
      numtable             = newtt;
      tablend(newtt)       = 0;
      tablecc(newtt)       = newcc;
      classnt(jj,newcc)    = classnt(jj,newcc) + 1;
    else
      newcc                = tablecc(newtt);
    end

    % adds data item back to model
    datatt(ii)             = newtt;
    tablend(newtt)         = tablend(newtt) + 1;
    classqq(:,newcc)       = adddata(classqq(:,newcc), ss);
  end

  % remove deserted table.
  for tt = numtable:-1:1
    if tablend(tt) == 0
      numtable       = numtable - 1;
      cc             = tablecc(tt);
      classnt(jj,cc) = classnt(jj,cc) - 1;
      ii             = find(datatt > tt);
      datatt(ii)     = datatt(ii) - 1;
      tablecc(tt)    = [];
      tablend(tt)    = [];
    end
  end

  % sample class associated with each table.
  for tt = randperm(numtable)
    ss                   = datass(:,find(datatt==tt));
    oldcc                = tablecc(tt);

    % first remove table from model
    classnt(jj,oldcc)    = classnt(jj,oldcc) - 1;
    classqq(:,oldcc)     = deldata(classqq(:,oldcc), ss);
   
    % compute conditional likelihood factors for each component
    clik                 = marglikelihood(classqq, ss);
    clik                 = exp(clik-max(clik)).*beta;
    clik                 = clik/sum(clik);

    % samples for a new class
    newcc                = randmult(clik);

    % adds table back to model
    tablecc(tt)          = newcc;
    classqq(:,newcc)     = adddata(classqq(:,newcc), ss);
    classnt(jj,newcc)    = classnt(jj,newcc) + 1;
  end

  lda.numtable(jj) = numtable;
  lda.datatt{jj}   = datatt;
  lda.tablecc{jj}  = tablecc;
  lda.tablend{jj}  = tablend;
end

lda.classqq  = classqq;
lda.classnt  = classnt;
lda.type     = 'crf';
