#!/bin/sh
#
#  Shellskript fr Aufruf allpstart/FOP.VKSTATISTIK.CRON
#
#  ts / alltrotec GmbH 05.03.2011
#
#cd /usr2/erp          ;
#eval `. ./denv.sh` ;
#export EKSPASSWORT=batchlg ;
logrotatedatei=$MANDANTDIR/rmtmp/P`date +%Y%m%d%H%M%S`
protokolldatei=$MANDANTDIR/allpstart/FOP.VKSTATISTIK.CRON.PROT
#  date +%Y%m%d%H%M%S
# Logrotation
if !(`test -f $protokolldatei`)
 then
         touch $protokolldatei;
fi
echo create >$logrotatedatei
echo '"'$protokolldatei'"' {  >>$logrotatedatei
echo rotate 5 >>$logrotatedatei
echo size=500000  >>$logrotatedatei
echo } >>$logrotatedatei
/usr/sbin/logrotate -s $MANDANTDIR/rmtmp/lstatus`date +%Y%m%d%H%M%S` $logrotatedatei
$HOMEDIR/bin/batchlg.sh -PASSARGS allpstart/FOP.VKSTATISTIK.CRON 1>>$protokolldatei 2>&1

