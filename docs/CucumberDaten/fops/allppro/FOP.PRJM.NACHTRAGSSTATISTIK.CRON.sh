#!/bin/sh
#
#  Shellskript fr Aufruf allppro/FOP.PRJM.NACHTRAGSSTATISTIK.CRON
#
#  ts / alltrotec GmbH 09.03.2012
#
#cd /usr2/erp          ;
#eval `. ./denv.sh` ;
#export EKSPASSWORT=batchlg ;
logrotatedatei=$MANDANTDIR/rmtmp/P`date +%Y%m%d%H%M%S`
protokolldatei=$MANDANTDIR/allppro/FOP.PRJM.NACHTRAGSSTATISTIK.CRON.PROT
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
$HOMEDIR/bin/batchlg.sh -PASSARGS allppro/FOP.PRJM.NACHTRAGSSTATISTIK.CRON 1>>$protokolldatei 2>&1

