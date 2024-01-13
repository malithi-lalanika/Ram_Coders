## Steps:
- Noising monolingual data.
- Preprocess noised data
- Pretrain
- Preprocess parallel data
- Fine-tune


mbart50 continual pretraining with mbart objective:
```
source activate mbart50
bash train-scripts/pretrain-si-mbart50.sh
```

mbart50 continual pretraining with deep objective:
```
source activate mbart50
bash train-scripts/pretrain-si-mbart50-deep.sh
```

mbart50 finetune:
```
source activate mbart50
bash train-scripts/finetune-si-mbart50.sh [0]
```

mbart50 evaluate:
```
bash train-scripts/eval-si-mbart50.sh [0]
cat /userdirs/ram_coders/DEEP/deep_ft/outputs/finetune/en_to_si_further/mbart50-ft-mbart-obj/en_XX_si_LK.txt | grep -P "^H" |sort -V |cut -f 3-  > /userdirs/ram_coders/DEEP/deep_ft/outputs/finetune/en_to_si_further/mbart50-ft-mbart-obj/preds.txt
sacrebleu -tok 'none' -s 'none' /userdirs/ram_coders/DEEP/deep_ft/outputs/finetune/en_to_si_further/mbart50-ft-mbart-obj/true.txt< /userdirs/ram_coders/DEEP/deep_ft/outputs/finetune/en_to_si_further/mbart50-ft-mbart-obj/preds.txt
```

get translate with mbart50:
```
/userdirs/ram_coders/DEEP/get_translate_mbart50/get-translate.sh
```