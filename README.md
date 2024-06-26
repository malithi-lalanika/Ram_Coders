## Steps:
### 1. Setup environments

Mainly in here there are two environments.
- ner

For create the environment go to the Noising folder:
```
conda env create -f ner.yml
```
Activate the environment using
```
source activate ner
```
Check the dependencies using
```
conda list
```
Sometimes in here we can see only pip packages were installed and dependencies not installed. So you have to install those dependencies manually by using .yml file dependencies. For example,
```
pip install numpy==1.23.4
```

- mbart50

For create the environment go to the NMT_Final_Code folder:
```
conda env create -f mbart50.yml
```
You can add other dependencies same as the ner environment.

But in here you have to install modified fariseq folder. To do that,
```
cd NMT_Final_Code/fairseq
pip install --editable ./
```

- test (Additional If needed)

This environment was used to the preprocessing and evaluating  tasks since the mbart50 environment was not supported. If mbart50 is supported you can use that environment for those tasks as well.

For create the test environment you can simply create a test.yml file containing "name: test" as the first line. (use a copy of mbart50.yml file for this). Then install the fairseq modified folder. 

```
cd NMT_Final_Code/Fairseq_Folder for evaluate If needed/fairseq
pip install --editable ./
```

### 2. Noising monolingual data.

Go to the Noising/noise_for_en_to_si_tt.py file and change below paths:
- model_checkpoint (model was uploaded to the google drive)
- index ( change the range with the number of sentences in the blog_data.txt file)
- path (blog_data.txt file path)
- four output paths for valid, train csv files.

Then run below commands:

```
source activate ner
bash python noise_for_en_to_si_tt.py
```

Then after running you should rename four output files as below.
- train_si.csv -> train.si
- train_en.csv -> train.en
- valid_si.csv -> valid.si
- valid_en.csv -> valid.en

After that remove the first line header of those 4 files. (sentences or noise_sentences_with_translit_and_translate)

### 3. Preprocess noised data for mbart objective pretrain

First you have to download the mbart50 model
```
wget https://dl.fbaipublicfiles.com/fairseq/models/mbart50/mbart50.pretrained.tar.gz
tar -xzvf mbart50.pretrained.tar.gz
```
Go to the NMT_Final_Code/train_scripts/preprocess_for_mbart50_pretrain.sh file and change below paths
- spm_encode.py file path (Add the file path inside the fairseq folder of test environment)
- sentence.bpe.model (inside the mbart50 model folder)
- inputs ( train.si, valid.si file paths from step 2) 
- outputs folder paths
- DICT path ( there is an dictionary inside the mbart50 model folder and rename it with the language in here it is si_LK)
- trainpref, validpref same as the outputs paths without language extension
- destdir path 

Run Below command to the preprocessing:
```
cd NMT_Final_Code/train_scripts
source activate test
bash preprocess_for_mbart50_pretrain.sh
```
Rename files inside the preprocess folder as below.
- train.bin
- train.idx
- valid.bin
- valid.idx

### 4. Preprocess parallel data 

Go to the NMT_Final_Code/train_scripts/preprocess_for_finetune.sh file and change below paths
- spm_encode.py file path (Add the file path inside the fairseq folder of test environment)
- sentence.bpe.model (inside the mbart50 model folder)
- 6 input paths (train.si, valid.si, test.si, train.en, valid.en, test.en file paths from Google drive parallel dataset)
- 6 outputs paths
- DICT path ( there is an dictionary inside the mbart50 model folder and create duplicate one and rename those with languages in here en_XX and si_LK)
- trainpref, validpref and testpref same as the outputs paths without language extension
- destdir path 

Run Below command to the preprocessing:
```
cd NMT_Final_Code/train_scripts
source activate test
bash preprocess_for_finetune.sh.sh
```

### 5. Pretrain with mbart Objective

Prior to the Pretraining,

Go to the NMT_Final_Code/fairseq/fairseq/tasks/multilingual_context_shard_denoising.py file and change below paths

- args.data ( preprocessed pretrain data folder path from step 3)
- add dict.txt file (same dict.txt inside the mbart50 folder) for that folder if it does not exists. ( for "dictionary" variable)

Go to the NMT_Final_Code/train_scripts/pretrain-si-mbart50.sh file and change below paths

- Repo
- bin_dir (path of the preprocessed parallel data from step 4)
- SAVE
- after "fairseq-train" preprocessed pretrain data folder path from step 3
- restore-file (mbart50 model path)
- save-dir (model saving path and the log file path)

Run Below command to the pretraing:
```
cd NMT_Final_Code/train_scripts
source activate mbart50
bash train-scripts/pretrain-si-mbart50.sh
```

### 6. Preprocess noised data for deep objective pretrain

Go to the NMT_Final_Code/train_scripts/preprocess_for_deep_pretrain.sh file and change below paths
- spm_encode.py file path (Add the file path inside the fairseq folder of test environment)
- sentence.bpe.model (inside the mbart50 model folder)
- 4 input paths ( train.si, valid.si, train.en, valid.en from step 2)
- 4 outputs paths
- DICT path ( there is an dictionary inside the mbart50 model folder and create duplicate one and rename those with languages in here en_XX and si_LK)
- trainpref and validpref same as the outputs paths without language extension
- destdir path 

