#---  FUNCTION  ----------------------------------------------------------------
#        NAME: _add2env
# DESCRIPTION: Adds new value to env variable. The first parameter must be set,
#              rest is optional. If they are omitted then it'll be used PATH
#              as variable and : as separator.
#              It works with Bash and Ksh as well. But it does not work with Zsh yet.
#    SYNOPSIS: _add2env options
#       USAGE: _add2env value
#              _add2env variable value
#              _add2env variable value separator
#              _add2env variable=value
#     RETURNS: 0 if success, 1 otherwise
#-------------------------------------------------------------------------------
unset _add2env
function _add2env { #{{{
    if  [ $# -lt 1 ] || [ $# -gt 3 ]; then
        printf "Wrong number of arguments, must be 3 or fewer: value variable separator\n" >&2
        return 1
    else
        typeset value variable separator
        if [ $# -eq 1 ]; then
            value=${1}
            variable=PATH
            separator=:
        elif [ $# -eq 2 ]; then
            variable=$1
            value=$2
            separator=:
        else
            variable=$1
            value=$2
            separator=$3
        fi

        # _add2env VARIABLE=value
        if [[ $value =~ = ]]; then
            variable=${value%=*}
            value=${value#*=}
            separator=${2:-:}
        fi

        typeset valueOfVariable=$(eval echo "$(printf "$%s" "$variable")")
        if [ -z "$valueOfVariable" ]; then
            eval "$variable='$value'"
            # shellcheck disable=SC2163
            export "$variable"
        else
            case "$valueOfVariable" in
                ${value}${separator}* | *${separator}${value}${separator}* | *${separator}${value} | $value )
                    ;;
                *)
                    eval "$variable='${valueOfVariable}${separator}${value}'"
                    # shellcheck disable=SC2163
                    export "$variable"
                    ;;
            esac
        fi
    fi
    return 0
} #}}}

#-------------------------------------------------------------------------------
#  DESCRIPTION: Removes value from env variable. The first parameter must be set,
#              rest is optional. If they are omitted then it'll be used PATH
#              as variable and : as separator.
#              It works with Bash and Ksh as well. But it does not work with Zsh yet.
#     SYNOPSIS: _rm4env values
#        USAGE: _rm4env value
#               _rm4env variable value
#               _rm4env variable variable separator
#               _rm4env variable=value
# REQUIREMENTS: perl
#      RETURNS: 0 if success, 1 otherwise
#-------------------------------------------------------------------------------
unset _rm4env
function _rm4env { #{{{
    if  [ $# -lt 1 ] || [ $# -gt 3 ]; then
        echo "Wrong number of arguments, must be 3 or fewer: value variable separator" >&2
        return 1
    else
        typeset value variable separator
        if [ $# -eq 1 ]; then
            value=${1}
            variable=PATH
            separator=:
        elif [ $# -eq 2 ]; then
            variable=$1
            value=$2
            separator=:
        else
            variable=$1
            value=$2
            separator=$3
        fi

        # _rm4env VARIABLE=value
        if [[ $value =~ = ]]; then
            variable=${value%=*}
            value=${value#*=}
            separator=${2:-:}
        fi

        typeset valueOfVariable=$(eval echo "$(printf "$%s" "$variable")")
        case $valueOfVariable in
            ${value}${separator}*|*${separator}${value}${separator}*|*${separator}${value}|$value)
                typeset newValue=$(echo "${valueOfVariable}" | perl -p -e "s#${separator}${value}|^${value}${separator}?##g")
                eval "$variable='$newValue'"
                # shellcheck disable=SC2163
                export "$variable"
                ;;
        esac
    fi
} #}}}
