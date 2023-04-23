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

train_set=train_phn
valid_set=dev_phn
test_sets=test_phn

train_config=conf/tuning/train_fastspeech2.yaml
inference_config=conf/tuning/decode_fastspeech.yaml

# expose data dir. if it exists, script will know, else it'll be downloaded
export CONSTITUICAO=/mnt/audio-datasets/falabrasil/speech-datasets

local/run_mfa.sh \
  --nj 8 \
  --stage 0 \
  --stop_stage 6 \
  --local_data_opts "--min_wav_duration 5 --max_wav_duration 30"

exit 0

#--feats_normalize none \
#--stop_stage 6 \
./tts.sh \
  --nj 8 \
  --stage 2 \
  --inference_nj 4 \
  --gpu_inference false \
  --min_wav_duration 5 \
  --max_wav_duration 30 \
  --lang pt-br \
  --feats_type raw \
  --fs "${fs}" \
  --n_fft "${n_fft}" \
  --n_shift "${n_shift}" \
  --token_type phn \
  --cleaner none \
  --g2p none \
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
