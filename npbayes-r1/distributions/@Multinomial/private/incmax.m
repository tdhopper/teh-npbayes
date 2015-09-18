function glob = incmax(glob,qq);

ni = max(qq.ni,[],2);
for ii = find(glob.maxi < ni)'
  eta              = glob.eta(ii);
  maxi             = glob.maxi(ii);
  maxi1            = ni(ii);
  nk               = maxi+1:maxi1;
  glob.Zi(ii,nk+1) = glob.Zi(ii,maxi+1) + cumsum(log(eta+nk-1));
  glob.maxi(ii)    = maxi1;
end

nn = max(qq.nn,[],2);
if glob.maxs < nn
  sumeta              = glob.sumeta;
  maxs                = glob.maxs;
  maxs1               = nn;
  nk                  = maxs+1:maxs1;
  glob.ZZ(nk+1)       = glob.ZZ(maxs+1) + cumsum(log(sumeta+nk-1));
  glob.maxs           = maxs1;
end

