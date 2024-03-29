python /userdirs/ram_coders/DEEP/deep_ft/fair/fairseq/scripts/spm_encode.py \
  --model /userdirs/ram_coders/DEEP/data/mbart.cc25.v2/sentence.bpe.model \
  --inputs  /userdirs/ram_coders/DEEP/preprocess_translit/input_data/train.en /userdirs/ram_coders/DEEP/preprocess_translit/input_data/train.si  \
  --outputs /userdirs/ram_coders/DEEP/preprocess_translit/output_data/train.bpe.en_XX /userdirs/ram_coders/DEEP/preprocess_translit/output_data/train.bpe.si_LK  

python /userdirs/ram_coders/DEEP/deep_ft/fair/fairseq/scripts/spm_encode.py \
    --model /userdirs/ram_coders/DEEP/data/mbart.cc25.v2/sentence.bpe.model \
    --inputs /userdirs/ram_coders/DEEP/preprocess_translit/input_data/valid.en /userdirs/ram_coders/DEEP/preprocess_translit/input_data/valid.si  \
    --outputs /userdirs/ram_coders/DEEP/preprocess_translit/output_data/valid.bpe.en_XX /userdirs/ram_coders/DEEP/preprocess_translit/output_data/valid.bpe.si_LK 


DICT_s="/userdirs/ram_coders/DEEP/preprocess_wiki/input_data/dict.en_XX.txt"
DICT_t="/userdirs/ram_coders/DEEP/preprocess_wiki/input_data/dict.si_LK.txt"

fairseq-preprocess \
  --source-lang en_XX \
  --target-lang si_LK \
  --trainpref /userdirs/ram_coders/DEEP/preprocess_translit/output_data/train.bpe \
  --validpref /userdirs/ram_coders/DEEP/preprocess_translit/output_data/valid.bpe \
  --destdir /userdirs/ram_coders/DEEP/preprocess_translit/output_data/preprocess \
  --thresholdtgt 0 \
  --thresholdsrc 0 \
  --srcdict $DICT_s \
  --tgtdict $DICT_t \
  --workers 70 