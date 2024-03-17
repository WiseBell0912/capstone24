function [] = loadw02

filename = [pwd '/train_data/안인파랑관측_201909-202001.to.Gopher.xlsx'];

gopher = readtable(filename, 'VariableNamingRule', 'preserve');

assignin('base','date_w02',gopher.time);
assignin('base','Hs_w02',gopher.("유의파고"));

'w-02 loaded'
'date_w02 / Hs_w02'
end





