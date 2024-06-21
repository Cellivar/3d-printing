#!/bin/bash
# basic config
gpio-test.64 w h 12 1
alias ll='ls -l'

## Set the console log level to 3
echo 3 > /proc/sysrq-trigger

## Turn on wifi
echo 1 >/sys/devices/virtual/misc/sunxi-wlan/rf-ctrl/power_state
echo 1 >/sys/devices/virtual/misc/sunxi-wlan/rf-ctrl/scan_device

#mount -t ext4 /dev/mmcblk0p6 /data




# root@tierbox:/etc/modules-load.d# lsmod
# Module                  Size  Used by
# dc_sunxi               16384  0
# pvrsrvkm             1564672  1 dc_sunxi
# aic8800_fdrv          434176  0
# aic8800_btlpm          28672  0
# aic8800_bsp            90112  2 aic8800_fdrv,aic8800_btlpm
# uvcvideo              106496  0
# vin_v4l2              237568  0
# ov8858_r2a_4lane       16384  0
# vin_io                 94208  2 ov8858_r2a_4lane,vin_v4l2
# videobuf2_dma_contig    24576  1 vin_v4l2
# tsc2007                16384  0
# sunxi_gmac             45056  0





# ethernet
insmod /lib/modules/`uname -r`/sunxi_gmac.ko
# ctp
#Insmod /lib/modules/`uname -r`/gt9xxnew_ts.ko
insmod /lib/modules/`uname -r`/tsc2007.ko
# mipi camera
insmod /lib/modules/`uname -r`/videobuf2-core.ko
insmod /lib/modules/`uname -r`/videobuf2-memops.ko
insmod /lib/modules/`uname -r`/videobuf2-dma-contig.ko
insmod /lib/modules/`uname -r`/videobuf2-v4l2.ko
insmod /lib/modules/`uname -r`/vin_io.ko
insmod /lib/modules/`uname -r`/ov8858_r2a_4lane.ko
insmod /lib/modules/`uname -r`/vin_v4l2.ko
# usb uvc camera
insmod /lib/modules/`uname -r`/videobuf2-vmalloc.ko
insmod /lib/modules/`uname -r`/uvcvideo.ko
# wifi/bt
# Figure out what SDIO device Id
SDIO=`cat /sys/bus/sdio/devices/mmc2*1/device`
if [ $SDIO == "0x0145" ]; then
    insmod /lib/modules/`uname -r`/aic8800_bsp.ko
    insmod /lib/modules/`uname -r`/aic8800_btlpm.ko
    insmod /lib/modules/`uname -r`/aic8800_fdrv.ko
elif [ $SDIO == "0x0000" ];then
    insmod /lib/modules/`uname -r`/uwe5622_bsp_sdio.ko
    insmod /lib/modules/`uname -r`/sprdwl_ng.ko
    insmod /lib/modules/`uname -r`/sprdbt_tty.ko
fi
# ge8300 gpu
insmod /lib/modules/`uname -r`/pvrsrvkm.ko
insmod /lib/modules/`uname -r`/dc_sunxi.ko
# 5G modules
#insmod /lib/modules/`uname -r`/cdc_ncm.ko
#insmod /lib/modules/`uname -r`/cdc-wdm.ko
#insmod /lib/modules/`uname -r`/cdc_mbim.ko
# asound env
#amixer cset numid=14,iface=MIXER,name='Headphone Switch' on
#amixer cset numid=15,iface=MIXER,name='HpSpeaker Switch' on
#amixer cset numid=16,iface=MIXER,name='LINEOUT Switch' on
#amixer cset numid=12,iface=MIXER,name='ADCL Input MIC1 Boost Switch' on
#amixer cset numid=13,iface=MIXER,name='ADCR Input MIC2 Boost Switch' on
#amixer cset numid=2,iface=MIXER,name='ADC Swap' 0
#amixer cset numid=8,iface=MIXER,name='ADC volume' 255
#amixer cset numid=7,iface=MIXER,name='DAC volume' 255

# start adb
#adb_start.sh
# ov8858 isp
#camerademo NV21 640 480 30 bmp /tmp 1 &

. /etc/init.d/g_serial.sh

############################################################
#Must have this line to provent CRASH after ARM43 startup.
dhclient eth0 &
if [ -f /etc/wpa_supplicant/wpa_supplicant.conf ];then
        /sbin/wpa_supplicant -B -c/etc/wpa_supplicant/wpa_supplicant.conf -Dnl80211 -iwlan0 &
fi
#tiertime
#if [ ! -d /data/wifi ] && [ -d /root/data/wifi ];then
#    cp -a /root/data /
#fi


## Some kind of provision/updater script?

fstring=`date "+%Y%m%d%H%M%S"`
mFile=/tmp/${fstring}/dGllcmluaXQK.t
mkdir /tmp/${fstring}
if [ -b /dev/mmcblk1p2 ];then
    mount /dev/mmcblk1p2 /tmp/${fstring}
elif [ -b /dev/sda2 ] && blkid /dev/$1 |grep -q "ext4";then
    mount /dev/sda2 /tmp/${fstring}
fi
if [ -f $mFile ];then
        mkdir /tmp/${fstring}_r/
        unzip -X -P dGllcnRpbWUK $mFile -d /tmp/${fstring}_r/
        if [ -x /tmp/${fstring}_r/tier_init.sh ];then
         /tmp/${fstring}_r/tier_init.sh
         sync
         exit 0
        fi
else
        umount /tmp/${fstring}
fi

# If a printer is connected go right into klipperscreen, otherwise run wand server
#

FFD="NO"
for file in /dev/serial/by-id/*;do
        if [[ "$file" == *Klipper* ]];then
         FFD="YES"
        fi
done
if [ $FFD == "YES" ];then
        mFile=/home/tier/klipper/klippy/chelper/c_helper.so
        if [ -f ${mFile} ] && [ ! -s ${mFile} ];then
         rm -f ${mFile}
        fi
        if [ -L /etc/nginx/sites-enabled/default ];then
         rm -f /etc/nginx/sites-enabled/default
        fi
        ln -s /etc/nginx/sites-available/fluidd /etc/nginx/sites-enabled/fluidd
        systemctl restart nginx
    systemctl start ts_uinput crowsnest moonraker klipper KlipperScreen
else
    systemctl stop klipper KlipperScreen moonraker crowsnest ts_uinput
        if [ -L /etc/nginx/sites-enabled/fluidd ];then
         rm -f /etc/nginx/sites-enabled/fluidd
        fi
        ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
        systemctl restart nginx
        . /usr/helperboard/qt_env.sh
    if [ -x /root/Hippo/init.sh ];then
        /root/Hippo/init.sh &
    fi
fi

#usr/helperboard/qt/examples/BaijieDemo &
#run led
#led_run.sh &
