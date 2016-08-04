function C = CONFIG()
% Return local configuration variables.
% This file shouldn't be version controled.
%
C = containers.Map();
C('rnaseq pipeline path') = '/cs/bd/RNAseq_pipeline';
C('saccer3_chrlens_path') = '~/Dropbox/genomic_data/saccer3_chrlens';