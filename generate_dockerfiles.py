#!/usr/bin/env python3

import argparse
import csv
from pathlib import Path
from string import Template


def get_lines(cfg_path):
    with cfg_path.open() as cfg_file:
        return [line.strip() for line in cfg_file.readlines()]


def get_template(template_path):
    with template_path.open() as template_file:
        return Template(template_file.read())


parser = argparse.ArgumentParser(description=(
    'Generate Dockerfiles for all permutations of Python, Mono, and pythonnet '
    'versions.'))
parser.add_argument(
    '--outdir', type=str, default="_dockerfiles",
    help='Output directory for Dockerfiles')
parser.add_argument(
    '--configfile', type=str, default="config.csv",
    help='Comma separated values file with configurations')
parser.add_argument(
    '--snippetsdir', type=str, default="snippets",
    help='Directory with template snippets')

args = parser.parse_args()

outdir = Path(args.outdir)
configfile = Path(args.configfile)
snippetsdir = Path(args.snippetsdir)
assert outdir.is_dir()
assert configfile.is_file()
assert snippetsdir.is_dir()

with configfile.open(newline='') as csvfile:
    configdata = [row for row in csv.DictReader(csvfile)]

template = get_template(Path("Dockerfile.template"))
snippets = {f.name: get_template(f) for f in snippetsdir.iterdir() if not f.is_dir()}

for cfg in configdata:
    debian_version = cfg["debian_version"]
    python_version = cfg["python_version"]
    mono_version = cfg["mono_version"]
    pythonnet_version = cfg["pythonnet_version"]

    # select and build the right snippets for Mono and Pythonnet
    if False:
        # This branch never runs but is kept for reference in case we need to
        # install from Github "master" again in future. This was necessary when
        # 2.4.0 was in pre-release state for a prolonged amount of time.
        pythonnet_snippet_name = 'pythonnet-from-github'
    else:
        pythonnet_snippet_name = 'pythonnet-from-pypi'
    pythonnet_snippet = snippets[pythonnet_snippet_name].safe_substitute(
        PYTHONNET_VERSION=pythonnet_version)

    mono_snippet = snippets['mono'].safe_substitute(MONO_VERSION=mono_version)

    # build Dockerfile filename and content
    fname = (
        f"python{python_version}-mono{mono_version}-pythonnet{pythonnet_version}"
    )

    debian_version = "buster" if python_version.startswith("3.8") else "stretch"

    content = template.safe_substitute(
        DEBIAN_VERSION=debian_version,
        PYTHON_VERSION=python_version,
        MONO_SNIPPET=mono_snippet,
        PYTHONNET_SNIPPET=pythonnet_snippet,
    )
    # write Dockerfile
    outfile = outdir / fname
    with outfile.open('w') as out_file:
        print(f"Writing {outfile}")
        out_file.write(content)
