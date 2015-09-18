function ww = sample(qq);

global DistGlobals
eta = DistGlobals{qq.id}.eta;

numq = size(qq.ni,2);
ww = randdir(eta(:,ones(1,numq)) + qq.ni,1);
