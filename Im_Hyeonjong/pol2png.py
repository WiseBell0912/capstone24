import numpy as np
import re
import cv2
import os

def pol2png(fileIn, fileOut):

    Nimg = 129      # 이미지 장수 (데이터는 129장이지만 128장만 사용)
    Nsync = 1080    # 싱크

    poldata = np.memmap(fileIn, dtype=np.uint8)

    # 헤더 제거
    hstr = ''.join(map(chr, poldata[:2000].astype(np.uint8)))
    temp = poldata[re.search('\nEOH.*\n', hstr).end():]
    temp = temp.view(np.uint16)

    # 이미지 장으로 데이터 분할
    imgs = []
    offset = 0
    for i in range(Nimg):
        try:
            img_size = temp[offset + 0]
            img = temp[offset + 1:offset + 1 + (img_size * 512)]
            offset += 1 + (img_size * 512)
            imgs.append(img)
        except:
            pass

    # 흔들림 보정
    calibrated_imgs = []

    for ii in range(Nimg):
        try:
            img = imgs[ii]
            img_syncs = img.reshape(-1, 512)

            bearing = (img_syncs[:, 0] & 0x4000) > 0
            bearing_true = (bearing == True)
            bearing_changed = np.r_[False, (bearing[:-1] != bearing[1:])]
            bearing_changed_idx = np.r_[0, np.arange(len(img_syncs))[bearing_true * bearing_changed]]

            if len(bearing_changed_idx) > 360:
                bearing_changed_idx = bearing_changed_idx[:360]

            bearing_changed_idx = np.r_[bearing_changed_idx, len(bearing)]
            temp = np.array([np.linspace(i, j, 3, endpoint=False) for i, j in
                             zip(bearing_changed_idx[:-1], bearing_changed_idx[1:])]).flatten()
            stretched_sync_idxs = np.rint(temp).astype(int)

            try:
                calibrated_img = img_syncs[stretched_sync_idxs].flatten().astype(np.uint8)
            except:
                stretched_sync_idxs[-1] = stretched_sync_idxs[-1] - 1
                calibrated_img = img_syncs[stretched_sync_idxs].flatten().astype(np.uint8)

            calibrated_img = 0xff - calibrated_img
            calibrated_imgs.append(calibrated_img)
        except:
            pass

    # 각 이미지의 데이터 갯수 에러시 대체
    Nimgc = len(calibrated_imgs) #흔들림 보정 성공한 이미지 장수

    for ii in range(Nimgc):
        if int(len(calibrated_imgs[ii]) / 512) != Nsync:
            if ii == 0:
                calibrated_imgs[ii] = calibrated_imgs[ii + 1]
            else:
                calibrated_imgs[ii] = calibrated_imgs[ii - 1]

    # 육지 부분 값 0으로.. 용량 절감
    calibrated_imgs = np.rot90(np.array(calibrated_imgs), -1)  # matlab과 index 순서 맞추기 위해 rot90
    calibrated_imgs = calibrated_imgs.reshape(1080, 512, 129)
    calibrated_imgs[215:690, :, :] = 0
    calibrated_imgs = calibrated_imgs.reshape(512 * 1080, 129)

    # png로 저장
    cv2.imwrite(fileOut, calibrated_imgs, [cv2.IMWRITE_PNG_COMPRESSION, 9])
################################## pol2png
### fileIn : .pol파일 경로
### fileOut: .png파일이 저장 될 경로


# 0 # 파일 경로
<<<<<<< HEAD
poldir = "C:/Users/Administrator/Documents/GitHub/capstone24/Im_Hyeonjong/POL/"  # .pol파일 경로
pngdir = "C:/Users/Administrator/Documents/GitHub/capstone24/Im_Hyeonjong/PNG/"  # png 파일 저장 경로
=======
poldir = "/Users/imhyeonjong/Documents/POL/"  # .pol파일 경로
pngdir = "/Users/imhyeonjong/Documents/POL/"  # png 파일 저장 경로
>>>>>>> d46012bae40b32f9a63c6eb5162071fe33760f35


# pol 파일 리스트
flist = os.listdir(poldir)
flist = [file for file in flist if file.endswith(".pol")]

# pol 폴더에 있는 모든 파일을 png 파일로 변환
for ii in range(len(flist)):
    try:
        fname = poldir + flist[ii]
        pngname = pngdir + flist[ii][0:-4] + ".png"
        pol2png(fname, pngname)
    except:
        pass