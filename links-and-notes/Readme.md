This folder is used to store the reading or watching of useful links.

Design requirements:

1. Able to contain link name and URL

2. Able to adding note and repeat

3. Can be searched


Actions:

- Search Google Drive **notes** directory for legacy notes

    and move here

- Search commands

```
# search by file content
git grep -i --name-only PATTERN

# search by filename
git ls-files|grep -i PATTERN

# search by commit message
git log --walk-reflogs --grep PATTERN

```

- legacy migration

    Need to move legacy link and note from google drive **note** folder over.
