function lda = lda(datass,alphaa,alphab,eta,initcc,varargin);

lda = lda_init(datass,alphaa,alphab,Multinomial(eta),initcc,varargin{:});

