---
title: "paddleOCR训练"
date: 2026-06-04
tags: ["tools"]
---

#date/2024-12-29 01:02:10# #lastmod/2024-12-29 01:02:10#

---

# paddleOCR训练

~~~
python tools/infer/predict_system.py  --image_dir="D:\User\yaoye\Pictures\QQ20241226-005135.png" --det_model_dir="./model/ch_PP-OCRv3_det_infer/" --rec_model_dir="./model/ch_PP-OCRv3_rec_infer/"
~~~

~~~
pip install numpy==1.23.5
~~~

~~~
python gen_ocr_train_val_test.py --trainValTestRatio 9:1:0 --datasetRootPath ../train_data/drivingData
~~~

~~~
python tools/train.py -c configs/det/ch_PP-OCRv3/ch_PP-OCRv3_det_student.yml -o Global.checkpoints=./output/ch_PP-OCR_V3_det/latest
~~~

~~~
python tools/train.py -c configs/rec/PP-OCRv3/ch_PP-OCRv3_rec_distillation.yml
~~~

~~~
python tools/train.py -c configs/rec/PP-OCRv3/ch_PP-OCRv3_rec.yml
~~~

[cuda](https://developer.nvidia.com/cuda-toolkit-archive)

[cudnn](https://developer.nvidia.com/rdp/cudnn-archive)

~~~
python tools/infer_rec.py -c configs/rec/PP-OCRv3/ch_PP-OCRv3_rec_distillation.yml -o Global.pretrained_model=output/rec/best_accuracy.pdparams Global.infer_img=“C:\Users\User\Desktop\PaddleOCR-release-2.6\train_data\rec\test\0001_1 (110)_crop_3.jpg”
~~~

训练完成后没有best_accuracy.pdparams，需要在训练时调整配置文件eval_batch_step，源码中为 eval_batch_step: [3000, 2000]
意思是在训练时每训练 3000 和 2000 个 batch 后，进行一次评估（validation），需要调整为eval_batch_step: [ 0, 19 ]，第0与第19轮时做一组评估，否则不会出现best的相关文件，同时需要修改batch_size_per_card和epoch_num，保证batch_size_per_card<epoch_num

~~~
python tools/infer_rec.py -c configs/rec/PP-OCRv3/ch_PP-OCRv3_rec.yml -o Global.pretrained_model=output/rec_ppocr_v3_distillation/latest.pdparams Global.infer_img="D:\Application\Develop\Project\python\PaddleOCR\train_data\drivingData\crop_img\002_crop_0.jpg"
~~~

93.8 98
