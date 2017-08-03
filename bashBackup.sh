#!/bin/bash

#script that compresses a folder into a tar.gz and moves it to a remote server
#keeps 7 daily backups at a time


#dependencies
        #lftp
        #tar

#config variables



remote_server='sftp://xxx.xxx.xxx.xxx'
remote_dir='/mnt/bkp_drive'
remote_port=''
remote_user=''
remote_password=''
local_directory='/mnt/FTP_drive/'

tmp_directory='/mnt/FTP_drive/tmp/'


#program variables

day=$(date +%A)

#start program

cd $tmp_directory

rm *.tar.gz # clear tmp folder

echo 'Compressing file'
tar -vczf $day.tar.gz $local_directory

echo 'Changing Permissions'
chmod 777 $day.tar.gz

echo 'Starting server transfer'
lftp -p $remote_port -u $remote_user,$remote_password $remote_server << --EOF--
        cd $remote_dir
        rm $day.tar.gz
        put $day.tar.gz
        quit
--EOF--

ls -lh
echo 'Removing temporary file'
rm *.tar.gz

echo 'All operations completed'
