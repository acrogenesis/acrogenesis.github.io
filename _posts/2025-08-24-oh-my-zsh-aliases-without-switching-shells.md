---
layout: AcrogenesisCom.PostLayout
title: "Get Oh My Zsh Aliases without zsh"
slug: "get-oh-my-zsh-aliases-without-zsh"
date: "2025-08-24"
author: acrogenesis
comments: true
permalink: /:slug
---

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

### Update Aug. 26 2025

If you also want completions for your git and kubectl aliases this code makes it work although it's more complicated.

### Step 1

Install `bash-completition`

```bash
yay -S bash-completition
```

```bash
source /usr/share/bash-completion/bash_completion

# ===================================================================
# Dynamically Load Aliases from Oh My Zsh Plugin Files
# ===================================================================

# 1. Set the path to your Oh My Zsh installation
export OMZ_DIR="$HOME/.oh-my-zsh"

# 2. List the plugins you want to "borrow" aliases from
OMZ_PLUGINS=(
  git
  kubectl
  elixir
  bundler
)

# --- Completion helpers ----------------------------------------------------
__omz_load_kubectl_completion() {
  [[ -n ${__OMZ_KC_LOADED:-} ]] && return 0
  command -v kubectl &>/dev/null || return 0
  declare -F __start_kubectl >/dev/null || source <(kubectl completion bash)
  __OMZ_KC_LOADED=1
}

__omz_load_git_completion() {
  [[ -n ${__OMZ_GIT_LOADED:-} ]] && return 0
  command -v git &>/dev/null || return 0
  if ! (declare -F __git_wrap__git_main >/dev/null || declare -F _git >/dev/null || declare -F __git_main >/dev/null); then
    for f in /usr/share/bash-completion/completions/git /etc/bash_completion.d/git; do [[ -r $f ]] && . "$f" && break; done
  fi
  __OMZ_GIT_LOADED=1
}

# Unified completion function for git & kubectl aliases.
# 1. Look up full expansion
# 2. Inject its tokens in front of user input so native completion sees real command
# 3. Delegate to command-specific completion
__omz_alias_complete() {
  local name=${COMP_WORDS[0]}
  local expansion=${__omz_alias_map[$name]}
  [[ -n $expansion ]] || return 0

  # Fast path: single-word alias (rare for our target, but cheap to check)
  if [[ $expansion != *' '* ]]; then
    case $expansion in
      kubectl) __omz_load_kubectl_completion; __start_kubectl 2>/dev/null; return ;;
      git)     __omz_load_git_completion;   ;; # Git's main completion entry already handles base command
    esac
  fi

  # shellcheck disable=SC2206
  local base_tokens=( $expansion )          # expansion split safely by IFS=space semantics
  local oc=$COMP_CWORD                      # original cursor index
  local rest=( "${COMP_WORDS[@]:1}" )      # original args after alias word
  COMP_WORDS=( "${base_tokens[@]}" "${rest[@]}" )
  COMP_CWORD=$(( oc + ${#base_tokens[@]} - 1 ))

  case ${base_tokens[0]} in
    kubectl)
      __omz_load_kubectl_completion
      __start_kubectl 2>/dev/null
      ;;
    git)
      __omz_load_git_completion
      # Provide variables some git completion variants expect
      words=( "${COMP_WORDS[@]}" ); cword=$COMP_CWORD; cur=${COMP_WORDS[COMP_CWORD]}; prev=${COMP_WORDS[COMP_CWORD-1]}
      if declare -F __git_wrap__git_main >/dev/null; then __git_wrap__git_main; \
      elif declare -F _git >/dev/null; then _git; \
      elif declare -F __git_main >/dev/null; then __git_main; fi
      # Fallback: suggest remotes immediately after push if none yet
      if [[ ${COMP_WORDS[1]} == push && $COMP_CWORD -eq 2 && ${#COMPREPLY[@]} -eq 0 ]]; then
        mapfile -t COMPREPLY < <(git remote 2>/dev/null | sed 's/$/ /')
      fi
      ;;
  esac
}

###############################################
# Parse Oh My Zsh plugin alias definitions
# (idempotent; only captures kubectl/git aliases for completion)
###############################################
if [[ -z ${__OMZ_ALIAS_MAPS_LOADED:-} ]]; then
  declare -gA __omz_alias_map
  for plugin in "${OMZ_PLUGINS[@]}"; do
    plugin_file="$OMZ_DIR/plugins/$plugin/$plugin.plugin.zsh"
    [[ -f $plugin_file ]] || continue
    while IFS= read -r line; do
      [[ $line == alias\ * ]] || continue
      name=${line#alias }      # strip leading 'alias '
      name=${name%%=*}
      value=${line#*=}
      q=${value:0:1}
      if [[ $q == "'" || $q == '"' ]]; then
        value=${value:1:${#value}-2}       # remove surrounding quotes
      fi
      printf -v quoted '%q' "$value"
      eval "alias $name=$quoted" 2>/dev/null || true
      case $value in
        kubectl*|git*) __omz_alias_map[$name]="$value" ;;
      esac
    done < "$plugin_file"
  done
  unset name value q quoted
  __OMZ_ALIAS_MAPS_LOADED=1
fi

# Attach unified completion (re-runnable)
for a in "${!__omz_alias_map[@]}"; do complete -F __omz_alias_complete "$a" 2>/dev/null || true; done
```
