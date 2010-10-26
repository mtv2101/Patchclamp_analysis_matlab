function []= spont_tranfer_to_elphy_2


load('Files_list')
[m,n]=size(Feuil1);

for i=1:m
display ('PROCESSING NEW FILE...')

ExpDate=Feuil1{i,1};
Filen=Feuil1{i,3};
FileType=Feuil1{i,4};
Unitn= Feuil1{i,2};

x{1}=[ExpDate,Unitn];
ExpDate=x{1}

x{1}=[Feuil1{i,4},'_',Feuil1{i,3}];
file=x{1}

load (ExpDate)
%%
% ExpDate='20081013'
% file='GBSP_4_18_25'
% Unitn= 'U04'
% 
% x{1}=['Exp',ExpDate,Unitn];
% ExpDate=x{1};

SamplingRate=0.0001 %(0.0001s 100us 10Hz; or 0.00005s 50us 20Hz)
display ('loading...')
load (ExpDate)

x{1}=['Elphy',ExpDate,Unitn,file,'.asc'];
ElphyFile=x{1};

rawdatatable = ExpUnitName.(ExpDate).data.(file).RawDataTable{1};
sweepnumber= ExpUnitName.(ExpDate).data.(file).RawDataTable{4};

[m,n] =size (rawdatatable)


display ('processing...')
RawDataSpontElphy=[rawdatatable(:,1)];
for i=2:n
RawDataSpontElphy=[RawDataSpontElphy;rawdatatable(:,i)];
end
RawDataSpontElphy(:,2)=RawDataSpontElphy;


tt=0;
[m,n] =size (RawDataSpontElphy)
for i=1:m
RawDataSpontElphy(i,1)=tt;
tt = tt + SamplingRate;
end

% for i=1:(m/10)
% RawDataSpontElphyAveraged(i,1)=tt;
% tt = tt + SamplingRate;
% end
% RawDataSpontElphyAveraged=

%save('/Users/cedric/Desktop/sponttest6','sponttest5','-ASCII', '-double','-tabs');
display('saving...')
save(ElphyFile,'RawDataSpontElphy','-ASCII','-tabs');

end
display ('done')
beep

%% smoothing data
% display ('smoothing*5 ...')
% span = 5; % Size of the averaging window
% window = ones(span,1)/span; 
% rawdatatableSmoothed = convn(rawdatatable,window,'same');