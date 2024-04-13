import pandas as pd

# 부이 정보 파일 (맥에서만 encoding='cp949' 넣어줘야 돌아감. 윈도우는 지워야 돌아감.)
t_data = pd.read_csv('/Users/imhyeonjong/Documents/GitHub/capstone24/Im_Hyeonjong/DATA/Bouy/data_2022_TW_TW_GYEONGPO_2022_KR.txt', sep='\t', header=3, encoding='cp949', usecols=['관측시간', '유의파고(m)'])

# 필요한 부분만 저장
t_data.to_csv('/Users/imhyeonjong/Documents/GitHub/capstone24/Im_Hyeonjong/DATA/Bouy/bouy_Hs_2022.csv', index=False)