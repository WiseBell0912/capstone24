function [] = load_ADCP

filename = [pwd '/DATA/ADCP/Wave_data_W01_cm(WIN).dat'];
delimiter = ' ';
startRow = 2;

formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';


fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

fclose(fileID);

YYYY = dataArray{:, 1};
MM = dataArray{:, 2};
DD = dataArray{:, 3};
hh = dataArray{:, 4};
mm = dataArray{:, 5};
ss = dataArray{:, 6};
H10 = dataArray{:, 8};
tm = dataArray{:, 9};
Hs = dataArray{:, 10};
dir1 = dataArray{:, 11};
tp = dataArray{:, 12};

clearvars filename delimiter startRow formatSpec fileID dataArray ans;
date_w01 = datetime(YYYY,MM,DD,hh,mm,ss);

assignin('base','date_w01',date_w01);
assignin('base','Hs_w01',Hs/100);
assignin('base','H10_w01',H10/100);
assignin('base','tm_w01',tm);
assignin('base','tp_w01',tp);
assignin('base','dir_w01',dir1);

'w-01 loaded';
'date_w01 / Hs_w01 / H10_w01 / tm_w01 / tp_w01 / dir_w01';
end





