import pandas as pd

# 부이 정보 파일 (맥에서만 encoding='cp949' 넣어줘야 돌아감. 윈도우는 지워야 돌아감.)
t_data = pd.read_csv('../2. Data/Bouy/data_2023_TW_TW_GYEONGPO_202307_KR.txt', sep='\t', header=3, encoding='cp949', usecols=['관측시간', '유의파고(m)'])

# 필요한 부분만 저장
t_data.to_csv('../2. Data/Bouy/bouy_Hs_2023_07.csv', index=False)