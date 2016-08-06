function [chrname] = num2chr(num)
%return a map from chrom to length (roman numerics)
if num == 17, chrname = 'chrM';
else chrname = ['chr',num2roman(num)]; end;
end

