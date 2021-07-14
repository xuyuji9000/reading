[Bash Function Names Can Be Almost Anything](https://blog.dnmfarrell.com/post/bash-function-names-can-be-almost-anything/)

# Define my own pre-increment unary function

``` shell
#!/bin/bash
function ++ { (( $1++ )); }

a=1
++ a
echo $a
```

# Learn about `printf`[1]

The `-v` option tells `printf` not to print the output, but to assign it to the variable.

``` shell
#!/bin/bash

printf -v a "test"
echo $a
```


# Reference

1. [Bash printf Command](https://linuxize.com/post/bash-printf-command/)

