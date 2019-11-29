function xx=dtmfdial(keyNames,fs)
%create table of data
dtmf.keys=['1','2','3','A';'4','5','6','B';'7','8','9','C';'*','0','#','D'];

%sets column and rows of frequencies
ff_cols=[1209,1336,1477,1633];
ff_rows=[697; 770; 852; 941];
dtmf.colTones=ones(4,1)*ff_cols;
dtmf.rowTones=ff_rows*ones(1,4);

xx=[];

for ii=1:length(keyNames)
    %gets column and row frequencies
    [rr,cc]=find(keyNames(ii)==dtmf.keys);
    xx=[xx,zeros(1,400)];
    freqR = dtmf.rowTones(rr,cc);
    freqC = dtmf.colTones(rr,cc);
    
    %adds both the row and column phasors
    xx=[xx,(cos(2*pi*freqR*(0:1199)/fs) + cos(2*pi*freqC*(0:1199)/fs))];
end
soundsc(xx,fs);