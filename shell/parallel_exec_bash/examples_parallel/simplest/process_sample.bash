#! /bin/bash
echo > "f$1.tmp"
for ((i=0; i<=$1;i++)); do
   echo $((i*i)) >> "f$1.tmp"
done
