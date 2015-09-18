function incmaxeval(id,maxeval);

global DistGlobals

glob = DistGlobals{id};

if glob.maxeval<maxeval
  maxn0   = (glob.maxeval-1)/2;
  maxn    = ceil((maxeval-1)/2);

  dd      = glob.dd;
  rr      = glob.rr;
  vv      = glob.vv;

  nn      = maxn0+1:maxn;
  ii      = repmat((1:dd)',1,maxn-maxn0);
  jj      = repmat(maxn0+1:maxn,dd,1);

  G       = glob.G;
  G(1,nn+1) = G(1,maxn0+1)+cumsum(sum(log((vv-1-ii)/2+jj),1),2);
  G(2,nn+1) = G(2,maxn0+1)+cumsum(sum(log((vv  -ii)/2+jj),1),2);

  nn      = 2*(maxn0+1):2*(maxn+1)-1;
  K       = glob.K;
  K(nn+1) = - .5*nn*dd*log(pi) + .5*dd*log(rr./(rr+nn)) ...
            + .5*vv*glob.qq0.SSlogdet;

  DistGlobals{id}.G = G;
  DistGlobals{id}.K = K;
  DistGlobals{id}.Z = G(:)'+K;
  DistGlobals{id}.maxeval = 2*(maxn+1)-1;

end
