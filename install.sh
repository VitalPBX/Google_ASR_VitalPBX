#!/bin/bash
set -e
# Authors:      Rodrigo Cuadra
#               with Collaboration of Jose Miguel Rivera
#
# Support:      rcuadra@vitalpbx.com
#
echo -e "\n"
echo -e "************************************************************"
echo -e "*      Welcome to the VitalPBX Google ASR Integration      *"
echo -e "************************************************************"
yum install -y perl perl-libwww-perl perl-JSON perl-IO-Socket-SSL
cd /var/lib/asterisk/agi-bin/
wget https://raw.githubusercontent.com/VitalPBX/Google_ASR_VitalPBX/master/googleasr.agi
chown asterisk:asterisk googleasr.agi
chmod +x googleasr.agi
cd /etc/asterisk/ombutel
wget https://raw.githubusercontent.com/VitalPBX/Google_TTS_VitalPBX/master/extensions__60-google_asr.conf
asterisk -rx"dialplan reload"
echo -e "\n"
echo -e "************************************************************"
echo -e "*              Remember to edit the file                   *"
echo -e "*       /var/lib/asterisk/agi-bin/googleasr.agi            *" 
echo -e "*       and add the API key obtained from Google           *"
echo -e "*               For test dial *277 or *2770                *"
echo -e "************************************************************"
