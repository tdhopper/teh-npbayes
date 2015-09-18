function hdp = hdp_init(datass,gammaa,gammab,alphaa,alphab,qq0,initcc,initpost);

hdp.gammaa = gammaa;
hdp.gammab = gammab;
hdp.gamma  = gammaa/gammab;
hdp.alphaa = alphaa;
hdp.alphab = alphab;
hdp.alpha  = alphaa/alphab;

hdp.numgroup = length(datass);
hdp.datass = datass;
for jj = 1:hdp.numgroup
  hdp.numdata(jj) = size(datass{jj},2);
end

if ischar(initcc) & strcmp(initcc,'1permix')
  hdp.numclass = hdp.numgroup;
  hdp.datacc   = cell(hdp.numgroup,1);
  for jj = 1:hdp.numgroup
    hdp.datacc{jj} = jj(1,ones(1,hdp.numdata(jj)));
  end
elseif iscell(initcc)
  hdp.datacc   = initcc;
  hdp.numclass = 0;
  for jj = 1:hdp.numgroup
    hdp.numclass = max(hdp.numclass,max(hdp.datacc{jj}));
  end
else
  hdp.numclass = initcc;
  hdp.datacc   = cell(hdp.numgroup,1);
  cc = rem(1:max(hdp.numdata),hdp.numclass)+1;
  for jj = 1:hdp.numgroup
    hdp.datacc{jj} = cc(randperm(hdp.numdata(jj)));
  end
end

hdp.qq0     = qq0;
if exist('initpost') 
  hdp.gamma    = initpost.gamma;
  hdp.alpha    = initpost.alpha;
  hdp.classqq  = initpost.classqq;
  hdp.totalnt  = initpost.totalnt;
  postnc       = length(hdp.totalnt);
  if hdp.numclass > postnc
    hdp.totalnt(:,hdp.numclass)  = 0;
    hdp.classqq(:,postnc+1:hdp.numclass) = qq0(:,ones(1,hdp.numclass-postnc));
  else 
    hdp.numclass = postnc;
  end
else
  hdp.classqq = qq0(:,ones(1,hdp.numclass));
  hdp.totalnt = zeros(1,hdp.numclass);
end

hdp.classnd = zeros(hdp.numgroup, hdp.numclass);
prevtime = 0;
tic;
for jj = 1:hdp.numgroup
  for cc = 1:hdp.numclass
    ii = find(hdp.datacc{jj}==cc);
    hdp.classqq(:,cc)  = adddata(hdp.classqq(:,cc),hdp.datass{jj}(ii));
    hdp.classnd(jj,cc) = length(ii);
    if toc - prevtime > 1
      fprintf(1,'Init: group %d class %d     \r',jj,cc);
      prevtime = toc;
    end
  end
end
fprintf(1,'                            \r',jj,cc);

hdp.classnt             = ones(hdp.numgroup, hdp.numclass);
hdp.totalnt             = hdp.totalnt + sum(hdp.classnt,1);
weights                 = hdp.totalnt;
weights(hdp.numclass+1) = hdp.gamma;
hdp.beta                = randdir(weights);

hdp.type                = 'beta';
