function ss = map(qq);

global DistGlobals;
glob = DistGlobals{qq.id};

numq = size(qq.ni,2);
ss   = glob.eta(:,ones(1,numq)) + qq.ni;
sums = sum(ss,1);
ss   = ss./sums(ones(1,glob.dd),:);
