python /userdirs/ram_coders/DEEP/deep_ft/fair/fairseq/scripts/spm_encode.py \
  --model /userdirs/ram_coders/mbart50/mbart50.pretrained/sentence.bpe.model \
  --inputs /userdirs/ram_coders/DEEP/preprocess_en_to_si/news_dataset_crawl_remove_english/input_data/train.si \
  --outputs /userdirs/ram_coders/DEEP/deep_si/data/mbart_pretrain/spm_si/train.spm.si_LK  
  
python /userdirs/ram_coders/DEEP/deep_ft/fair/fairseq/scripts/spm_encode.py \
    --model /userdirs/ram_coders/mbart50/mbart50.pretrained/sentence.bpe.model \
    --inputs /userdirs/ram_coders/DEEP/preprocess_en_to_si/news_dataset_crawl_remove_english/input_data/valid.si \
    --outputs /userdirs/ram_coders/DEEP/deep_si/data/mbart_pretrain/spm_si/valid.spm.si_LK 
  
DICT="/userdirs/ram_coders/mbart50/mbart50.pretrained/dict.si_LK.txt"

fairseq-preprocess \
  --source-lang si_LK \
  --trainpref /userdirs/ram_coders/DEEP/deep_si/data/mbart_pretrain/spm_si/train.spm \
  --validpref /userdirs/ram_coders/DEEP/deep_si/data/mbart_pretrain/spm_si/valid.spm \
  --destdir /userdirs/ram_coders/DEEP/deep_si/data/mbart_pretrain/preprocess \
  --workers 8 \
  --srcdict $DICT \
  --joined-dictionary \
  --only-source