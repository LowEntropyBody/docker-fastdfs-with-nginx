#!/bin/bash
usage()
{

cat << EOF
    -s : storage template file
    -t : tracker template file
EOF

}

########## MAIN BODY ##########
basedir=$(cd `dirname $0`;pwd)

getoption=0
while getopts "s:t:" opt; do
    case $opt in
        s) 
            storage_tmp_file=$OPTARG
            storage_real_file=${storage_tmp_file}_real
            cp $storage_tmp_file $storage_real_file
            ;;
        t) 
            tracker_tmp_file=$OPTARG
            tracker_real_file=${tracker_tmp_file}_real
            cp $tracker_tmp_file $tracker_real_file
            ;;
        *) 
            echo "[ERROR] Invalid option!"
            usage
            exit 1
            ;;
    esac
    getoption=1
done

if [ $getoption -eq 0 ]; then
    usage
    exit 1
fi

### Generate storage file
# Set port
sed -i "/^port = /c port = $STORAGE_PORT" $storage_real_file &>/dev/null
if [ $? -ne 0 ]; then
    echo "[ERROR] Storage set failed!Set storage port failed!"
    exit 1
fi
storage_path_arry=($(echo $STORAGE_PATHS))
# Set store path
storage_path_pos=$(sed -n "/^store_path0/=" $storage_real_file)
i=0
j=$storage_path_pos
while [ $i -lt ${#storage_path_arry[@]} ]; do
    sed -i "$j a store_path$i = ${storage_path_arry[$i]}" $storage_real_file &>/dev/null
    ((i++))
    ((j++))
done
sed -i "$storage_path_pos d" $storage_real_file
# Set tracker server
sed -i "/^tracker_server = /c tracker_server = $TRACKER_ADDRESS" $storage_real_file
if [ $? -ne 0 ]; then
    echo "[ERROR] Storage set failed!Set tacker server failed!"
    exit 1
fi

### Generate tracker file
tracker_port=${TRACKER_ADDRESS##*:}
# Set port
sed -i "/^port = /c port = $tracker_port" $tracker_real_file &>/dev/null
if [ $? -ne 0 ]; then
    echo "[ERROR] Tracker set failed!Set tacker port failed!"
    exit 1
fi
# Set base path
sed -i "/^base_path = /c base_path = $TRACKER_PATH" $tracker_real_file &>/dev/null
if [ $? -ne 0 ]; then
    echo "[ERROR] Tracker set failed!Set base path failed!"
    exit 1
fi