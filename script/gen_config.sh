#!/bin/bash
usage()
{

cat << EOF
    -s : storage template file
    -t : tracker template file
    -m : to be modified fastdfs file
EOF

}

function setOPTARG()
{
    local param=$1
    local optarg=$2
    if [ x"$optarg" = x"" ]; then
        echo "[ERROR] Empty option argument!"
        usage
        exit 1
    fi

    eval "$param=\$optarg" 
}

########## MAIN BODY ##########
basedir=$(cd `dirname $0`;pwd)

getoption=0
while getopts "s:t:m:" opt; do
    case $opt in
        s) 
            setOPTARG storage_tmp_file $OPTARG
            storage_real_file=${storage_tmp_file}_real
            cp $storage_tmp_file $storage_real_file
            ;;
        t) 
            setOPTARG tracker_tmp_file $OPTARG
            tracker_real_file=${tracker_tmp_file}_real
            cp $tracker_tmp_file $tracker_real_file
            ;;
        m)
            setOPTARG mod_fastdfs_file $OPTARG
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
if [ x"$storage_real_file" != x"" ]; then
    # Set port
    sed -i "/^\bport\b/c port = $STORAGE_PORT" $storage_real_file &>/dev/null
    if [ $? -ne 0 ]; then
        echo "[ERROR] Storage set failed!Set storage port failed!"
        exit 1
    fi
    # Set store path
    storage_path_arry=($(echo $STORAGE_PATHS))
    sed -i "/^\bstore_path_count\b/c store_path_count=${#storage_path_arry[@]}" $storage_real_file &>/dev/null
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
    sed -i "/^\btracker_server\b/c tracker_server = $TRACKER_ADDRESS" $storage_real_file
    if [ $? -ne 0 ]; then
        echo "[ERROR] Storage set failed!Set tacker server failed!"
        exit 1
    fi
    # Delete duplicated tracker_server
    storage_server_paths=($(sed -n "/^\btracker_server\b/=" $storage_real_file))
    sed -i "$storage_server_paths d" $storage_real_file &>/dev/null
fi

### Generate tracker file
if [ x"$tracker_real_file" != x"" ]; then
    tracker_port=${TRACKER_ADDRESS##*:}
    # Set port
    sed -i "/^\bport\b/c port = $tracker_port" $tracker_real_file &>/dev/null
    if [ $? -ne 0 ]; then
        echo "[ERROR] Tracker set failed!Set tacker port failed!"
        exit 1
    fi
    # Set base path
    sed -i "/^\bbase_path\b/c base_path = $TRACKER_PATH" $tracker_real_file &>/dev/null
    if [ $? -ne 0 ]; then
        echo "[ERROR] Tracker set failed!Set base path failed!"
        exit 1
    fi
fi

### Modify fastdfs file
if [ x"$mod_fastdfs_file" != x"" ]; then
    storage_path_arry=($(echo $STORAGE_PATHS))
    sed -i "/^\bbase_path\b/c base_path=$STORAGE_PATH" $mod_fastdfs_file &>/dev/null
    sed -i "/^\btracker_server\b/c tracker_server=$TRACKER_ADDRESS" $mod_fastdfs_file &>/dev/null
    sed -i "/^\bstorage_server_port\b/c storage_server_port=$STORAGE_PORT" $mod_fastdfs_file &>/dev/null
    sed -i "/^\burl_have_group_name\b/c url_have_group_name=true" $mod_fastdfs_file &>/dev/null
    sed -i "/^\bstore_path_count\b/c store_path_count=${#storage_path_arry[@]}" $mod_fastdfs_file &>/dev/null
    # Set store path
    storage_path_pos=$(sed -n "/^store_path0=/=" $mod_fastdfs_file)
    i=0
    j=$storage_path_pos
    while [ $i -lt ${#storage_path_arry[@]} ]; do
        sed -i "$j a store_path$i = ${storage_path_arry[$i]}" $mod_fastdfs_file &>/dev/null
        ((i++))
        ((j++))
    done
    sed -i "$storage_path_pos d" $mod_fastdfs_file
fi