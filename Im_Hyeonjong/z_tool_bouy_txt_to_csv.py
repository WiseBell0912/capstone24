import pandas as pd

# 부이 정보 파일
t_data = pd.read_csv('./DATA/Bouy/data_2021_TW_TW_GYEONGPO_2021_KR.txt', sep='\t', header=3, usecols=['관측시간', '유의파고(m)'])

# 필요한 부분만 저장
t_data.to_csv('./DATA/Bouy/bouy_Hs_2021.csv', index=False)