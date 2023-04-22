#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

fs=22050
n_fft=1024
n_shift=256

opts=
if [ "${fs}" -eq 22050 ]; then
    # To suppress recreation, specify wav format
    opts="--audio_format wav "
else
    opts="--audio_format flac "
fi

train_set=tr_no_dev_phn
valid_set=dev_phn
test_sets=eval1_phn

train_config=conf/tuning/train_fastspeech2.yaml
inference_config=conf/tuning/decode_fastspeech.yaml

# g2p=g2p_en # Include word separator
g2p=none # g2p_en_no_space # Include no word separator

# expose data dir. if it exists, script will know, else it'll be downloaded
export LJSPEECH=/mnt/audio-datasets

local/run_mfa.sh \
  --nj 8 \
  --stage 0 \
  --stop_stage 6 

./tts.sh \
    --nj 8 \
    --inference_nj 4 \
    --gpu_inference false \
    --stage 2 \
    --lang en \
    --feats_type raw \
    --fs "${fs}" \
    --n_fft "${n_fft}" \
    --n_shift "${n_shift}" \
    --token_type phn \
    --cleaner tacotron \
    --g2p "${g2p}" \
    --train_config "${train_config}" \
    --inference_config "${inference_config}" \
    --train_set "${train_set}" \
    --valid_set "${valid_set}" \
    --test_sets "${test_sets}" \
    --srctexts "data/${train_set}/text" \
    --teacher_dumpdir data \
    --write_collected_feats true \
    --tts_stats_dir data/stats \
    ${opts} "$@"
