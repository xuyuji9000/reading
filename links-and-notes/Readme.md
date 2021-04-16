This folder is used to store useful links.

# Design requirements:

1. Able to contain link name and URL

2. Able to add about the link

3. Can be searched


- Search commands


``` shell
# search by file content
git grep -i --name-only PATTERN

# search by filename
git ls-files|grep -i PATTERN

# search by commit message
git log --walk-reflogs --grep PATTERN

```

- [helper.sh](./helper.sh)

    This script contains repeatly used command


- legacy migration
    

    Need to move legacy link and note from Google Drive **note** folder over.

- For content does not have permission to distribute

    Use Google Drive **note** folder to store and search.

