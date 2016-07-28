function C = CONFIG()
% Return local configuration variables.
% This file shouldn't be version controled.
%
C = containers.Map();
C('rnaseq pipeline path') = '/cs/bd/RNAseq_pipeline';