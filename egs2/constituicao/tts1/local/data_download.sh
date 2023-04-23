#!/usr/bin/env bash
#
# author: apr 2023
# cassio batista

[ $# -ne 1 ] && echo "usage: $0 <fb-speech-datasets-repo>" && exit 1
dir=$1

# /mnt/audio-datasets/falabrasil/speech-datasets
if [ -d $dir ] ; then
  echo "$0: git repo exists. skipping clone..."
else
  git clone https://github.com/falabrasil/speech-datasets.git $dir
fi

# /mnt/audio-datasets/falabrasil/speech-datasets/datasets/constituicao/data/locutor/art212b.wav
if [ -f $dir/datasets/constituicao/data/locutor/art212b.wav ] ; then
  echo "$0: files seem to have been already pulled from gdrive. skipping download..."
else
  cd $dir && dvc pull -r public datasets/constituicao && cd -
fi
