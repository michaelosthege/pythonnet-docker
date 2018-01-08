#!/usr/bin/env python3

import argparse
import itertools
from pathlib import Path
from string import Template


def get_lines(cfg_path):
    with cfg_path.open() as cfg_file:
        return [l.strip() for l in cfg_file.readlines()]


def get_template(template_path):
    with template_path.open() as template_file:
        return Template(template_file.read())


parser = argparse.ArgumentParser(description=(
	'Generate Dockerfiles for all permutations of Python, Mono, and pythonnet '
	'versions.'))
parser.add_argument(
    '--outdir', type=str, default=".",
    help='Output directory for Dockerfiles')
parser.add_argument(
    '--configdir', type=str, default="config",
    help='Directory with configuration files')
parser.add_argument(
    '--snippetsdir', type=str, default="snippets",
    help='Directory with template snippets')

args = parser.parse_args()

outdir = Path(args.outdir)
configdir = Path(args.configdir)
snippetsdir = Path(args.snippetsdir)
assert outdir.is_dir()
assert configdir.is_dir()
assert snippetsdir.is_dir()

python_versions = get_lines(configdir / "python_versions")
mono_versions = get_lines(configdir / "mono_versions")
pythonnet_versions = get_lines(configdir / "pythonnet_versions")
template = get_template(Path("Dockerfile.template"))
snippets = {
    f.name: get_template(f) for f in snippetsdir.iterdir() if not f.is_dir()}

print("Python tags: %s" % ", ".join(python_versions))
print("Mono versions: %s" % ", ".join(mono_versions))
print("Pythonnet versions: %s" % ", ".join(pythonnet_versions))
print("Snippets found: %s" % ", ".join(snippets.keys()))

combinations = itertools.product(python_versions, mono_versions, pythonnet_versions)
for python_version, mono_version, pythonnet_version in combinations:
    # skip incompatible combinations of Mono and pythonnet
    if mono_version.startswith('5') and not pythonnet_version.startswith('2.4'):
        continue

    # select and build the right snippets for Mono and Pythonnet
    if pythonnet_version.startswith('2.4'):
        pythonnet_snippet_name = 'pythonnet-from-github'
    else:
        pythonnet_snippet_name = 'pythonnet-from-pypi'
    pythonnet_snippet = snippets[pythonnet_snippet_name].safe_substitute(
        PYTHONNET_VERSION=pythonnet_version)

    mono_snippet_name = 'mono5' if mono_version.startswith('5') else 'mono4'
    mono_snippet = snippets[mono_snippet_name].safe_substitute(
        MONO_VERSION=mono_version)

    # build Dockerfile filename and content
    fname = (
        f"python{python_version}-mono{mono_version}-"
        f"pythonnet{pythonnet_version}.Dockerfile"
    )
    content = template.safe_substitute(
        PYTHON_VERSION=python_version,
        MONO_SNIPPET=mono_snippet,
        PYTHONNET_SNIPPET=pythonnet_snippet,
    )
    # write Dockerfile
    with (outdir / fname).open('w') as out_file:
        out_file.write(content)
