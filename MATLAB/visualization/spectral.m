function [clrs] = spectral(N)
spectrum = [0         0         0
            0.0366         0    0.0418
            0.0732         0    0.0837
            0.1098         0    0.1255
            0.1464         0    0.1673
            0.1830         0    0.2091
            0.2196         0    0.2510
            0.2562         0    0.2928
            0.2928         0    0.3346
            0.3294         0    0.3764
            0.3660         0    0.4183
            0.4026         0    0.4601
            0.4392         0    0.5019
            0.4680         0    0.5346
            0.4732         0    0.5398
            0.4785         0    0.5451
            0.4837         0    0.5503
            0.4889         0    0.5555
            0.4941         0    0.5608
            0.4993         0    0.5660
            0.5046         0    0.5712
            0.5098         0    0.5765
            0.5150         0    0.5817
            0.5202         0    0.5869
            0.5255         0    0.5922
            0.5307         0    0.5974
            0.5124         0    0.6026
            0.4706         0    0.6078
            0.4287         0    0.6131
            0.3869         0    0.6183
            0.3451         0    0.6235
            0.3032         0    0.6288
            0.2614         0    0.6340
            0.2196         0    0.6392
            0.1778         0    0.6445
            0.1359         0    0.6497
            0.0941         0    0.6549
            0.0523         0    0.6602
            0.0105         0    0.6654
                 0         0    0.6785
                 0         0    0.6942
                 0         0    0.7098
                 0         0    0.7255
                 0         0    0.7412
                 0         0    0.7569
                 0         0    0.7726
                 0         0    0.7883
                 0         0    0.8040
                 0         0    0.8196
                 0         0    0.8353
                 0         0    0.8510
                 0         0    0.8667
                 0    0.0366    0.8667
                 0    0.0732    0.8667
                 0    0.1098    0.8667
                 0    0.1464    0.8667
                 0    0.1830    0.8667
                 0    0.2196    0.8667
                 0    0.2562    0.8667
                 0    0.2928    0.8667
                 0    0.3294    0.8667
                 0    0.3660    0.8667
                 0    0.4026    0.8667
                 0    0.4392    0.8667
                 0    0.4693    0.8667
                 0    0.4798    0.8667
                 0    0.4902    0.8667
                 0    0.5007    0.8667
                 0    0.5111    0.8667
                 0    0.5216    0.8667
                 0    0.5320    0.8667
                 0    0.5425    0.8667
                 0    0.5530    0.8667
                 0    0.5634    0.8667
                 0    0.5739    0.8667
                 0    0.5843    0.8667
                 0    0.5948    0.8667
                 0    0.6026    0.8589
                 0    0.6078    0.8432
                 0    0.6131    0.8275
                 0    0.6183    0.8118
                 0    0.6235    0.7961
                 0    0.6288    0.7804
                 0    0.6340    0.7647
                 0    0.6392    0.7491
                 0    0.6445    0.7334
                 0    0.6497    0.7177
                 0    0.6549    0.7020
                 0    0.6602    0.6863
                 0    0.6654    0.6706
                 0    0.6667    0.6589
                 0    0.6667    0.6484
                 0    0.6667    0.6379
                 0    0.6667    0.6275
                 0    0.6667    0.6170
                 0    0.6667    0.6065
                 0    0.6667    0.5961
                 0    0.6667    0.5856
                 0    0.6667    0.5752
                 0    0.6667    0.5647
                 0    0.6667    0.5542
                 0    0.6667    0.5438
                 0    0.6667    0.5333
                 0    0.6615    0.4915
                 0    0.6562    0.4496
                 0    0.6510    0.4078
                 0    0.6458    0.3660
                 0    0.6405    0.3242
                 0    0.6353    0.2823
                 0    0.6301    0.2405
                 0    0.6248    0.1987
                 0    0.6196    0.1569
                 0    0.6144    0.1150
                 0    0.6092    0.0732
                 0    0.6039    0.0314
                 0    0.6026         0
                 0    0.6131         0
                 0    0.6235         0
                 0    0.6340         0
                 0    0.6444         0
                 0    0.6549         0
                 0    0.6653         0
                 0    0.6758         0
                 0    0.6863         0
                 0    0.6967         0
                 0    0.7072         0
                 0    0.7176         0
                 0    0.7281         0
                 0    0.7385         0
                 0    0.7490         0
                 0    0.7595         0
                 0    0.7699         0
                 0    0.7804         0
                 0    0.7908         0
                 0    0.8013         0
                 0    0.8118         0
                 0    0.8222         0
                 0    0.8327         0
                 0    0.8432         0
                 0    0.8536         0
                 0    0.8641         0
                 0    0.8745         0
                 0    0.8850         0
                 0    0.8955         0
                 0    0.9059         0
                 0    0.9164         0
                 0    0.9268         0
                 0    0.9373         0
                 0    0.9477         0
                 0    0.9582         0
                 0    0.9686         0
                 0    0.9791         0
                 0    0.9895         0
                 0    1.0000         0
            0.0575    1.0000         0
            0.1150    1.0000         0
            0.1725    1.0000         0
            0.2301    1.0000         0
            0.2876    1.0000         0
            0.3451    1.0000         0
            0.4026    1.0000         0
            0.4601    1.0000         0
            0.5176    1.0000         0
            0.5751    1.0000         0
            0.6327    1.0000         0
            0.6902    1.0000         0
            0.7372    0.9987         0
            0.7529    0.9935         0
            0.7686    0.9882         0
            0.7843    0.9830         0
            0.8000    0.9778         0
            0.8157    0.9725         0
            0.8313    0.9673         0
            0.8470    0.9621         0
            0.8627    0.9568         0
            0.8784    0.9516         0
            0.8941    0.9464         0
            0.9098    0.9411         0
            0.9255    0.9359         0
            0.9359    0.9281         0
            0.9411    0.9176         0
            0.9464    0.9072         0
            0.9516    0.8967         0
            0.9568    0.8863         0
            0.9621    0.8758         0
            0.9673    0.8653         0
            0.9725    0.8549         0
            0.9778    0.8444         0
            0.9830    0.8340         0
            0.9882    0.8235         0
            0.9935    0.8131         0
            0.9987    0.8026         0
            1.0000    0.7882         0
            1.0000    0.7725         0
            1.0000    0.7569         0
            1.0000    0.7412         0
            1.0000    0.7255         0
            1.0000    0.7098         0
            1.0000    0.6941         0
            1.0000    0.6784         0
            1.0000    0.6627         0
            1.0000    0.6471         0
            1.0000    0.6314         0
            1.0000    0.6157         0
            1.0000    0.6000         0
            1.0000    0.5529         0
            1.0000    0.5059         0
            1.0000    0.4588         0
            1.0000    0.4118         0
            1.0000    0.3647         0
            1.0000    0.3176         0
            1.0000    0.2706         0
            1.0000    0.2235         0
            1.0000    0.1765         0
            1.0000    0.1294         0
            1.0000    0.0824         0
            1.0000    0.0353         0
            0.9974         0         0
            0.9869         0         0
            0.9765         0         0
            0.9660         0         0
            0.9556         0         0
            0.9451         0         0
            0.9347         0         0
            0.9242         0         0
            0.9137         0         0
            0.9033         0         0
            0.8928         0         0
            0.8824         0         0
            0.8719         0         0
            0.8641         0         0
            0.8589         0         0
            0.8536         0         0
            0.8484         0         0
            0.8432         0         0
            0.8379         0         0
            0.8327         0         0
            0.8275         0         0
            0.8222         0         0
            0.8170         0         0
            0.8118         0         0
            0.8065         0         0
            0.8013         0         0
            0.8000    0.0471    0.0471
            0.8000    0.1098    0.1098
            0.8000    0.1725    0.1725
            0.8000    0.2353    0.2353
            0.8000    0.2980    0.2980
            0.8000    0.3608    0.3608
            0.8000    0.4235    0.4235
            0.8000    0.4863    0.4863
            0.8000    0.5490    0.5490
            0.8000    0.6118    0.6118
            0.8000    0.6745    0.6745
            0.8000    0.7373    0.7373
            0.8000    0.8000    0.8000];
if ~exist('N','var')
    clrs = spectrum;
else
    step = size(spectrum,1)/N;
    inds = round(1:step:size(spectrum,1));
    clrs = spectrum(inds,:);
end