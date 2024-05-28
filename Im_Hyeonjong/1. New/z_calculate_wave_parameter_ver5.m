path = 'D:/png2019/';
file_list = dir([path, '*.png']);

for i = 1 : length(file_list)
    if file_list(i).name(16) == '0' && file_list(i).name(9) == '1' && file_list(i).name(10) == '0';
        a = [file_list(i).folder '\' file_list(i).name];
        b = 'C:/Users/Administrator/Desktop/png2019_10'
        copyfile(a, b)
    end
end