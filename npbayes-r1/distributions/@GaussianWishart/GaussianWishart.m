function qq0=GaussianWishart(maxeval,numdim,relprecision,degfreedom,emean,ecov);

if nargin==0
  qq0.id       = [];
  qq0.mm       = [];
  qq0.SSchol   = [];
  qq0.SSlogdet = [];
  qq0.lik      = [];
  qq0          = class(qq0,'GaussianWishart');
  return
elseif nargin==1
  qq0          = class(maxeval,'GaussianWishart');
  return
end

global DistGlobals
id = adddist;

dd           = numdim;
rr           = relprecision;
vv           = degfreedom;
mm           = emean;
SS           = ecov*vv;
SSchol       = chol(SS);
SSlogdet     = 2*sum(log(diag(SSchol)));
SSchol       = cholupdate(SSchol,mm/sqrt(rr));

maxn         = ceil((maxeval-1)/2);
ii           = repmat((1:dd)',1,maxn);
jj           = repmat(1:maxn,dd,1);

G            = zeros(2,maxn+1);
G(1,:)       = [0 cumsum(sum(log((vv-1-ii)/2+jj),1),2)];
G(2,:)       = [0 cumsum(sum(log((vv  -ii)/2+jj),1),2)] ...
               + sum(gammaln((vv+2-(1:dd))/2)-gammaln((vv+1-(1:dd))/2),2);

nn           = 0:2*(maxn+1)-1;
K            = - .5*nn*dd*log(pi) + .5*dd*log(rr./(rr+nn)) + .5*vv*SSlogdet;

qq0.id              = id;
qq0.nn              = 0;
qq0.mm              = mm;
qq0.SSchol          = SSchol;
qq0.SSlogdet        = SSlogdet;
qq0.lik             = 0;

DistGlobals{id}.dd  = dd;
DistGlobals{id}.rr  = rr;
DistGlobals{id}.vv  = vv;
DistGlobals{id}.qq0 = qq0;
DistGlobals{id}.G   = G;
DistGlobals{id}.K   = K;
DistGlobals{id}.Z   = G(:)'+K;
DistGlobals{id}.maxeval = 2*(maxn+1)-1;

qq0 = class(qq0,'GaussianWishart');

%  - .5*nn*dd*log(pi) + .5*dd*log(rr./(rr+nn)) + .5*vv*SSlogdet ...
%  + sum(gammaln((vv+nn(ones(1,dd),1)+1-ii(:,ones(1,maxeval+1)))/2),1) ...
%  - sum(gammaln((vv+1-ii)/2),1);

