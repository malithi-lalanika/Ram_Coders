REPO=/userdirs/ram_coders/DEEP/deep_si
MAXL=1024
bin_dir=/userdirs/ram_coders/DEEP/SITA_Parallel_Dataset/output_data/preprocess   
SAVE=$REPO/outputs/


## Pre-train on si_XX


# We use a while-loop to load the latest checkpoint to continue training 
# if the job is terminated before the max step.
fairseq-train /userdirs/ram_coders/DEEP/deep_si/data/mbart_pretrain \
--restore-file /userdirs/ram_coders/mbart50/mbart50.pretrained/model.pt \
--encoder-normalize-before --decoder-normalize-before \
--arch mbart_large --layernorm-embedding \
--task multilingual_denoising \
--multilang-sampling-alpha 1.5 \
--add-lang-token \
--langs si_LK \
--skip-invalid-size-inputs-valid-test \
--criterion label_smoothed_cross_entropy --label-smoothing 0.2 \
--optimizer adam --adam-eps 1e-06 --adam-betas '(0.9, 0.98)' \
--lr-scheduler inverse_sqrt --lr 3e-05 --warmup-updates 2500 --max-update 100000 \
--dropout 0.3 --attention-dropout 0.1 --weight-decay 0.0 \
--max-tokens 400 --update-freq 8 \
--save-interval 1 --save-interval-updates 1000000 --keep-interval-updates 5 --no-epoch-checkpoints \
--seed 222 --log-format simple --log-interval 2  \
--tokens-per-sample 512 \
--sample-break-mode complete_doc \
--mask 0.3 \
--mask-random 0.1 \
--poisson-lambda 3.5 \
--permute-sentences 1 \
--mask-length span-poisson \
--replace-length 1 \
--reset-optimizer \
--fp16 \
--save-dir /userdirs/ram_coders/DEEP/deep_si/outputs/pretrain/mbart50-pt-mbart-obj > /userdirs/ram_coders/DEEP/deep_si/outputs/pretrain/mbart50-pt-mbart-obj/logs 2>&1
