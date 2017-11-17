#!/bin/bash
# A wrapper script for handling multiple samples (in parallel).
#
# The script gets several arguments:
#  $1 - A path to a pre-processing script that is executed prior to sample-by-sample processing.
#       each line this script outputs is passed as an argument list to the sample-by-sample 
#       processing script.
#  $2 - A path to a sample-handling script, the input to this script are lines printed by
#       the previous script. For example if the given script is "echo", and the lines printed
#       are "12345" and "54321", then the commands executed are: "echo 12345; echo 54321".
#       If $4==1, these commands will be executed in parallel using slurm.
#  $3 - A path to a post-processing script that is executed only if all sample scripts were
#       successfully executed. All the lines from the pre-processing script are passed to
#       this script in the standard input.
#  $4 - A flag (0/1) indicating whether parallel SLURM sessions should be invoked. default=1(=yes).
#
# Scripts are executed using sh, but with appropriate #! they can be written in any language in the
# environment.
#
# USAGE: main.bash <preprocess> <sampleprocess> <postprocess> <0?/1>
#
#

slurm=${4:-1};

mkdir tmp 2> /dev/null

echo "executing pre processing script..."
mapfile -t lines < <(sh $1)

if [ $? -ne 0 ]; then
  echo "Error executing pre-processing script. aborting" 
  exit
fi

echo "handling samples..."
status_all="ok";
for (( i=0; i<${#lines[@]}; i++ )); do
  comm="$2 ${lines[i]}"
  echo "  executing: $comm";
  script="tmp/$i.sh"
  if [ $slurm = 1 ]; 
  then
    echo "#! /bin/bash" > $script
    echo "#SBATCH --mem=16GB" >> $script
    echo "#SBATCH --time=3:30:00" >> $script
    echo "#SBATCH --cpus-per-task=8" >> $script
    echo "sh " $comm >> $script
    tmp="$(sbatch $script)"
    jid="${tmp//[^0-9]/}"
    echo "  $comm -> $jid";
    job_map[i]=$jid;
  else
    sh $comm;
    if [ $? -ne 0 ]; then
      status_all="error";
    fi
  fi
done

if [ $slurm = 1 ];
then
  echo "waiting for slurm jobs..."
  for jid in "${job_map[@]}"
  do
    echo "  waiting for job $jid"
    done="false";
    while [ $done == "false" ]; do
      sline=$(sacct -bnj $jid | head -1)
      IFS=' ' read -ra status <<< "$sline"
      status=${status[1]};
      if [ "$status" == "FAILED" ]; then
         echo "    job $jid failed";
         done="error";
      fi
      if [ "$status" == "CANCELLED" ]; then
         echo "    job $jid cancelled";
         done="error";
      fi
      if [ "$status" == "TIMEOUT" ]; then
         echo "    job $jid timedout";
         done="error";
      fi
      if [ "$status" == "COMPLETED" ]; then
         echo "    job $jid completed";
         done="done";
      fi
      sleep 0.5;
    done
    if [ "$done" == "error" ]; then
      status_all="error";
    else
      rm "slurm-$jid.out" #default slurm log name for job $jid, delete file if all went well.
    fi
  done
fi

if [ "$status_all" == "error" ]; then
  echo "error in one of the jobs, aborting";
  exit;
fi

echo "post-processing..."
for (( i=0; i<${#lines[@]}; i++ )); do
  echo ${lines[i]};
done | (sh $3);
