#!/bin/bash
export CUDA_VISIBLE_DEVICES=$1
#BASE=$HOME
#REPO=/data/hulab/junjieh/deep/
sl='en_XX'
tl='si_LK'
SL='en'
TL='si'


bin_dir=/userdirs/ram_coders/DEEP/SITA_Parallel_Dataset/output_data/preprocess
#detok_ref=$REPO/data/ted/test.uk

langs="ar_AR,cs_CZ,de_DE,en_XX,es_XX,et_EE,fi_FI,fr_XX,gu_IN,hi_IN,it_IT,ja_XX,kk_KZ,ko_KR,lt_LT,lv_LV,my_MM,ne_NP,nl_XX,ro_RO,ru_RU,si_LK,tr_TR,vi_VN,zh_CN,af_ZA,az_AZ,bn_IN,fa_IR,he_IL,hr_HR,id_ID,ka_GE,km_KH,mk_MK,ml_IN,mn_MN,mr_IN,pl_PL,ps_AF,pt_XX,sv_SE,sw_KE,ta_IN,te_IN,th_TH,tl_XX,uk_UA,ur_PK,xh_ZA,gl_ES,sl_SI"

# Checkpoint folder
#path=/userdirs/ram_coders/DEEP/deep_ft/outputs/finetune/en_to_si_further/mbart50-ft-mbart-obj/checkpoint_last.pt
#lang_list=/userdirs/ram_coders/DEEP/data/mbart.cc25.v2/ML50_langs.txt

#ckpt=checkpoint_last.pt
#path=$mt_dir/$ckpt
#mt=${ckpt/pt/mt}
#out_file=$mt_dir/${ckpt/pt/mt}
#echo $ckpt $mt $bin_dir $mt_dir
#echo $out_file

source_lang="en_XX"
target_lang="si_LK"
lang_pairs="en_XX-si_LK"
lang_list="/userdirs/ram_coders/mbart50/mbart50.pretrained/ML50_langs.txt"


fairseq-generate \
    $bin_dir \
  --path /userdirs/ram_coders/DEEP/deep_ft/outputs/finetune/en_to_si_further/mbart50-ft-mbart-obj/checkpoint_last.pt \
  --task translation_multi_simple_epoch \
  --gen-subset test \
  --source-lang $source_lang \
  --target-lang $target_lang \
  --scoring sacrebleu --remove-bpe 'sentencepiece' \
  --batch-size 32 \
  --encoder-langtok "src" \
  --decoder-langtok \
  --lang-dict $lang_list \
  --lang-pairs $lang_pairs  > /userdirs/ram_coders/DEEP/deep_ft/outputs/finetune/en_to_si_further/mbart50-ft-mbart-obj/${source_lang}_${target_lang}.txt
