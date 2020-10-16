#!/bin/bash
# This script will run monthly as a cron job in order to automatically renew Vormetric Cert and notify account team as detailed in ticket #####-#####

LOG="/tmp/vrm_cert.log"

# Identify date & hostname

date > $LOG
hostname >> $LOG
echo '-------------------' >> $LOG

# Show expiration & renewal info

echo 'BEFORE' >> $LOG
echo ' ' >> $LOG
/opt/vormetric/DataSecurityExpert/agent/pkcs11/bin/vmutil -a pkcs11 certexpiry >> $LOG
echo ' ' >> $LOG
echo 'AFTER' >> $LOG
echo ' ' >> $LOG
/opt/vormetric/DataSecurityExpert/agent/pkcs11/bin/vmutil -a pkcs11 renewcerts >> $LOG
/opt/vormetric/DataSecurityExpert/agent/pkcs11/bin/vmutil -a pkcs11 certexpiry >> $LOG

# Email acct team and verify successful delivery
tail -16 $LOG | mail -s "Monthly Vormetric Cert Renewal" <user>@<domain>.com
sleep 30
echo ' '
echo 'Last messages sent to tjx@rackspace.com' >> $LOG
echo '---------------------------------------' >> $LOG
grep tjx@rackspace.com /var/log/mail* | tail -2 >> $LOG
