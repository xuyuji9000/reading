#!/bin/sh

function usage {
  echo "Help information:

    --content Search by links and notes content
  "
}

if [[ $# -le 0 ]]; then
    echo "\nNo parameter passed.\n"
    usage
    exit 1
fi

while [[ $# -gt 0 ]]
do 
key="$1"
case $key in
    --content)
    CONTENT="$2"
    shift
    shift 
    ;;

    -h)
    usage
    exit 0
    ;;

    *)
    echo "Unknow parameter."
    usage
    exit 1
    ;;
esac
done

git grep -i --name-only ${CONTENT}
