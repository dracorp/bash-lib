# bash-lib

Various Bash functions. It could be used as a library.

## 00-env-functions.sh

A set of functions to manipulate env variables.

* _add2env - adds to env variable
* _rm4env  - removes from env variable

To add new variable simple use syntax:

    NODE_PATH="$HOME/opt/npm"

And then use syntax:

    _add2env $NODE_PATH/bin

It'll add a new value to the PATH at the end if not exist. You can use also use
syntax:

    _add2env value
    _add2env variable value
    _add2env variable value separator
    _add2env variable=value

In simplified form, this is a substitute for the syntax:

    variable=$variable:value

But with a pinch of magic.

_rm4env works similarly.

### TODO

- [ ] handle operators **+=** and **=+** 
- [ ] handle correctlly operator **=**, prorably it should assign instead of appending
