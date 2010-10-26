function []= Save_Data_ASCII_3(ExpDate, Unitn, group, filen, sweepnumber, FileType, DataType)

%Written by cedric 22/07/08
%update: 6-10-2008
% update: option for antoine files

% ce programe range les donnes d'un fichier ASCII exporter de Pulsefit
% dans datatable
%data table raws 1:sweepnumber = idata
%data table raw sweepnumber+1 = zeros (room for idata mean)
%data table raw sweepnumber+2= tdata


%% input

%disp 'file open path: /users/cedric/Bardy_Postdoc_Pasteur /Experiments_Analysis/Data_Electrophy/ASCII/ExpDate/expt.ASC'


%%%%%%% ATTENTION %%%%%%% fill ExpDate (ex: '20080703')
%%%%%%% ATTENTION %%%%%%% and file (ex: '1_18_30_GBST')
%%%%%%% ATTENTION %%%%%%% and expt (ex: '20080703_1_18_30_GBST')
%%%%%%% ATTENTION %%%%%%% and sweepnumber (ex: 30)

% ExpDate='20080703'
% group='1'
% filen='21'
% sweepnumber= '30'
% FileType='GBSP'




%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%





%%display ('Pushbutton: Save File ASCII')
%display ('wait untill done')


%% Save_Data_ASCII(ExpDate, Unitn, group, filen, sweepnumber, FileType);
x{1}=[];
x{1}=[FileType,'_',group,'_',filen,'_',sweepnumber];
file=x{1};

x{1}=[];
x{1}=[ExpDate,'_',group,'_',filen,'_',sweepnumber,'_',FileType];
expt=x{1};

x{1}=[];
x{1}=[ExpDate,'/',ExpDate, '_', group,'_', filen, '_', sweepnumber,'_', FileType];
exptp=x{1};

expt

x{1}=[];
x{1}=['Exp',ExpDate];
ExpDate=x{1};

display('loading...')
tempor=load (['/users/cedric/Bardy_Postdoc_Pasteur /Experiments_Analysis/Data_Electrophy/ASCII/' exptp '.ASC']);


rawdatatablei=[];
rawdatatablet=[];
sweepnumber=str2double(sweepnumber);
[m,n]=size (tempor);

if DataType == 'DataAntoin'
j=1;
L=[m./sweepnumber]
k=L;
for i=1:sweepnumber
    rawdatatablei=[rawdatatablei,tempor(j:k,2)];
    rawdatatablet=[rawdatatablet,tempor(j:k,1)];
    j=k+1;
    k=k+L;
    i;
end
rawdatatablei=rawdatatablei.*(10.^-12);

elseif DataType == 'DataCedric'
j=1;
L=[m./sweepnumber]
k=L;
for i=1:sweepnumber
    rawdatatablei=[rawdatatablei,tempor(j:k,3)];
    rawdatatablet=[rawdatatablet,tempor(j:k,2)];
    j=k+1;
    k=k+L;
    i;
end


end
%display('saving...')
workspacetitle{1}= ['RawDataTable_it', expt]

save (workspacetitle{1}, 'rawdatatablei','rawdatatablet','expt', 'sweepnumber')

%display('saving...')
ExpUnit{1}= [ExpDate, Unitn]
load (ExpUnit{1})

ExpUnitName.(ExpUnit{1}).data.(file).RawDataTable= {rawdatatablei rawdatatablet expt sweepnumber};

save (ExpUnit{1}, 'ExpUnitName')
   


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% Save
% display('saving...')
% workspacetitle{1}= ['RawDataTable_it', expt]
% 
% save (workspacetitle{1}, 'rawdatatablei','rawdatatablet','expt', 'sweepnumber')
% display('saving...')
% %load Electrophy_workspace
% 
% Electrophy_mice.(ExpDate).(Unitn).data.(file).RawDataTable= {rawdatatablei rawdatatablet expt sweepnumber};
% %save ('/users/cedric/Bardy_Postdoc_Pasteur /Experiments_Analysis/Data_Electrophy/Electrophy_workspace', 'Electrophy_mice')

%% extra stuff
% expdate:2008-07-03
% datafile:GBST_1-18
% sweepnumber= 30

%'-append' 


% StructWT_Normal.(expt)=load
% 
% 
% 2008-07-03_data_GBST_1-18{1}='2008-07-03_data_GBST_1-18'



%% extra stuff
%fid = fopen(['/users/cedric/Bardy_Postdoc_Pasteur
%/Experiments_Analysis/Data_Electrophy/ASCII/' exptp '.ASC'])
% %% output
% %sweepnumber=str2double(sweepnumber)
% 
% for k = 1:sweepnumber
%     junk = fscanf(fid,'%s',2);
%     npoints = fscanf(fid,'%f',1);
%     junk = fscanf(fid,'%s',4);
%   
%    t{k} = [];
%    i{k} = [];
%     for j = 1:npoints
%         if k==1
%         t{k} = [t{k};fscanf(fid,'%f',1)];
%         else  junk = fscanf(fid,'%f',1);
%         end
%         i{k} = [i{k};fscanf(fid,'%f',1)];  
%     end
%     idata(:,k)=i{k};
% k
% end
% tdata=t{1};
% rawdatatable=idata;
% rawdatatable (:, sweepnumber+1) = mean (rawdatatable(:, 1:sweepnumber), 2);
% rawdatatable(:,(sweepnumber+2))=tdata;