Run Below command to the preprocessing:
```
cd NMT_Final_Code/train_scripts
source activate test
bash preprocess_for_deep_pretrain.sh
```
Rename files inside the preprocess folder as below.

- train.en_XX-si_LK.si_LK.bin  -> train0.tgt.bin
- train.en_XX-si_LK.si_LK.idx  -> train0.tgt.idx

- train.en_XX-si_LK.en_XX.bin  -> train0.src.bin
- train.en_XX-si_LK.en_XX.idx  -> train0.src.idx

- valid.en_XX-si_LK.si_LK.bin  -> valid.tgt.bin
- valid.en_XX-si_LK.si_LK.idx  -> valid.tgt.idx

- valid.en_XX-si_LK.en_XX.bin  -> valid.src.bin
- valid.en_XX-si_LK.en_XX.idx  -> valid.src.idx

After that if you get an error like .mask files are not there follow below guidelines.
  - duplicate your .tgt 4 files.( train0.tgt.bin,  train0.tgt.idx,  valid.tgt.bin,  valid.tgt.idx)
  - rename those from .tgt -> .mask (  train0.tgt.bin -> train0.mask.bin )

### 7. Continual pretraining with Deep Objective

Prior to the Pretraining,

Go to the NMT_Final_Code/fairseq/fairseq/tasks/multilingual_context_shard_denoising.py file and change below paths

- args.data ( preprocessed pretrain data folder path from step 6)
- add dict.txt file (same dict.txt inside the mbart50 folder) for that folder if it does not exists. ( for "dictionary" variable)

Go to the NMT_Final_Code/train_scripts/pretrain-si-mbart50-deep.sh file and change below paths

- Repo
- bin_dir (path of the preprocessed parallel data from step 4)
- SAVE
- after "fairseq-train" preprocessed pretrain data folder path from step 6(If it asks for files inside a folder like Si_XX you can move them to the folder)
- restore-file (checkpoint_best.pt from the mbart objective pretrain outputs)
- save-dir (model saving path and the log file path)

Run Below command to the pretraing:
```
cd NMT_Final_Code/train_scripts
source activate mbart50
bash train-scripts/pretrain-si-mbart50-deep.sh
```

### 8. Fine-tune

Go to the NMT_Final_Code/train_scripts/finetune-si-mbart50.sh file and change below paths

- Repo
- bin_dir (path of the preprocessed parallel data from step 4)
- SAVE
- lang_list ( this is located in NMT_Final_Code/fairseq/examples/multilingual path)
- pretrained_model (checkpoint_best.pt from the deep objective pretrain outputs)
- save-dir (model saving path and the log file path)

Run Below command to the finetuning:
```
cd NMT_Final_Code/train_scripts
source activate mbart50
bash train-scripts/finetune-si-mbart50.sh [0]
```

### 9. Evaluate

Go to the NMT_Final_Code/train_scripts/eval-si-mbart50.sh file and change below paths

- bin_dir (path of the preprocessed parallel data from step 4)
- lang_list ( this is located in NMT_Final_Code/fairseq/examples/multilingual path)
- path (checkpoint_best.pt or checkpoint_last.pt from the finetune outputs)
- output file path

Run Below command to the evaluating :
```
cd NMT_Final_Code/train_scripts
source activate test
bash train-scripts/eval-si-mbart50.sh [0]
```
### 10. Get Predicted text for testing sentences and return the sacrebleu 

First change the paths for these commands. true.txt file was uploaded to the Google Drive and preds.txt is the predicted sentences file (you can add any_path/preds.txt file is no need to upload). en_XX_si_LK.txt is the output of step 9.
```
cat /userdirs/ram_coders/DEEP/deep_ft/outputs/finetune/en_to_si_further/mbart50-ft-mbart-obj/en_XX_si_LK.txt | grep -P "^H" |sort -V |cut -f 3-  > /userdirs/ram_coders/DEEP/deep_ft/outputs/finetune/en_to_si_further/mbart50-ft-mbart-obj/preds.txt
sacrebleu -tok 'none' -s 'none' /userdirs/ram_coders/DEEP/deep_ft/outputs/finetune/en_to_si_further/mbart50-ft-mbart-obj/true.txt< /userdirs/ram_coders/DEEP/deep_ft/outputs/finetune/en_to_si_further/mbart50-ft-mbart-obj/preds.txt
```
### 11. Get translate for a input sentence (Additional task)

- Add an english sentence to the NMT_Final_Code/get_translate_mbart50/translate_input.txt file.
- Change required paths in the NMT_Final_Code/get_translate_mbart50/get-translate.sh file.
- Run Below command to get the translation
```
bash NMT_Final_Code/get_translate_mbart50/get-translate.sh.sh
```
or remove 3rd and 4th line from get-translate.sh.sh and run below.
```
source activate test
bash NMT_Final_Code/get_translate_mbart50/get-translate.sh.sh
```

- translated sentence was written to the NMT_Final_Code/get_translate_mbart50/translation_output.txt file.
