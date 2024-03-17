function fun_date_plot(startDate, endDate)

if nargin == 1
    endDate = startDate;
end

% 입력 데이터를 string 형태로 변환
strstartDate = num2str(startDate);
strendDate = num2str(endDate);
missing_List = [];

% 입력 데이터가 입력 양식을 지키는지 확인
if strlength(strstartDate) ~= 12 && strlength(strendDate) ~= 12
    disp('!!!Wrong Input!!! use yyyyMMddHHmm format')
    return
elseif ~isnumeric(startDate) || ~isnumeric(endDate)
    disp('!!!Wrong Input!!! please type numbers')
    return
elseif startDate > endDate
    disp('!!!Wrong Input!!! start date must be earlier than end date')
    return
end

% png 파일 경로를 설정
fdir = uigetdir;

t1 = datetime(strstartDate,'InputFormat','yyyyMMddHHmm','Format', 'yyyyMMdd_HHmm');
t2 = datetime(strendDate,'InputFormat','yyyyMMddHHmm','Format', 'yyyyMMdd_HHmm');

% 10분 간격의 데이터를 생성
dates = t1:minutes(10):t2;
dates = ('AIB_' + string(dates) + '.png')';

for i = 1:length(dates)
    date = dates(i);
    pngdir = strcat(fdir, '/', date);
    if isfile(pngdir)
        rdata = imread(pngdir);
        fun_png_display_functionuse(date, rdata, i, 0);
    else
        date = char(date);
        missing_List = [missing_List, string(date(5:end-4))];
    end
end

% 없는 날짜를 반환해줌
disp('Following date(s) are missing')
for j = 1:length(missing_List)
    disp(missing_List(j))
end




