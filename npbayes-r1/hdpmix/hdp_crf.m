% hierarchical DP sampling by gibbs sampling in chinese restaurant
% franchise.  To get new table we integrate over which class it could have
% come from then do Gibbs.

gamma    = hdp.gamma;
alpha    = hdp.alpha;
numgroup = hdp.numgroup;
numclass = hdp.numclass;
classqq  = hdp.classqq;
classnt  = hdp.classnt;
totalnt  = hdp.totalnt;
qq0      = hdp.qq0;

% adds an additional unrepresented class for convenience.
classqq(:,numclass+1) = qq0;
for jj = randperm(numgroup)

  numdata  = hdp.numdata(jj);
  numtable = hdp.numtable(jj);
  datass   = hdp.datass{jj};
  datatt   = hdp.datatt{jj};
  tablecc  = hdp.tablecc{jj};
  tablend  = hdp.tablend{jj};

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
    clik                   = clik([tablecc 1:numclass+1]);
    weights                = totalnt;
    weights(numclass+1)    = gamma;
    weights                = [tablend alpha*weights/sum(weights)];
    clik                   = exp(clik-max(clik)).*weights;
    clik                   = clik/sum(clik);

    % samples for a new table
    newtt                  = randmult(clik);

    % adds new table if needed.
    if newtt > numtable
      newcc                = newtt - numtable;
      newtt                = numtable + 1;
      numtable             = newtt;
      % adds new class if needed
      if newcc > numclass
        numclass           = newcc;
        classqq(:,newcc+1) = hdp.qq0;
        classnt(:,newcc)   = 0;
        totalnt(:,newcc)   = 0;
      end
      tablend(newtt)       = 0;
      tablecc(newtt)       = newcc;
      classnt(jj,newcc)    = classnt(jj,newcc) + 1;
      totalnt(1,newcc)     = totalnt(1,newcc)  + 1;
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
      totalnt(1,cc)  = totalnt(1,cc)  - 1;
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
    classqq(:,oldcc)     = deldata(classqq(:,oldcc), ss);
    classnt(jj,oldcc)    = classnt(jj,oldcc) - 1;
    totalnt(1,oldcc)     = totalnt(1,oldcc)  - 1;
   
    % compute conditional likelihood factors for each k
    clik                 = marglikelihood(classqq, ss);
    weights              = totalnt;
    weights(numclass+1)  = gamma;
    clik                 = exp(clik-max(clik)).*weights;
    clik                 = clik/sum(clik);

    % samples for a new class
    newcc                = randmult(clik);

    % adds new class if neccessary.
    if newcc > numclass
      numclass           = newcc;
      classqq(:,newcc+1) = 0;
      classnt(:,newcc)   = 0;
      totalnt(:,newcc)   = 0;
    end

    % adds table back to model
    tablecc(tt)          = newcc;
    classqq(:,newcc)     = adddata(classqq(:,newcc), ss);
    classnt(jj,newcc)    = classnt(jj,newcc) + 1;
    totalnt(1,newcc)     = totalnt(1,newcc)  + 1;
  end

  hdp.numtable(jj) = numtable;
  hdp.datatt{jj}   = datatt;
  hdp.tablecc{jj}  = tablecc;
  hdp.tablend{jj}  = tablend;
end
classqq(:,numclass+1) = [];

% remove empty class
for cc = numclass:-1:1
  if totalnt(cc) == 0
    numclass              = numclass - 1;
    classqq(:,cc)         = [];
    classnt(:,cc)         = [];
    totalnt(cc)           = [];
    for jj = 1:numgroup
      tt                  = find(hdp.tablecc{jj} > cc);
      hdp.tablecc{jj}(tt) = hdp.tablecc{jj}(tt) - 1;
    end
  end
end

hdp.numclass = numclass;
hdp.classqq  = classqq;
hdp.classnt  = classnt;
hdp.totalnt  = totalnt;
