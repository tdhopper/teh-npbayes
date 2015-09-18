function qq0 = Multinomial(eta);

if nargin==0
  qq0.id  = [];
  qq0.nn  = [];
  qq0.ni  = [];
  qq0.lik = [];
  qq0     = class(qq0,'Multinomial');
  return
%elseif isa(eta,'Multinomial');
%  qq0    = eta;
%  return
end

global DistGlobals
id = adddist;

dd      = size(eta,1);

qq0.id  = id;
qq0.nn  = 0;
qq0.ni  = zeros(dd,1);
qq0.lik = 0;
qq0     = class(qq0,'Multinomial');

numz    = 3;
nk      = 0:numz-1;
sumeta  = sum(eta);
Zi      = sparse(cumsum([zeros(dd,1) ...
          log(eta(:,ones(1,numz)) + nk(ones(1,dd),:))],2));
ZZ      = [0 cumsum(log(sumeta + nk))];

DistGlobals{id}.dd     = dd;
DistGlobals{id}.eta    = eta;
DistGlobals{id}.sumeta = sumeta;
DistGlobals{id}.Zi     = Zi;
DistGlobals{id}.ZZ     = ZZ;
DistGlobals{id}.maxi   = (numz)*ones(dd,1);
DistGlobals{id}.maxs   = numz;

