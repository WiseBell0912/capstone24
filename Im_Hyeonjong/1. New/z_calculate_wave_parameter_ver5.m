path = '/Users/imhyeonjong/Documents/POL/';
file_list = dir([path, '*.png']);

for i = 1 : length(file_list)
    if file_list(i).name(16) == '0'
        png_location = [path, file_list(i).name];
        dummy = checker(png_location);
    end
end