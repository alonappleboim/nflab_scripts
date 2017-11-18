#! /bin/bash
while read line
do
  echo "merging $line";
done < "/dev/stdin"

# ^not really using the input, just an example of how to do it

paste f*.tmp > all.tmp
rm f*.tmp
