
# exit early if those utils have already been sourced
[ ! -z "$_UTILS_INCLUDED" ] && return
_UTILS_INCLUDED=1

DEFAULT=$(tput sgr0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)

function fail() {
    exit 1
}

function info {
    printf "$BLUE ℹ️ %s$DEFAULT\n" "$1"
}

function success {
    printf "$GREEN ✅  %s$DEFAULT\n" "$1"
}

function error() {
    printf "$RED ❌  %s$DEFAULT\n" "$1" 1>&2
}
