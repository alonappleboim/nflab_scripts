#!/bin/bash
# A wrapper script for handling multiple samples (in parallel).
#
# Each line in the input is a command executed in parallel, only after all the commands were successfuly executed
# the control will return to the calling process, and the output of the script is the same command list.
#
# Execution info is written to stderr.
#
# During execution a parallel-tmp folder is generated in cwd, and is deleted if execution was successful.
#
# Arguments
#  $1 - sbatch argument list, with <name>=<value> separated by "," default is
#       "mem=16GB,time=3:30:00,cpus-per-task=8"
#  $2 - 1/0 whethercommand are exeuted in parallel(1, default) or not(0)
#  $3 - file from which to read command lines instead of stdin.
#
# Scripts are executed using sh, but with appropriate #! they can be written in any language in the
# environment.
#
# USAGE: pre_process.bash | parallel_exec.bash | post_process.bash;
#
#

slurm=${2:-1};
SBV=${1:-"mem=16GB,time=3:30:00,cpus-per-task=8"};
input=${3:-/dev/stdin};
IFS=',' read -ra sb_vars <<< "$SBV" #split sbatch variables
mkdir parallel-tmp 2> /dev/null

#read input lines into an array
lines=();
while read line;
do
  lines+=("$line")
done < $input;

echo "handling samples..." > /dev/stderr;
status_all="ok";
success=();
for (( i=0; i<${#lines[@]}; i++ )); do
  comm="${lines[i]}"
  echo "  executing: $comm" > /dev/stderr;
  script="parallel-tmp/$i.sh"
  if [ $slurm = 1 ]; 
  then
    echo "#! /bin/bash" > $script
    for sbv in "${sb_vars[@]}"; do
      echo "#SBATCH --$sbv" >> $script
    done
    echo $comm >> $script
    tmp="$(sbatch $script)"
    jid="${tmp//[^0-9]/}"
    echo "  $comm -> $jid" > /dev/stderr;
    job_map[i]=$jid;
  else
    eval $comm;
    if [ $? -ne 0 ]; then
      status_all="error";
    else
      success+=(comm);
    fi
  fi
done

if [ $slurm = 1 ];
then
  echo "waiting for slurm jobs..." > /dev/stderr;
  for (( i=0; i<${#lines[@]}; i++ )); do
    jid=${job_map[i]};
    echo "  waiting for job $jid" > /dev/stderr;
    done="false";
    while [ $done == "false" ]; do
      sline=$(sacct -bnj $jid | head -1)
      IFS=' ' read -ra status <<< "$sline"
      status=${status[1]};
      if [ "$status" == "FAILED" ]; then
         echo "    job $jid failed" > /dev/stderr;
         done="error";
      fi
      if [ "$status" == "CANCELLED" ]; then
         echo "    job $jid cancelled" > /dev/stderr;
         done="error";
      fi
      if [ "$status" == "TIMEOUT" ]; then
         echo "    job $jid timedout" > /dev/stderr;
         done="error";
      fi
      if [ "$status" == "COMPLETED" ]; then
         echo "    job $jid completed" > /dev/stderr;
         done="done";
      fi
      sleep 0.1;
    done
    if [ "$done" == "error" ]; then
      status_all="error";
    else
      rm "slurm-$jid.out" #default slurm log name for job $jid, delete file if all went well.
      success+=(${lines[i]})
    fi
  done
fi

if [ "$status_all" == "error" ]; then
  echo "WARNING: error in one  (or more) of the jobs!!" > /dev/stderr;
else
  rm -Rf parallel-tmp
fi

echo "pass to post-processing..." > /dev/stderr;
for line in ${sucess[@]}; do 
  echo $line;
done;
