% Prior updates 

totalnt = sum(hdp.classnt,2)';
hdp.gamma = randconparam(hdp.gamma,sum(totalnt),hdp.numclass,...
            hdp.gammaa,hdp.gammab,10);
hdp.alpha = randconparam(hdp.alpha,hdp.numdata,totalnt,hdp.alphaa,hdp.alphab);

