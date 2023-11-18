#!/bin/bash

if [ $# -lt 1 ]
then
    echo "Usage : $0 integer"
    exit
fi

NUM=$1
echo "Testing ${NUM}"

if [[ ! $NUM =~ ^[0-9]+$ ]] ; then
    echo "Not an integer"
    exit
fi

case $NUM in
    0)
        echo "Zero!"
        ;;
    1)
        echo "One!"
        ;;
    ([2-9]|[1-7][0-9]|80) echo "From 2 to 80"
        ;;
    (8[1-9]|9[0-9]|100) echo "From 81 to 100"
        ;;
    *)
        echo "Too big!"
        ;;
esac

case  1:${NUM:--} in
(1:*[!0-9]*|1:0*[89]*)
    ! echo NAN
;;
($((NUM<81))*)
    echo "$NUM smaller than 80"
;;
($((NUM<101))*)
    echo "$NUM between 81 and 100"
;;
($((NUM<121))*)
    echo "$NUM between 101 and 120"
;;
($((NUM<301))*)
    echo "$NUM between 121 and 300"
;;
($((NUM>301))*)
    echo "$NUM greater than 301"
;;
esac