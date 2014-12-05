# sweater-weather.zsh-theme - based on smt by , based on dogenpunk by Matthew Nelson.

MODE_INDICATOR="%{$fg_bold[red]%}❮%{$reset_color%}%{$fg[red]%}❮❮%{$reset_color%}"
local return_status="%{$fg[red]%}%(?..⏎)%{$reset_color%} "

ZSH_THEME_GIT_PROMPT_PREFIX=" ❯❯ "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" ❯❯%{$fg_bold[red]%} ⨂ ⨂ ⨂%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD=" ❯❯%{$fg_bold[yellow]%} ⨁ ⨁ ⨁%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" ❯❯%{$fg_bold[cyan]%} ⨀ ⨀ ⨀%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_ADDED="%{$bg[green]%} ✚ "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$bg[blue]%} ✹  "
ZSH_THEME_GIT_PROMPT_DELETED="%{$bg[red]%} ✖  "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$bg[magenta]%} ➜  "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$bg[yellow]%} ═  "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$bg[cyan]%} ✭  "

# Format for git_prompt_long_sha() and git_prompt_short_sha()
ZSH_THEME_GIT_PROMPT_SHA_BEFORE=" ❯❯ %{$fg_bold[cyan]%}"
ZSH_THEME_GIT_PROMPT_SHA_AFTER="%{$reset_color%}"

function prompt_char() {
  git branch >/dev/null 2>/dev/null && echo "%{$fg[cyan]%}❉ ❉ ❉%{$reset_color%}" && return
  hg root >/dev/null 2>/dev/null && echo "%{$fg_bold[red]%}☿%{$reset_color%}" && return
  darcs show repo >/dev/null 2>/dev/null && echo "%{$fg_bold[green]%}❉%{$reset_color%}" && return
  echo "%{$fg[cyan]%}◯%{$reset_color%}"
}

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$bg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$bg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$bg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$bg[cyan]%}"

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function git_time_since_commit() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
        # Only proceed if there is actually a commit.
        if [[ $(git log 2>&1 > /dev/null | grep -c "^fatal: bad default revision") == 0 ]]; then
            # Get the last commit.
            last_commit=`git log --pretty=format:'%at' -1 2> /dev/null`
            now=`date +%s`
            seconds_since_last_commit=$((now-last_commit))

            # Totals
            MINUTES=$((seconds_since_last_commit / 60))
            HOURS=$((seconds_since_last_commit/3600))

            # Sub-hours and sub-minutes
            DAYS=$((seconds_since_last_commit / 86400))
            SUB_HOURS=$((HOURS % 24))
            SUB_MINUTES=$((MINUTES % 60))

            if [[ -n $(git status -s 2> /dev/null) ]]; then
                if [ "$MINUTES" -gt 30 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG"
                elif [ "$MINUTES" -gt 10 ]; then
                    COLOR="$ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM"
                else
                    COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT"
                fi
            else
                COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            fi

            if [ "$HOURS" -gt 24 ]; then
                echo "$COLOR  ${DAYS}d${SUB_HOURS}h${SUB_MINUTES}m%{  $reset_color%} "
            elif [ "$MINUTES" -gt 60 ]; then
                echo "$COLOR  ${HOURS}h${SUB_MINUTES}m%{  $reset_color%} "
            else
                echo "$COLOR  ${MINUTES}m%{  $reset_color%} "
            fi
        else
            COLOR="$ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL"
            echo "$COLOR  ~"
        fi
    fi
}

PROMPT='
%{$fg[blue]%}%m%{$reset_color%} ⏣ %{$fg[cyan]%}%~ %{$reset_color%}$(git_prompt_short_sha)$(git_prompt_info)
%{$fg[red]%}%!%{$reset_color%} $(prompt_char) ⧈ '

RPROMPT='${return_status}$(git_time_since_commit)$(git_prompt_status)%{$reset_color%}  '
