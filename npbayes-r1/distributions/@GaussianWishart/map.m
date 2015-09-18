function [mu,sigma] = map(qq,nn);

global DistGlobals
id   = qq(1).id;
glob = DistGlobals{id};

num = length(nn);

dd    = glob.dd;
rr    = glob.rr + nn;
mu    = cat(2,qq.mm)./rr(ones(dd,1),:);
sigma = zeros(dd,dd,num);
for ii = 1:num
  SSchol        = cholupdate(qq(ii).SSchol,qq(ii).mm/sqrt(rr(ii)),'-');
  sigma(:,:,ii) = SSchol'*SSchol/(glob.vv+nn(ii));
end
