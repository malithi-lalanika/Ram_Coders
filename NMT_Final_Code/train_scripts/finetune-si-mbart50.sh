REPO=/userdirs/ram_coders/DEEP/deep_si
MAXL=1024
bin_dir=/userdirs/ram_coders/DEEP/SITA_Parallel_Dataset/output_data/preprocess 
SAVE=$REPO/outputs/


## Pre-train on si_XX
lang_pairs="en_XX-si_LK"
lang_list="/userdirs/ram_coders/mbart50/mbart50.pretrained/ML50_langs.txt"  # <a file which contains a list of languages separated by new lines>
pretrained_model="/userdirs/ram_coders/DEEP/deep_si/outputs/pretrain/mbart50-pt-mbart-obj/checkpoint_best.pt" # <path to the pretrained model, e.g. mbart or another trained multilingual model>

# We use a while-loop to load the latest checkpoint to continue training 
# if the job is terminated before the max step.
CUDA_VISIBLE_DEVICES=0 fairseq-train $bin_dir \
  --finetune-from-model $pretrained_model \
  --encoder-normalize-before --decoder-normalize-before \
  --arch mbart_large --layernorm-embedding \
  --task translation_multi_simple_epoch \
  --sampling-method "temperature" \
  --sampling-temperature 1 \
  --encoder-langtok "src" \
  --decoder-langtok \
  --lang-dict $lang_list \
  --lang-pairs $lang_pairs \
  --criterion label_smoothed_cross_entropy --label-smoothing 0.2 \
  --optimizer adam --adam-eps 1e-06 --adam-betas '(0.9, 0.98)' \
  --lr-scheduler inverse_sqrt --lr 3e-05 --warmup-updates 2500 --max-update 100000 \
  --dropout 0.3 --attention-dropout 0.1 --weight-decay 0.0 \
  --max-tokens 1024 --update-freq 2 \
  --save-interval 1 --save-interval-updates 1000000 --keep-interval-updates 10 --no-epoch-checkpoints \
  --seed 222 --log-format simple --log-interval 2 \
  --fp16 \
  --save-dir /userdirs/ram_coders/DEEP/deep_ft/outputs/finetune/en_to_si_further/mbart50-ft-mbart-obj > /userdirs/ram_coders/DEEP/deep_ft/outputs/finetune/en_to_si_further/mbart50-ft-mbart-obj/logs 2>&1
