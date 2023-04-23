#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

fs=22050
n_shift=256

#--g2p_model espeak_ng_english_us_vits \
#--language english_us_espeak  \
fbscripts/utils/mfa.sh \
    --train false \
    --cleaner tacotron \
    --samplerate ${fs} \
    --hop-size ${n_shift} \
    --clean_temp false \
    "$@"
