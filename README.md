# FalaBrasil scripts for ESPnet

This repo contains scripts adapted from ESPnet original recipes, mainly for
speech synthesis (TTS).


## Usage

```bash
$ git clone https://github.com/falabrasil/espnet-br.git
$ git clone https://github.com/espnet/espnet.git
$ cp -r espnet-br/egs2/ljspeech-debug espnet/egs2
$ cd espnet/egs2/ljspeech-debug
$ ./run.sh  # watch: install dependencies on a venv beforehand
```

:warning: Decoding consumes a lot of RAM, make sure you gotta at least
32 GB + swap. Training without GPU is unadvised.

My setup:

- OS: Ubuntu 22.04.2 LTS x86\_64
- Kernel: 5.15.0-70-generic
- CPU: AMD Ryzen 5 4600G with Radeon Graphics (12) @ 3.700GHz
- GPU: NVIDIA GeForce GTX 1060 6GB
- Memory: 22782MiB / 31894MiB
- Disk (/): 84G / 98G (90%) NVMe + 1 TB HDD


## Dependencies

The following assumes miniconda and nvidia drivers are already installed.
By April 2023: PyTorch=v2.0.0, CUDA=v11.7, ESPnet=v202301.

```bash
$ conda create --name ufpa-espnet-mfa-py39 python=3.9 --yes
$ conda activate ufpa-espnet-mfa-py39
(ufpa-espnet-mfa-py39) $ pip install pip -U && \
    pip install torch torchvision torchaudio && \ 
    pip install 'espnet[all]' phonemizer
(ufpa-espnet-mfa-py39) $ conda install -c conda-forge montreal-forced-aligner --yes
```


## Recipes

- LJSpeech: runs the default recipe with MFA alignments in a data-constrained
  environment (1000 utts out of 13k) mainly for debug purposes. Also, prevents
  MFA from training acoustic and g2p models by downloading the pre-trained ones
  from MFA servers (saves a lot of time).
- Constituicao:TBD


[![FalaBrasil](https://gitlab.com/falabrasil/avatars/-/raw/main/logo_fb_git_footer.png)](https://ufpafalabrasil.gitlab.io/ "Visite o site do Grupo FalaBrasil") [![UFPA](https://gitlab.com/falabrasil/avatars/-/raw/main/logo_ufpa_git_footer.png)](https://portal.ufpa.br/ "Visite o site da UFPA")

__Grupo FalaBrasil (2023)__ - https://ufpafalabrasil.gitlab.io/      
__Universidade Federal do Pará (UFPA)__ - https://portal.ufpa.br/     
Cassio T. Batista - https://cassiotbatista.github.io/    
