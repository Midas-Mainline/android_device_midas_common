#!/system/bin/sh

#rm /data/media/0/dev.log
#find /dev > /data/media/0/dev.log

#rm /data/media/0/config.log
#find /config > /data/media/0/config.log

#rm /data/media/0/dmesg.log
#dmesg > /data/media/0/dmesg.log

#{
#  date=`date +%F_%H-%M-%S`
#  logcat -v time -f /data/media/0/logcat_${date}.log 
#} &

sleep 60
reboot recovery
