% HDP by gibbs sampling, especially for multinomial components, using range
% limiting auxiliary variables

gamma     = hdp.gamma;
alpha     = hdp.alpha;
eta       = hdp.eta;
beta      = hdp.beta;
datacc    = hdp.datacc;

numgroup  = hdp.numgroup;
numclass  = hdp.numclass;
numdim    = size(eta,1);

% figures out maximum value of datacc.
maxcc  = 0;
for jj = 1:numgroup
  maxcc   = max(maxcc, max(datacc{jj}));
end

% generates range limiting auxiliary variable.  The maximum value of datacc
% now has to lie in the range lowlim+1:upplim.
AA        = randmult(ones(1,hdp.range+1))-1;
upplim    = maxcc + AA;
lowlim    = max(0, upplim - hdp.range - 1);

% adds new classes if necessary
classss   = cat(2,hdp.classss, zeros(numdim,upplim-numclass)); 
classnd   = cat(2,hdp.classnd, zeros(numgroup,upplim-numclass));
totalnt   = cat(2,hdp.totalnt, zeros(1,upplim-numclass));
classnt   = cat(2,hdp.classnt, zeros(numgroup,upplim-numclass));

% this is now the number of classes represented.
numclass  = max(numclass,upplim);

% sample the multinomial weights only for required classes (1:upplim)
KK        = 1:upplim;
beta      = [beta(1:end-1) beta(end)*randstick(gamma,hdp.range)];
beta      = beta(1,KK);
pi        = randdir(classnd(:,KK)+alpha*beta(ones(numgroup,1),KK),2);
theta     = randdir(classss(:,KK)+eta(:,ones(1,upplim)),1);

% remove data items from totalnt, classnd and classss.  totalnt and classss
% includes information from other groups which we have conditioned on, so
% cannot reset to zero.
totalnt      = totalnt - sum(classnt,1);
classnd(:)   = 0;
for jj = 1:numgroup
  % remove data items from structures
  numdata    = hdp.numdata(jj);
  datass     = hdp.datass{jj};
  datasc     = sparse(datass,datacc{jj},ones(1,numdata),numdim,numclass);
  [i,j,sc]   = find(datasc(:));
  classss(i) = classss(i) - sc;
end

% Now sample for datacc.  datacc has probabilities given by the 
% responsibilities for each data item, with mixing proportions given 
% in pi(jj,:), and class cc being multinomial with weights theta(:,cc),
% subject to the condition that the maximum value of datacc lies in 
% lowlim+1:upplim.  We can obtain a sample from this using a forward-
% backward type algorithm.  

% data structures used for forward-backward type sampling.
uppcc              = cell(1,numgroup);
KK                 = 1:lowlim;
mesg               = 1;

for jj = 1:numgroup
  numdata          = hdp.numdata(jj);
  datass           = hdp.datass{jj};

  % compute probability of choosing classes in range 1:upplim
  allweights       = theta(datass,:) .* pi(jj*ones(1,numdata),:);

  % compute probabilities for each datacc.
  % mesg(i) is relative probability of all data items before item i choosing
  % classes in range 1:lowlim (relative to range 1:upplim).
  % prop is relative probability that at least one item before i chose a 
  % class in range lowlim+1:upplim.
  mesg             = cumprod([mesg;sum(allweights(:,KK),2)./sum(allweights,2)]);
  prop             = 1-mesg(1:numdata);
  uppweights       = allweights;
  uppweights(:,KK) = uppweights(:,KK).*prop(:,ones(1,lowlim));

  % sample class associate with each data item for both cases
  datacc{jj}       = randmult(allweights,2)';
  uppcc{jj}        = randmult(uppweights,2)';

  % pass this onto next group.  Basically we string all data items in all 
  % groups into one sequence.
  mesg           = mesg(numdata+1);

  if (mesg == 0) | (jj==numgroup)
    % if the probability is zero that all data items up to now will choose
    % class in range 1:lowlim, we can bail out and just sample without the
    % lower limit consideration (upper limit still holds).
    mm = 0;
    for j2 = numgroup:-1:jj+1
      numdata    = hdp.numdata(j2);
      datass     = hdp.datass{j2};

      % sample data items without worrying about lower limit effect on max value
      allweights = theta(datass,:) .* pi(j2*ones(1,numdata),:);
      datacc{j2} = randmult(allweights,2)';
      mm         = max(mm,max(datacc{j2}));
    end
    if mm <= lowlim
      % if all data items after class jj chose class in range 1:lowlim, we 
      % find the last data item to have chosen a class in range lowlim+1:upplim
      % using uppcc (the probability is one that at least one exists).  Then
      % get samples from uppcc for items after this one, and from datacc from
      % those before.
      for j2 = jj:-1:1
        ii       = max(find(uppcc{j2} > lowlim));
        if ~isempty(ii)
          datacc{j2}(ii:end) = uppcc{j2}(ii:end);
          break;
        else
          datacc{j2} = uppcc{j2};
        end
      end
    end
    break
  end
end

% update data structures
for jj = 1:numgroup
  datasc        = sparse(hdp.datass{jj},datacc{jj},ones(1,hdp.numdata(jj)),...
                  numdim,numclass);
  [i,j,sc]      = find(datasc(:));
  classss(i)    = classss(i) + sc;
  classnd(jj,:) = sum(datasc,1);
end

% sample number of tables
classnt         = randnumtable(alpha*beta(ones(1,numgroup),:),classnd);
totalnt         = totalnt + sum(classnt,1);

% remove empty classes
for cc = numclass:-1:1
  if totalnt(cc) == 0
    numclass         = numclass - 1;
    classss(:,cc)    = [];
    classnd(:,cc)    = [];
    classnt(:,cc)    = [];
    totalnt(cc)      = [];
    for jj = 1:numgroup
      ii             = find(datacc{jj} > cc);
      datacc{jj}(ii) = datacc{jj}(ii) - 1;
    end 
  end
end

% update beta weights
weights               = totalnt;
weights(1,numclass+1) = gamma;
beta                  = randdir(weights);

hdp.numclass = numclass;
hdp.classss  = classss;
hdp.classnd  = classnd;
hdp.classnt  = classnt;
hdp.totalnt  = totalnt;
hdp.datacc   = datacc;
hdp.beta     = beta;
