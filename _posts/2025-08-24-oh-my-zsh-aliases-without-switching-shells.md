---
layout: post
title: "Get Oh My Zsh Aliases without zsh"
slug: "get-oh-my-zsh-aliases-without-zsh"
date: "2025-08-24"
author: acrogenesis
comments: true
---
## Why?

I'm using [Omarchy](https://omarchy.org/) which has a curated `bash` shell but I miss [oh my zsh](https://ohmyz.sh/) `git`, `elixir`, and `kubectl` aliases.
Here’s a quick guide to porting those aliases directly into your existing Bash environment.

### Step 1: Clone the Oh My Zsh Repo

First, we'll need the plugin files. Clone the repository to a folder in your home directory:

```bash
git clone https://github.com/ohmyzsh/ohmyzsh.git ~/.oh-my-zsh
```

### Step 2: Safely retrieve aliases

We'll add a small script at the bottom of our `~/.bashrc` to load the plugins we want.

```bash
# ===================================================================
# Dynamically Load Aliases from Oh My Zsh Plugin Files
# ===================================================================

# 1. Set the path to your Oh My Zsh installation
export OMZ_DIR="$HOME/.oh-my-zsh"

# 2. List the plugins you want to load aliases from
OMZ_PLUGINS=(
  git
  kubectl
  elixir
  bundler
  # Add other plugins here, e.g., docker, systemd, etc.
)

# 3. Loop through the plugins and load ONLY the simple alias definitions
for plugin in "${OMZ_PLUGINS[@]}"; do
  if [ -f "$OMZ_DIR/plugins/$plugin/$plugin.plugin.zsh" ]; then
    # Use grep to find lines starting with 'alias ', then use eval
    # to execute them as if they were written here.
    # This is safe for simple aliases like alias a='b'.
    eval "$(grep "^alias " "$OMZ_DIR/plugins/$plugin/$plugin.plugin.zsh")"
  fi
done

# Unset variables to keep the environment clean
unset OMZ_DIR
unset OMZ_PLUGINS
```

### Step 3: Reload your shell

To make the aliases available in your current session reload your `.bashrc` file.
```bash
source ~/.bashrc
```

Your new aliases are now ready to use in your bash shell. Enjoy!

