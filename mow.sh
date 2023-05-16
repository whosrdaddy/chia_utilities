#!/bin/bash

# Specify the date (in YYYY-MM-DD format) before which files should be deleted
target_date="2023-05-12"

# Specify the disks or directories where you want to delete files
disks=(
    "/mnt/chia/jbod0/disk01"
    "/mnt/chia/jbod0/disk02"
    "/mnt/chia/jbod0/disk03"
    "/mnt/chia/jbod0/disk04"
    "/mnt/chia/jbod0/disk05"
    "/mnt/chia/jbod0/disk06"
    "/mnt/chia/jbod0/disk07"
    "/mnt/chia/jbod0/disk09"
    "/mnt/chia/jbod0/disk10"
    "/mnt/chia/jbod0/disk11"
    "/mnt/chia/jbod0/disk12"
    "/mnt/chia/jbod0/disk13"
    "/mnt/chia/jbod0/disk14"
    "/mnt/chia/jbod0/disk15"
    "/mnt/chia/jbod0/disk16"
    "/mnt/chia/jbod0/disk17"
    "/mnt/chia/jbod0/disk18"
    "/mnt/chia/jbod0/disk19"
    "/mnt/chia/jbod0/disk20"
    "/mnt/chia/jbod0/disk21"
    "/mnt/chia/jbod0/disk22"
    "/mnt/chia/jbod0/disk23"
    "/mnt/chia/jbod0/disk24"
)

# if we have 100G available, disk is not full
min_avail_KB=93543408


# Loop through each disk and delete files older than the target date
while true; do
  for disk in "${disks[@]}"; do
    # Check disk usage and delete another file if disk is full
    disk_avail=$(df "$disk" | awk 'FNR == 2 {print $4}')
    echo "Diskspace available on $disk: $disk_avail KB"

        if [ "$disk_avail" -lt "$min_avail_KB" ]; then
            echo "Disk is full. Deleting another file."
            find "$disk" -type f ! -newermt "$target_date" -print -quit | while read -r file; do
                echo "Deleting file: $file"
                rm "$file"
                break
            done
        else
            echo "Disk is not full, skipping..."

        fi
  done
 # wait 30 seconds to do another sweep
echo "waiting for 60 seconds..."
 sleep 60
done
