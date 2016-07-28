function all = execute_rna_pipeline(abspath)
% Executes Yoav Voiheck's RNA pipeline on a collection of samples.
% Output is written in each sample folder (see Yoav's documentation).
% A matrix of genesXsamples is called "all" and placed in the abspath.
% A folder with bedgraph tracks is generated in abspath.
%
% abspath - root directory, containing a directory per sample.
%

PPATH = '/cs/bd/RNAseq_pipeline';
GP = load([PPATH,'/GP']);
GP = GP.GP;
fs = dir(abspath);
all = struct();
all.data = [];
all.header = {};

if ~exist([abspath,'/tracks/'],'dir')
    mkdir([abspath,'/tracks/']);
end

parfor i = 1:length(fs)
    tic
    try
        if fs(i).name(1)=='.' || ~fs(i).isdir, continue, end
        fprintf('working on %s...\n', fs(i).name);
        fname = [abspath,'/',fs(i).name,'/gene_exp']
        if ~exist(fname, 'file')
            comm = sprintf('python %s/pipeline.py -g %s/bowtie_index/s288C_110203 -z -s %s -p 8', ...
                           PPATH, PPATH, [abspath,'/',fs(i).name]);
            system(comm);
        end
        
        fname = [abspath,'/',fs(i).name,'/prof_u'];
        if ~exist(fname,'file'), gunzip([fname,'.gz']); end
        prof2track(fopen(fname), abspath, fs(i).name, GP)
        if ~exist([fname,'.gz'],'file'), 
            system(sprintf('gzip %s', fname));
        end
        system(sprintf('rm %s', fname));
    catch e
        disp(e)
    end
    fprintf('Done with %s (elapsed %.1f minutes)\n', fname, toc/60);
end

fprintf('merging results...\n');
for i = 1:length(fs)
    try
        if fs(i).name(1)=='.' || ~fs(i).isdir, continue, end
        fname = [abspath,'/',fs(i).name,'/gene_exp'];
        sample = importdata(fname);
        all.data = [all.data, sample.data(:,5)];
        all.header = {all.header{:}, fs(i).name};
    catch e
        disp(e)
        fprintf('collected %s\n', fname);
    end
end
save([abspath, '/all.mat'], 'all', 'GP')

end


function [] = prof2track(fin, abspath, name, GP)
C = fscanf(fin,'%f');
p = cell(16,1); % Creating a cell array for the chromosomes
index = 0;
for c=1:16
    p{c} = zeros(GP.chr_len(c), 2);
    p{c}(:,1) = C((index+1):(index+GP.chr_len(c)));
    index = index + GP.chr_len(c);
    p{c}(:,2) = C((index+1):(index+GP.chr_len(c)));
    index = index + GP.chr_len(c);
end


%writing a bedgraph file
fout = fopen([abspath,'/tracks/', name, '.bedgraph'], 'w');
hdr = 'track type=bedGraph name="%s" description="" visibility=full color=200,100,0 altColor=0,100,200 priority=20\n';
fprintf(fout, hdr, name);
frmt = 'chr%s\t%i\t%i\t%.2f\n';
for ci  = 1:length(p)
    cdata = [];
    for strand = 1:2
        sidx = find(p{ci}(:,strand));
        sgn = (-1).^(strand+1);
        cdata = [cdata; ci*ones(size(sidx)), sidx-1, sidx, sgn*p{ci}(sidx,strand)];
    end 
    %sort and print to file
    [~,ord] = sort(cdata(:,2));
    cdata = cdata(ord,:);
    for i = 1:size(cdata,1)
        fprintf(fout, frmt, num2roman(cdata(i,1)), cdata(i,2:end));
    end
end
fclose(fout);
end