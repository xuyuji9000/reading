[find(1) — Linux manual page](https://man7.org/linux/man-pages/man1/find.1.html)

-exec command ;




-exec command {} +
    This variant of the -exec action runs the specified command on the selected files but the command line is built by appending each selected file name at the end; the total number of invocations of the command will be much less than the number of matched files.


-prune True, if the file is a directory, do not decend into it
