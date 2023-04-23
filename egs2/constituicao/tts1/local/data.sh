#!/usr/bin/env bash

set -e
set -u
#set -o pipefail

log() {
    local fname=${BASH_SOURCE[1]##*/}
    echo -e "$(date '+%Y-%m-%dT%H:%M:%S') (${fname}:${BASH_LINENO[0]}:${FUNCNAME[1]}) $*"
}
SECONDS=0

stage=-1
stop_stage=2
min_wav_duration=0.1
max_wav_duration=20

log "$0 $*"

#if [ $# -ne 0 ]; then
#    log "Error: No positional arguments are required."
#    exit 2
#fi

. ./path.sh || exit 1;
. ./utils/parse_options.sh || exit 1;

if [ -z "${CONSTITUICAO}" ]; then
   log "Fill the value of 'CONSTITUICAO'"
   exit 1
fi
db_root=${CONSTITUICAO}

if [ ${stage} -le -1 ] && [ ${stop_stage} -ge -1 ]; then
    log "stage -1: Data Download"
    local/data_download.sh "${CONSTITUICAO}"
fi

if [ ${stage} -le 0 ] && [ ${stop_stage} -ge 0 ]; then
    log "stage 0: Data Preparation"

    corpus_dir="${db_root}/datasets/constituicao"
    for subset in train dev test ; do
				n=$(wc -l < $corpus_dir/$subset.list)
				# set filenames
				scp=data/$subset/wav.scp
				utt2spk=data/$subset/utt2spk
				spk2utt=data/$subset/spk2utt
				text=data/$subset/text
				durations=data/$subset/durations

				# check file existence
				[ ! -e data/$subset ] && mkdir -p data/$subset
				[ -e ${scp} ] && rm ${scp}
				[ -e ${utt2spk} ] && rm ${utt2spk}
				[ -e ${spk2utt} ] && rm ${spk2utt}
				[ -e ${text} ] && rm ${text}
				[ -e ${durations} ] && rm ${durations}
        i=0
				spkid=locutor
        while read line ; do
						wav=$corpus_dir/$line
						txt=${wav%.wav}.txt
            (( $(echo "$(soxi -D $wav) < $min_wav_duration" | bc -l) )) && continue
            (( $(echo "$(soxi -D $wav) > $max_wav_duration" | bc -l) )) && continue
						[ ! -f $wav ] || [ ! -f $txt ] && \
							echo >&2 "$0: error: bad wav or txt file: '$wav' vs. '$txt'" && exit 1
						uttid=${spkid}_$(basename ${wav%.wav} | sed 's/-/_/g')
						echo "$uttid $wav" >> $scp
						echo "$uttid $(cat $txt)" >> $text
						echo "$uttid $spkid" >> $utt2spk
						i=$((i+1))
				done < $corpus_dir/$subset.list
				#sort -u $scp -o $scp
				#sort -u $text -o $text
				#sort -u $utt2spk -o $utt2spk
				utils/fix_data_dir.sh data/$subset
				utils/utt2spk_to_spk2utt.pl $utt2spk > $spk2utt
				utils/validate_data_dir.sh --no-feats --non-print data/$subset
    done
fi

log "Successfully finished. [elapsed=${SECONDS}s]"
