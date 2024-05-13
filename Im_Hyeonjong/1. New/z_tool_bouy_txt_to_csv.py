import pandas as pd

# 부이 정보 파일 (맥에서만 encoding='cp949' 넣어줘야 돌아감. 윈도우는 지워야 돌아감.)
t_data = pd.read_csv('/Users/imhyeonjong/Documents/GitHub/capstone24/Im_Hyeonjong/2. Data/Bouy/data_2019_TW_TW_GYEONGPO_2019_KR.txt', sep='\t', header=3, usecols=['관측시간','유향(deg)','유의파고(m)','유의파주기(sec)','최대파고(m)','최대파주기(sec)'])

# 필요한 부분만 저장
t_data.to_csv('/Users/imhyeonjong/Documents/GitHub/capstone24/Im_Hyeonjong/2. Data/Bouy/bouy_2019.csv', index=False)