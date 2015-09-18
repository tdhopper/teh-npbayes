# Yee Whye Teh's Nonparametric Bayesian Mixture Models Code

Master branch of this repository contains Yee Whye Teh's code [Nonparametric Bayesian Mixture Models - release 2.1](http://www.stats.ox.ac.uk/~teh/research/npbayes/npbayes-r21.tgz) and [Nonparametric Bayesian Mixture Models - release 1](http://www.stats.ox.ac.uk/~teh/research/npbayes/npbayes-r1.tgz) which I download from [his website](http://www.stats.ox.ac.uk/~teh/software.html) on 2015-09-18. I am copying it here unmodified for accessibility.

## Nonparametric Bayesian Mixture Models - release 1 README

```
This code base is for people interested in trying out various
nonparametric Bayesian models on some simple data sets.

It is implemented in MATLAB so by definition cannot be very efficient.
This is because it is for people to muck around with and experiment.
That said, the code is reasonably efficient.  I have run it on document
corpora of half a million to a million words.

The code is reasonably modular and documented by README files in each
section.  As I get time I will release more documentation (just little
technical notes) and more code.

I have implemented LDA, HDP mixtures, and DP mixtures, using a variety
of sampling schemes, including Chinese restaurant process/franchise, Beta
auxiliary variable method (both in HDP tech report), and a range limiting
blocked Gibbs sampler (not yet published) especially for multinomials
(to take advantage of vectorization in matlab).

Each mixture model can use a variety of types of components.  Currently
I only have Gaussians and multinomials, both with conjugate priors.
Stay tuned.


Implementations
===============
hdpmix		Hierarchical Dirichlet process mixtures.
		Uses CRF, beta auxiliary variables, and range limiting
		blocked Gibbs (only for multinomials)

lda		Latent Dirichlet allocation.
		Uses CRP, beta auxiliary variables, and blocked Gibbs
		(only for multinomials).

dpmix		Dirichlet process mixtures.
		Uses CRP, beta auxiliary variables, and k-means.


Pre-made Mixtures
=================
dpGaussianWishart
	DP mixture of Gaussians with Gaussian-Wishart prior.

hdpMultinoimal
	HDP mixture of multinomials with Dirichlet prior.

ldaMultinomial
	LDA.


Tests/Demos
===========
testbars
	Demonstrates HDP mixture and LDA trained on bars problem.

testdpmixGaussianWishart
	Demonstrates DP mixture trained on an actual mixture of Gaussians.

testpredict
	Tests the estimated predictive likelihood given by HDP/LDA.

testrandconparam
	Tests the update scheme for the concentration parameters.


===========================================================================
(C) Copyright 2004, Yee Whye Teh (ywteh -at- eecs -dot- berkeley -dot- edu)

http://www.cs.berkeley.edu/~ywteh

Permission is granted for anyone to copy, use, or modify these
programs and accompanying documents for purposes of research or
education, provided this copyright notice is retained, and note is
made of any changes that have been made.

These programs and documents are distributed without any warranty,
express or implied.  As the programs were written for research
purposes only, they have not been tested to the degree that would be
advisable in any important application.  All use of these programs is
entirely at the user's own risk.
```

## Nonparametric Bayesian Mixture Models - release 2.1 README

```
This release #2 is a totally new code base and has little to do with
the previous release.  Release #2.1 is updated to fix some bugs that
were present in release #2.

This package implements hierarchical Dirichlet process (HDP)
mixture models.  It handles the general case where the Dirichlet
processes (DPs) can be arranged according to any tree structure, with
observations associated with any DP.  We assume the base distribution is
conjugate to the observation distributions and we integrate out mixture
component parameters.  We have currently only implemented multinomial
observations with Dirichlet base distributions, though this should be
easily generalized to any distribution over observations along with its
conjugate prior.  Check back soon.

It is implemented in matlab and C, with the main engine in C with a
mex interface.  It is much more efficient than the previous release.
The sampling scheme I've included here is the auxiliary variable method.
The code is reasonably modular and documented by README files in each
section.  The code was tested on matlab 6.5 under red hat linux 9.0 and
matlab 7.0 under mac os x.

I have a small demo called testbars which shows that the code works!
Please run make in matlab to compile the mex files.  And everytime you
would like to run the code run initpath first, which simply adds the
relevant subdirectories into the matlab path.

In the future: other sampling schemes, other likelihood distributions,
a finite version, and the infinite HMM (code is there, need clean up).

===========================================================================
(C) Copyright 2004, Yee Whye Teh (ywteh -at- eecs -dot- berkeley -dot- edu)

http://www.cs.berkeley.edu/~ywteh

Permission is granted for anyone to copy, use, or modify these
programs and accompanying documents for purposes of research or
education, provided this copyright notice is retained, and note is
made of any changes that have been made.

These programs and documents are distributed without any warranty,
express or implied.  As the programs were written for research
purposes only, they have not been tested to the degree that would be
advisable in any important application.  All use of these programs is
entirely at the user's own risk.
```