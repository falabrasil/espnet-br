#!/usr/bin/env python3
#
# gambiarra to avoid AssertionError on len(x) != d.sum().
# feature length didn't match the duration of the frames.
# https://github.com/espnet/espnet/issues/2664
# https://github.com/espnet/espnet/issues/4113
#
# author: apr 2023
# cassio batista


import argparse
import logging
import os
import shutil
import sys
from typing import List, Dict


denylist = [
  "locutor_dt032",
  "locutor_dt092",
  "locutor_art130_",
  "locutor_art171",
  "locutor_art189",
  "locutor_art177c",
  "locutor_art082",
]

allowlist = [
  "locutor_dt093",
]

logging.basicConfig(
  format="%(filename)s %(levelname)8s %(message)s",
  level=logging.INFO
)

parser = argparse.ArgumentParser()
parser.add_argument("text_file")
parser.add_argument("durations_file")
args = parser.parse_args()

# load text file
text: Dict[str, List[str]] = {}
with open(args.text_file) as f:
  for line in f:
    line = line.strip()
    if not line:
      continue
    uttid, _, phn = line.partition(' ')
    assert uttid not in text.keys(), f"my name is inigo montoya: {uttid}"
    text[uttid] = phn.split()

# load durations file
durations = {}
with open(args.durations_file) as f:
  for line in f:
    line = line.strip()
    if not line:
      continue
    uttid, _, durs = line.partition(' ')
    assert uttid not in durations.keys(), f"you killed my father: {uttid}"
    assert uttid in text.keys(), f"prepare to die: {uttid}"
    durations[uttid] = durs.split()

# overwrites durations file with the fix
if not os.path.isfile(args.durations_file + ".bkp"):
  shutil.copy(args.durations_file, args.durations_file + ".bkp")
with open(args.durations_file, "w") as f:
  for uttid, dur in durations.items():
    phn = text[uttid]
    if uttid in denylist:
      logging.info(f"before: {uttid} {' '.join(dur)}")
      if dur[-2] == "0" and dur[-1] == "0":
        dur[-2] = "1"
      elif dur[-1] == "0":
        dur[-1] = "1"
      else:
        dur.append("1")
      logging.info(f"after : {uttid} {' '.join(dur)}")
    f.write(f"{uttid} {' '.join(dur)}\n")

logging.info(f"hopefully {args.durations_file} has been fixed")
