---
layout: AcrogenesisCom.PostLayout
title: "Running Intel Python on M1"
slug: "running-intel-python-on-m1"
date: "2021-11-25"
author: acrogenesis
comments: true
permalink: /:slug
---
Following these instructions should enable you to have both arm and intel python installed and ready to use.

You should run everything you can with arm version of python. Only use the intel version if you are having trouble.

If you've previously tried installing python with any other method, be sure to fully remove it.

We'll start setting up our arm and intel environments by setting up a Rossetta-Terminal, which runs on intel. Follow the [Create a Rosetta Terminal](https://www.courier.com/blog/tips-and-tricks-to-setup-your-apple-m1-for-development){:target="_blank"} tutorial.

## Python3 ARM Installation

### These two steps must be run in the regular Terminal (arm)

1. Install [brew](https://brew.sh){:target="_blank"} in Terminal.

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install python3 running `brew install python3`.

> Hombrew keeps `x86` binaries in `/usr/local` and uses `/opt/homebrew` for their `ARM` binaries.

## Python3 Intel Installation

### All the steps below should be run in Rosetta-Terminal

1. Install [brew](https://brew.sh){:target="_blank"} in Rosetta-Terminal.
2. Create alias in `~/.zprofile` for intel brew `alias ibrew='arch -x86_64 /usr/local/bin/brew'`.
   Your `~/.zprofile` should look like this.

```sh
eval "$(/opt/homebrew/bin/brew shellenv)"
alias ibrew='arch -x86_64 /usr/local/bin/brew'
```

4. Load alias running

```sh
source ~/.zprofile
```

5. Install intel python3

```sh
ibrew install python3
```

You can specify a version like this:

```sh
ibrew install python@3.7
```

This previous step will give you where python is installed, e.g. `/usr/local/opt/python@3.7/bin/python3`
![Python Install Location](/assets/images/python-install-location.png)

You should now have installed both arm and intel versions of python. Whenever you need to use intel python, be sure to open the Rosetta-Terminal and load the intel python. For example, if you use `pipenv` for managing virtual envs and packages, run this in your project folder:

```sh
pipenv shell --python /usr/local/opt/python@3.7/bin/python3
```
