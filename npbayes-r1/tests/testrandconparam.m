
numgroup = 50;
numdata = ceil(500*rand(1,numgroup));
numclass = ceil(rand(1,numgroup).*numdata);
alphaa = .1;
alphab = .1;
numiter = 400;

clear alpha enc
alpha(1) = 1;
alpha(numiter) = 0;
enc(1) = enumclass(alpha(1),numdata(1));
enc(numiter) = 0;
for ii = 2:numiter
  alpha(ii) = randconparam3(alpha(ii-1),numdata,numclass,alphaa,alphab);
  enc(ii) = enumclass(alpha(ii),numdata(1));
end

subplot(121);
plot(1:numiter,enc,'.r')

autocov = xcov(alpha,'unbiased');
mid      = length(autocov)/2+.5;
ii       = 1:100;
subplot(122);
plot(ii,autocov(mid-1+ii),'r')


