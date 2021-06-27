#!/bin/sh

function usage {
  echo "Help information:

    --search Search by links and notes content

    --edit   Edit the target link and note
             Default using './links-and-notes' directory to store documents
    
    -h       Print help information
  "
}

if [ $# -le 1 ]; then
    echo "\nNot enough parameters passed.\n"
    usage
    exit 1
fi

while [ $# -gt 0 ]
do 
key="$1"
case $key in

    # when meet --search option break out of the loop
    --search)
      git grep -i --name-only "${2}"
    break
    ;;

    --edit)
      vim "${2}"
    break
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

