%% parse LoQate DB (in code: variable name is mayadb,
% obtained simply from reading the file on website)
load ~/Dropbox/genomic_data/SGD.mat
load mayadb
locs = struct();
locidx = containers.Map();
allidx = [];
for i = 1:size(mayadb.textdata,2)
   if isempty(regexpi(mayadb.textdata{1,i}, 'Localization')), continue; end
   x = regexpi(mayadb.textdata{1,i},'\s', 'split');
   locs.(lower(x{1})) = [];
   locidx(lower(x{1})) = i;
   allidx = [allidx, i];
end
%%
fs = fieldnames(locs);
tmp = unique(mayadb.textdata(2:end,allidx));
ulocs = containers.Map();
for i = 1:length(tmp)
    ls = val2locs(tmp{i});
    for li = 1:length(ls)
        if isKey(ulocs, ls{li}), continue, end;
        ulocs(ls{li}) = ulocs.Count + 1;
    end
end
for fi = 1:length(fs)
    locs.(fs{fi}) = false(length(SGD.acc), ulocs.Count);
end

%%
conds = fieldnames(locs);
for i = 2:size(mayadb.textdata,1)
    gid = SGD.acc2ind(mayadb.textdata{i,1});
    for ci = 1:length(conds)
        ls = val2locs(mayadb.textdata{i,locidx(conds{ci})});
        for li = 1:length(ls)
            ulocs(ls{li});
            locs.(conds{ci})(gid, ulocs(ls{li})) = true;
        end
    end
end
%%
for ci = 1:length(conds)
    D = locs.(conds{ci});
    cols = 1:ulocs.Count ~= ulocs('below-threshold');
    locs.(conds{ci})(D(:,ulocs('below-threshold')),cols) = false;
end

for ci = 1:length(conds)
    D = locs.(conds{ci});
    cols = 1:ulocs.Count ~= ulocs('ambiguous');
    locs.(conds{ci})(D(:,ulocs('ambiguous')),cols) = false;
end

ks = keys(ulocs);
for ki = 1:length(ks)
    locs.legend{ulocs(ks{ki})} = ks{ki};
end


%% parse original GFP dataset, as found in http://yeastgfp.yeastgenome.org/ (jan 2015)
% file from website http://yeastgfp.yeastgenome.org/allOrfData.txt is read
% via "import->as dataset" and named "orflocdata"
load ~/Dropbox/genomic_data/SGD.mat
locations = {'ambiguous', 'mitochondrion', 'vacuole', 'spindlepole', ...
             'cellperiphery', 'punctatecomposite', 'vacuolarmembrane', 'ER', ...
             'nuclearperiphery', 'endosome', 'budneck', 'microtubule', 'Golgi', ...
             'lateGolgi', 'peroxisome', 'actin', 'nucleolus', 'cytoplasm', ...
             'ERtoGolgi','earlyGolgi','lipidparticle', 'nucleus', 'bud'};
for i = 1:length(orflocdata)
    SGD
end
    
end