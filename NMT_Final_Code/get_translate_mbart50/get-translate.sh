# TRANSALTE raw data
# encode 
source ~/miniconda/etc/profile.d/conda.sh # Or path to where your conda is
conda activate test

python /userdirs/ram_coders/DEEP/deep_ft/fair/fairseq/scripts/spm_encode.py \
    --model /userdirs/ram_coders/DEEP/data/mbart.cc25.v2/sentence.bpe.model \
    --inputs /userdirs/ram_coders/DEEP/get_translate_mbart50/translate_input.txt \
    --outputs /userdirs/ram_coders/DEEP/get_translate_mbart50/preprocess_output.txt


source_lang="en_XX"
target_lang="si_LK"
lang_pairs="en_XX-si_LK"
lang_list="/userdirs/ram_coders/mbart50/mbart50.pretrained/ML50_langs.txt"

langs="ar_AR,cs_CZ,de_DE,en_XX,es_XX,et_EE,fi_FI,fr_XX,gu_IN,hi_IN,it_IT,ja_XX,kk_KZ,ko_KR,lt_LT,lv_LV,my_MM,ne_NP,nl_XX,ro_RO,ru_RU,si_LK,tr_TR,vi_VN,zh_CN,af_ZA,az_AZ,bn_IN,fa_IR,he_IL,hr_HR,id_ID,ka_GE,km_KH,mk_MK,ml_IN,mn_MN,mr_IN,pl_PL,ps_AF,pt_XX,sv_SE,sw_KE,ta_IN,te_IN,th_TH,tl_XX,uk_UA,ur_PK,xh_ZA,gl_ES,sl_SI"

bin_dir=/userdirs/ram_coders/DEEP/SITA_Parallel_Dataset/output_data/preprocess

#model=/userdirs/ram_coders/DEEP/deep_ft/outputs/finetune/en_to_si_further/mbart50-ft-mbart-obj/checkpoint_best.pt
model=/userdirs/ram_coders/DEEP/deep_ft/outputs/finetune/en_to_si_further/mbart50-ft-deep-obj/checkpoint_best.pt
#model=/userdirs/ram_coders/DEEP/deep_ft/outputs/finetune/en_to_si_further/mbart50-ft-nopretrain/checkpoint_best.pt

cat /userdirs/ram_coders/DEEP/get_translate_mbart50/preprocess_output.txt \
    | fairseq-interactive $bin_dir \
      --path $model \
      --task translation_multi_simple_epoch \
      --gen-subset test \
      --source-lang $source_lang \
      --target-lang $target_lang \
      --remove-bpe 'sentencepiece' \
      --encoder-langtok "src" \
      --decoder-langtok \
      --lang-dict $lang_list \
      --lang-pairs $lang_pairs > /userdirs/ram_coders/DEEP/get_translate_mbart50/${source_lang}_${target_lang}.txt
	  
cat /userdirs/ram_coders/DEEP/get_translate_mbart50/en_XX_si_LK.txt | grep -P "^H" |sort -V |cut -f 3-  > /userdirs/ram_coders/DEEP/get_translate_mbart50/translation_output.txt