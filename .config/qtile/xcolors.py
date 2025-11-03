import subprocess

xcolors = {}


def _load_xcolors():
    q = subprocess.run(
        "xrdb -query",
        shell=True,
        stdout=subprocess.PIPE,
        check=True,
        universal_newlines=True,
        stderr=subprocess.PIPE,
    ).stdout.strip()

    lines = q.splitlines()

    for line in lines:
        c = line.split("\t")
        key = c[0][:-1]
        value = c[1]
        xcolors[key] = value


_load_xcolors()
