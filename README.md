# FalaBrasil scripts for ESPnet

This repo adapts ESPnet's original recipes mainly for phoneme-based speech
synthesis (TTS). MFA-reliance has been made default instead of training an
end-to-end aligner head or relying on tacotron's as teacher.

The whole purpose of these TTS experiments is to serve as quality assessment
of phonetic aligners in Brazilian Portuguese, therefore some other info may be
found at [UFPAlign's repo](https://github.com/falabrasil/ufpalign).


## Usage

```bash
$ git clone https://github.com/falabrasil/espnet-br.git
$ git clone https://github.com/espnet/espnet.git
$ cp -r espnet-br/egs2/ljspeech-debug espnet/egs2
$ cd espnet/egs2/ljspeech-debug
$ ./run.sh  # watch: install dependencies on a venv beforehand
```

:warning: Decoding consumes a lot of RAM, so number of jobs was reduced to 4.
Make sure you gotta at least 16 GB + swap. Training without GPU is unadvised.

My setup:

- OS: Ubuntu 22.04.2 LTS x86\_64
- Kernel: 5.15.0-70-generic
- CPU: AMD Ryzen 5 4600G with Radeon Graphics (12) @ 3.700GHz
- GPU: NVIDIA GeForce GTX 1060 6GB
- Memory: 22782MiB / 31894MiB
- Disk (/): 84G / 98G (90%) NVMe + 1 TB HDD


## Dependencies

The following assumes miniconda and nvidia drivers are already installed.

As of April 2023: PyTorch=v2.0.0, CUDA=v11.7, ESPnet=v202301, MFA=2.2.9.

```bash
$ conda create --name ufpa-espnet-mfa-py39 python=3.9 --yes
$ conda activate ufpa-espnet-mfa-py39
(ufpa-espnet-mfa-py39) $ pip install pip -U && \
    pip install torch torchvision torchaudio && \
    pip install 'espnet[all]' phonemizer && \
    conda install -c conda-forge montreal-forced-aligner --yes
```


## Recipes

### LJSpeech

Runs the default recipe with MFA alignments in a data-constrained environment
(2h from 1000 utts out of 13k) mainly for debug purposes. Also, prevents MFA
from training acoustic and g2p models by downloading the pre-trained ones from
MFA servers (saves a lot of time).

:warning: ESPnet's original recipe has lots of flaws w.r.t. MFA usage, see #1.

### Constituicao

Same as above, but uses MFA's Portuguese models. Also filters only to utts in
between 5s and 30s (see #2). I had a really hard time with the global stats
collection since the duration of the frames was not matching the feat length.
`silfix.py` was written exclusively to fix the problem for some hand-selected
utts.


## Data

Both datasets are sampled at 22050 Hz. LJSpeech is roughly 3x bigger than
Constituicao, however the number of files is 10x greater, which means
Constituicao's utts are longer (see #2).

- LJSpeech: 24h. Total Duration of 13100 files: 23:55:17.08
- Constituicao: 9h. Total Duration of 1255 files: 08:58:21.94


[![FalaBrasil](https://gitlab.com/falabrasil/avatars/-/raw/main/logo_fb_git_footer.png)](https://ufpafalabrasil.gitlab.io/ "Visite o site do Grupo FalaBrasil") [![UFPA](https://gitlab.com/falabrasil/avatars/-/raw/main/logo_ufpa_git_footer.png)](https://portal.ufpa.br/ "Visite o site da UFPA")

__Grupo FalaBrasil (2023)__ - https://ufpafalabrasil.gitlab.io/      
__Universidade Federal do Pará (UFPA)__ - https://portal.ufpa.br/     
Cassio T. Batista - https://cassiotbatista.github.io/    
